# Downloader for SPLASH

[![DOI](https://zenodo.org/badge/972658743.svg)](https://doi.org/10.5281/zenodo.15282624)

This code downloads the data required for SPLASH to operate.
There are two main parts one for downloading wave data from the Metoffice FTP 
server and one for wind data from the Metoffice's web API. To use this code you
will need credentials for both from the Metoffice.

## File purposes

 * APIDownload.sh  - run's the downloader for the wind data.
 * cda_download.py - Python code to download wind data from the Metoffice API.
 * credentials-example.sh - Place your credentials here and rename to credentials.sh
 * downloader_crontab  - crontab for running the download
 * download_SPLASH_data.sh - Downloads the wave data from the FTP server, starts the wind data download and clears old data.

## How to install the downloader

### Using Docker Compose (suggested)

Follow the instructions in the [splash-docker](https://github.com/SPLASHDT/splash-docker) 
repository. It will clone this repository (and the other SPLASH repositories), 
build the containers and allow them to be run using docker compose. 
This method requires the least effort!

### Using Docker

Make sure you have created/populated `credentials.sh` and then run:

```
docker build . -t splash/downloader:latest
```

This container includes a cron, if you leave the container running then it
will download data at the times specified in the crontab.

Before running the container create a volume:

```
docker volume create splash-data
```

and then run the container with this volume attached, this will allow 
downloaded data to persist.

```
docker run -d --mount type=volume,src=splash-data,dst=/data splash/downloader:latest
```

### Without Docker

#### Create a data directory

Create a location for downloaded data to be stored. By default this is assumed
to be `/data`. If you are storing the data somewhere else edit line 7 of 
`download_SPLASH_data.sh` and change the `BASEDIR` to your path. 

Copy/move all of thie repistory to your data directory.

#### Configuring the credentials

Place your FTP and web API credentials in `credentials-example.sh`, save it 
and rename it `credentials.sh`.

#### Configure a Python environment

Create a Python environment of your choice (e.g. venv or conda environment) and
install the dependencies by running:

```
pip install -r /data/downloader/requirements.txt
```

#### Activating the crontab

Activate the crontab to start the downloader runnning. It will run at every hour
divisble by 5 (e.g. 5am, 10am, 3pm and 8pm). This has been deliberately timed to 
match when data is typically available from the Metoffice.

```
crontab /data/downloader/downloader_crontab
```
