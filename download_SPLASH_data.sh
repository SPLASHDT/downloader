#!/bin/bash

source ./credentials.sh

DATE=$(date '+%Y%m%d')
DIROUT='/data/data_inputs'

# Download waves from FTP
wget -c --no-verbose --user="$user" --password="$password" ftp://marineservices.metoffice.gov.uk/shelf-amm15/metoffice_wave_amm15_NWS_WAV_b$(date +\%Y\%m\%d)_hi*.nc -P "$DIROUT/wave/"

# Download winds from API
echo "running APIDownload.sh"
bash APIDownload.sh 2>&1
if [ $? -ne 0 ]; then
    echo "$(date) - Error running APIDownload.sh"
    exit 1
fi

# Copy wind data to the target directory
DIR='/data/downloader/downloaded/o104448053774_00'
mkdir -p $DIROUT/wind/
mv "$DIR/agl_wind-direction-from-which-blowing-surface-adjusted_10.0_+00.grib2"  "$DIROUT/wind/agl_wind-direction-$DATE.grib2"
mv "$DIR/agl_wind-speed-surface-adjusted_10.0_+00.grib2"  "$DIROUT/wind/agl_wind-speed-$DATE.grib2"

# cleanup old data
echo "Deleting old data"
find $DIROUT/wind -mmin +1440 -delete
find $DIROUT/wave -mmin +1440 -delete
