#!/usr/bin/python

# server.py
import re
from xmlrpc.client import ServerProxy, Error

with ServerProxy("http://localhost:8000") as proxy:
    try:
        proxy.arith._in(r'{^[-+/*]$', "Numeric", "Numeric")
