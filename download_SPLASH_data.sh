#!/bin/bash
# SPDX-FileCopyrightText: © 2025 National Oceanography Centre and University of Plymouth
# SPDX-License-Identifier: MIT

source ./credentials.sh

DATE=$(date '+%Y%m%d')
BASEDIR='/data'
DIROUT=$BASEDIR'/data_inputs'

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
DIR=$BASEDIR'/downloader/downloaded/o104448053774_00'
mkdir -p $DIROUT/wind/
mv "$DIR/agl_wind-direction-from-which-blowing-surface-adjusted_10.0_+00.grib2"  "$DIROUT/wind/agl_wind-direction-$DATE.grib2"
mv "$DIR/agl_wind-speed-surface-adjusted_10.0_+00.grib2"  "$DIROUT/wind/agl_wind-speed-$DATE.grib2"

#check if new downloads succeeded 
wave_download_success="0"
wind_download_success="0"

# there should be 8 wave netcdf files
if [ `ls $DIROUT/wave/metoffice_wave_amm15_NWS_WAV_b$(date +\%Y\%m\%d)_hi*.nc | wc -l` = "8" ] ; then
    wave_download_success="1"
    echo "All wave data downloaded successfully"
    yesterday=$DIROUT/wave/metoffice_wave_amm15_NWS_WAV_b$(date +\%Y\%m\%d)_hi$(date -d "1 day ago" +\%Y\%m\%d).nc
    day_before_yesterday=$DIROUT/wave/metoffice_wave_amm15_NWS_WAV_b$(date +\%Y\%m\%d)_hi$(date -d "2 days ago" +\%Y\%m\%d).nc
    echo "removing un-needed files: $yesterday and $day_before_yesterday"
    rm $yesterday $day_before_yesterday
else 
    wave_download_success="0"
    echo "Wave data did not download successfully"
fi

# and two wind grib files
if [ `ls $DIROUT/wind/agl_wind-*-$(date +\%Y\%m\%d).grib2 | wc -l` = "2" ] ; then
    wind_download_success="1"
    echo "All wind data downloaded successfully"
else
    wind_download_success="0"
    echo "Wind data did not download successfully"
fi

# cleanup old data, but only if new download succeeded
if [ "$wave_download_success" = "1" -a "$wind_download_success" = "1" ] ; then
    echo "Deleting old data"
    find $DIROUT/wind -maxdepth 1 -type f -mmin +1440 -delete -print
    find $DIROUT/wave -maxdepth 1 -type f -mmin +1440 -delete -print
fi
