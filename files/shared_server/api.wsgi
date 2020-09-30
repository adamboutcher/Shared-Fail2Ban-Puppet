#!/usr/bin/python3.6

import logging
import sys
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, '/opt/f2bapi/lib/python3.6/site-packages')
sys.path.insert(1, '/opt/f2bapi/bin')
sys.path.insert(2, '/opt/f2bapi/')
from api import app as application
application.secret_key = 'JdatrSVqLPyv3J1OFwIcYYdLUorCvxIt'

