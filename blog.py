#!/usr/bin/python

# blog.py

# connects to an XML-RPC adapter server written in Ruby to interface
# with Ruby's Rinda tuplespace

from xmlrpc.client import ServerProxy, Error

with ServerProxy("http://localhost:8000") as proxy:
    try:
        # bob's blog
        proxy.microblog._out(["bob", "distsys", "I am studying chap 2"])
        proxy.microblog._out([
            "bob", "distsys", "The linda example's pretty simple"])
        proxy.microblog._out(["bob", "gtcn", "Cool book!"])

        # alice's blog
        proxy.microblog._out([
            "alice", "gtcn", "This graph theory stuff is not easy"])
        proxy.microblog._out(["alice", "distsys",
                              "I like systems more than graphs"])

        # chuck reads both blogs
        print(proxy.microblog._rd(["bob", "distsys", {"class" : "String"}]))
        print(proxy.microblog._rd(["alice", "gtcn", {"class" : "String"}]))
        print(proxy.microblog._rd(["bob", "gtcn", {"class" : "String"}]))
    except Error as e:
        print(f'Error: {e}')
