#!/bin/bash
# SPDX-FileCopyrightText: © 2025 National Oceanography Centre and University of Plymouth
# SPDX-License-Identifier: MIT
source ./credentials.sh
python3 cda_download.py --runs 00 --apikey $apikey --orders=$order

