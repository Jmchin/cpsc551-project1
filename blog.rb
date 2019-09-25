#!/usr/bin/ruby

# blog.rb
# implements functionality found in Note 2.3 (pg 69) of Distributed
# Systems

require 'rinda/rinda'

# each message for the blog is a 3-tuple <string, string, string>
# where the first string names the poster
# where the second string names the topic
# where the third string is the content

port = 61676
uri = "druby://localhost:#{port}"
DRb.start_service

# TupleSpaceProxy allows remote TS to appear as local to this process
# DRbObject.new(obj, uri) creates a new remote object stub, where the first
# argument is a LOCAL object we want to stub
blog = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, uri))

# bob's blog
blog.write(["bob", "distsys", "I am studying chap 2"])
blog.write(["bob", "distsys", "The linda example's pretty simple"])
blog.write(["bob", "gtcn", "Cool book!"])

# alice's blog
blog.write(["alice", "gtcn", "This graph theory stuff is not easy"])
blog.write(["alice", "distsys", "I like systems more than graphs"])

# chuck reads both the blogs
t1 = blog.read(["bob", "distsys", String])
t2 = blog.read(["alice", "gtcn", String])
t3 = blog.read(["bob", "gtcn", String])

# '#{ruby-code}' is ruby's syntax for string interpolation
puts "#{t1}"
puts "#{t2}"
puts "#{t3}"
