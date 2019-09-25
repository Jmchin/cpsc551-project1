#!/usr/bin/ruby

# tuplespace.rb
# adapted from https://en.wikipedia.org/wiki/Rinda_(Ruby_programming_language)

require 'rinda/tuplespace'

port = 61676
uri = "druby://localhost:#{port}"

DRb.start_service(uri, Rinda::TupleSpace.new)
DRb.thread.join
