require 'rinda/rinda'

URI = "druby://localhost:61676"
DRb.start_service
ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
tuples = [["*", 2, 2], ["+", 2, 5], ["-", 9, 3]]
tuples.each do |t|
  ts.write(t)
  res = ts.take(["result", nil])
  puts "#{res[1]} = #{t[1]} #{t[0]} #{t[2]}"
end
