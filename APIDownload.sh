#!/bin/bash
source ./credentials.sh
python3 cda_download.py --runs 00 --apikey $apikey --orders=$order

