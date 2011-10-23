$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'genlib'

generator :read_array do |obj|
  (1..10).each do |e|
    obj._yield e
  end
end

for elem in generator(:read_array)
  puts "The element is : #{elem}"
end
