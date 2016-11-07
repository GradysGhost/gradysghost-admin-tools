#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from datetime import datetime as dt

if len(sys.argv) < 3:
  formatstr = "%Y-%m-%d %H:%M:%S"
else:
  formatstr = sys.argv[2]

if len(sys.argv) < 2:
  print("You gotta give me a Unix timestamp, dude!")
  sys.exit(1)

unixtime = float(sys.argv[1])
print(dt.fromtimestamp(unixtime).strftime(formatstr))
