require 'rinda/tuplespace'

uri = "druby://localhost:61676"
DRb.start_service(uri, Rinda::TupleSpace.new)
DRb.thread.join


# in => take
# rd => read
# out => write
