#!/usr/bin/python

# client.py

# implements the arithmetic functions found at
# https://en.wikipedia.org/wiki/Rinda_(Ruby_programming_language)

from xmlrpc.client import ServerProxy, Error

with ServerProxy("http://localhost:8000", allow_none=True) as proxy:
    try:
        tuples = [("*", 2, 2), ("+", 2, 5), ("-", 9, 3)]
        for t in tuples:
            ops, a, b = t
            proxy.arith._out(ops, a, b)
            res = proxy.arith._in("result", None, None)
            print(f'{res[1]} = {t[1]} {t[0]} {t[2]}')
    except Error as e:
        print(f'Error: {e}')
