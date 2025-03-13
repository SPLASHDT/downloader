FROM python:3.13.2-alpine3.21


RUN mkdir -p /data/downloader
COPY requirements.txt APIDownload.sh cda_download.py download_SPLASH_data.sh credentials.sh downloader_crontab /data/downloader/
RUN pip install -r /data/downloader/requirements.txt && crontab /data/downloader/downloader_crontab && apk add bash wget coreutils
ENTRYPOINT /usr/sbin/crond -f

