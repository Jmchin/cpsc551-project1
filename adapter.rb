#!/usr/bin/ruby

# adapter.rb

# runs a server which listens for incoming XML-RPC requests, adapating
# them to work with the Rinda library

require 'rinda/rinda'
require 'xmlrpc/server'

# setup xml-rpc server listening for incoming requests
xmlport = 8000
s = XMLRPC::Server.new(8000)
puts "Listening on port 8000..."

# connect to the remote tuplespace
tsport = 61676
tsuri = "druby://localhost:#{tsport}"
DRb.start_service
TS = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, tsuri))
puts "Connected to tuplespace #{TS}"


# allow nil values to be passed to the XML-RPC server
def suppress_warnings
  previous_VERBOSE, $VERBOSE = $VERBOSE, nil
  yield
  $VERBOSE = previous_VERBOSE
end

suppress_warnings do
  XMLRPC::Config::ENABLE_NIL_PARSER = true
  XMLRPC::Config::ENABLE_NIL_CREATE = true
end


# create handlers for _in, _out, _rd method calls from python
class PythonBlogHandler
  def _out(name, topic, content)
    TS.write(["#{name}", "#{topic}", "#{content}"])
    ""
  end
  def _in(name, topic, content)
   "#{TS.take([name, topic, String])}"
  end
  def _rd(name, topic, content)
    "#{TS.read([name, topic, String])}"
  end
end

class PythonArithHandler
  def _out(op, a, b)
    TS.write(["#{op}", "#{a}", "#{b}"])
    # "Not implemented"
  end
  def _in(op, a, b)
    "#{TS.take([op, a, b])}"
    # "Not implemented"
  end
  def _rd(op, a, b)
    "Not implemented"
  end
end


s.add_handler("microblog", PythonBlogHandler.new)
s.add_handler("arith", PythonArithHandler.new)
s.serve
