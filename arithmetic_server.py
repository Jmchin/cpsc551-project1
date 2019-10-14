#!/usr/bin/python

# server.py

# connects to an xmlrpc server attempting to match on elements in
# polish notation form where the first element of the tuple is the
# operator, and the second and third elements are its operands


import re
from xmlrpc.client import ServerProxy, Error

with ServerProxy("http://localhost:8000", allow_none=True) as proxy:
    while True:
        # pass types to match as strings because we cannot marshall types explictly
        ops, a, b = proxy.arith._in([{"regexp" : "^[-+/*]$"}, {"class" : "Numeric"}, {"class":"Numeric"}])
        proxy.arith._out(["result", eval(f'{a} {ops} {b}')])
