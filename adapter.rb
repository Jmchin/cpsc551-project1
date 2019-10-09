#!/usr/bin/ruby

# adapter.rb

# runs a server which listens for incoming XML-RPC requests, adapating
# them to work with the Rinda library

require 'rinda/rinda'
require 'xmlrpc/server'

# setup xml-rpc server listening for incoming requests
xmlport = 8000
s = XMLRPC::Server.new(xmlport)
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


# TODO: genrealize the third parameter, see Module.const_get(value)
# create handlers for _in, _out, _rd method calls from python

# any unseen topics being written to TS added to this hash
BLOG_TOPICS = Hash.new

class PythonBlogHandler
  def _out(name, topic, content)
    if !BLOG_TOPICS[topic]     # if topic is not in blog_topics, add it
      BLOG_TOPICS[topic] = 1
      TS.write(["#{name}", "#{topic}", "#{content}", BLOG_TOPICS[topic]])
    else
      BLOG_TOPICS[topic] += 1  # else, increment counter for topic, append to tuple
      TS.write(["#{name}", "#{topic}", "#{content}", BLOG_TOPICS[topic]])
    end
    ""
  end

  def _in(name, topic, content, idx=nil)
    # TODO: check name if matching on type keyword, then construct pattern type

    # ensure topic is in map of topics written to TS already
    if BLOG_TOPICS[topic]

      if idx == nil
        "#{TS.take([name, topic, String, nil])}"
      else
        if idx <= BLOG_TOPICS[topic]
            "#{TS.take([name, topic, String, idx])}"
        else
          nil  # client requests non-existent entry
        end
      end

    else
      nil  # topic not in TS
    end
  end

  def _rd(name, topic, content, idx=nil)
    # TODO: check name if matching on type keyword, then construct pattern type

    # ensure topic is in map of topics written to TS already
    if BLOG_TOPICS[topic]

      if idx == nil
        "#{TS.read([name, topic, String, nil])}"
      else
        if idx <= BLOG_TOPICS[topic]
            "#{TS.read([name, topic, String, idx])}"
        else
          nil  # client requests non-existent entry
        end
      end

    else
      nil  # topic not in TS
    end
  end

end


class PythonArithHandler
  def _out(op, a, b)
    TS.write(["#{op}",a, b])
    "wrote" + " #{[op, a, b]} " + "to TS"
  end

  def _in(op, a, b)
    if op == "result"
      TS.take(["result", a, b])
    else
      # construct the regex translated from the python string
      # NOTE: done this way since we cannot marshall python regexp?
      pattern = Regexp.new(op)
      TS.take([pattern, Module.const_get(a), Module.const_get(b)])
    end
  end

  def _rd(op, a, b)
    if op == "result"
      TS.read(["result", a, b])
    else
      # construct the regex translated from the python string
      # NOTE: done this way since we cannot marshall python regexp?
      pattern = Regexp.new(op)
      TS.read([pattern, Module.const_get(a), Module.const_get(b)])
    end
  end
end


s.add_handler("microblog", PythonBlogHandler.new)
s.add_handler("arith", PythonArithHandler.new)
s.serve
