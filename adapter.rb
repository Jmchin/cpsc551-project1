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


def convToRuby(content)
  if content.class == Hash
    case content.keys[0]
    when "class"
      Module.const_get(content[content.keys[0]])
    when "regexp"
      Regexp.new(content[content.keys[0]])
    when "range"
      Range.new(content[content.keys[0]][0], content[content.keys[0]][1])
    end
  elsif content.class == String and content[0] == ":"
    content[1..content.length].to_sym
  else
    content
  end
end


class PythonBlogHandler
  def _out(list)
    converted = list.map { |e| convToRuby(e) }
    name, topic, content = converted
    if !BLOG_TOPICS[topic]     # if topic is not in blog_topics, add it
      BLOG_TOPICS[topic] = 1
      TS.write([name, topic, content, BLOG_TOPICS[topic]])
    else
      BLOG_TOPICS[topic] += 1  # else, increment counter for topic, append to tuple
      TS.write([name, topic, content, BLOG_TOPICS[topic]])
    end
    ""
  end

  def _in(list, idx=nil)

    # returns a new list of converted ruby types
    converted = list.map { |e| convToRuby(e) }
    name, topic, content = converted

    # given a specific channel
    if topic.class == String
      # ensure the channel exists
      if BLOG_TOPICS[topic]
        if idx == nil
          TS.take([name, topic, content, idx])
        elsif idx <= BLOG_TOPICS[topic]
          TS.take([name, topic, content, idx])
        else
          204  # non-existent entry
        end
      else
        404    # topic not in TS
      end
    else
      TS.take([name, topic, content, idx])
    end
  end

  def _rd(list, idx=nil)

    # returns a new list of converted ruby types
    converted = list.map { |e| convToRuby(e) }
    name, topic, content = converted
    # given a specific channel
    if topic.class == String
      # ensure the channel exists
      if BLOG_TOPICS[topic]
        if idx == nil
          TS.read([name, topic, content, idx])
        elsif idx <= BLOG_TOPICS[topic]
          TS.read([name, topic, content, idx])
        else
          204  # non-existent entry
        end
      else
        404    # topic not in TS
      end
    else
      TS.read([name, topic, content, idx])
    end
  end

end

class PythonArithHandler
  def _out (list)
    converted = list.map { |e| convToRuby(e) }
    TS.write(converted)
    "wrote #{converted} to TS"
  end

  def _in(list)
    converted = list.map { |e| convToRuby(e) }
    TS.take(converted)
  end

  def _rd(list)
    converted = list.map { |e| convToRuby(e) }
    TS.read(converted)
  end
end


# class PythonArithHandler
#   def _out(op, a, b)
#     TS.write(["#{op}",a, b])
#     "wrote" + " #{[op, a, b]} " + "to TS"
#   end

#   def _in(op, a, b)
#     if op == "result"
#       TS.take(["result", a, b])
#     else
#       # construct the regex translated from the python string
#       # NOTE: done this way since we cannot marshall python regexp?
#       pattern = Regexp.new(op)
#       TS.take([pattern, Module.const_get(a), Module.const_get(b)])
#     end
#   end

#   def _rd(op, a, b)
#     if op == "result"
#       TS.read(["result", a, b])
#     else
#       # construct the regex translated from the python string
#       # NOTE: done this way since we cannot marshall python regexp?
#       pattern = Regexp.new(op)
#       TS.read([pattern, Module.const_get(a), Module.const_get(b)])
#     end
#   end
# end


s.add_handler("microblog", PythonBlogHandler.new)
s.add_handler("arith", PythonArithHandler.new)
s.serve
