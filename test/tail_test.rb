$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'genlib'

#define a tail generator
generator :tail do |yield_obj, file|
  file.seek(0, IO::SEEK_END)
  while true
    line = file.gets
    if not line
      sleep 0.01
      next
		end
    yield_obj._yield line
	end
end

#define a grep generator
generator :grep do |yield_obj, lines, search_text|
  for line in lines
    if line.include?(search_text)
      yield_obj._yield line
		end
	end
end

if ARGV.length == 2
  f = File.open(ARGV[0])
  tail_generator = generator(:tail, f)
  for line in generator(:grep, tail_generator, ARGV[1])
    puts line
  end
end