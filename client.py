#!/usr/bin/python

# client.py

# implements the arithmetic functions found at
# https://en.wikipedia.org/wiki/Rinda_(Ruby_programming_language)

from xmlrpc.client import ServerProxy, Error

with ServerProxy("http://localhost:8000") as proxy:
    try:
        tuples = (("*", 2, 2), ("+", 2, 5), ("-", 9, 3))
        for t in tuples:
            proxy.microblog._out(t)
            res = proxy.microblog._in("result", None)
            print(f'{res[1]} = {t[1]} {t[0]} {t[2]}')
    except Error as e:
        print(f'Error: {e}')
