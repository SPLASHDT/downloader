# SPDX-FileCopyrightText: © 2025 National Oceanography Centre and University of Plymouth

# SPDX-License-Identifier: MIT

FROM python:3.13.2-alpine3.21

#set the timezone so we get automatic adjustment to BST
RUN apk add tzdata && ln -s /usr/share/zoneinfo/Europe/London /etc/localtime

RUN mkdir -p /data/downloader && touch /data/downloader/cron.log
COPY requirements.txt APIDownload.sh cda_download.py download_SPLASH_data.sh credentials.sh downloader_crontab /data/downloader/
RUN pip install -r /data/downloader/requirements.txt && crontab /data/downloader/downloader_crontab && apk add bash wget coreutils
ENTRYPOINT /usr/sbin/crond && tail -f /data/downloader/cron.log


