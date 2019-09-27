#!/usr/bin/ruby

# arith.rb

# connects to a remote tuplespace, and takes any match where the first
# element is in the set {+-*/} and the second and third elements are
# numbers, writing the results of the first element applied as an
# operation to the second and third

require 'rinda/rinda'

URI = "druby://localhost:61676"
DRb.start_service
ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
loop do
  ops, a, b = ts.take([%r{^[-+/*]$}, Numeric, Numeric])
  ts.write(["result", a.send(ops, b)])
end
