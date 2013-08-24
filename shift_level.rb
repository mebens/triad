#!/usr/bin/env ruby

if ARGV.length < 3
  puts "Format: shift_level.rb level-name x-offset y-offset"
  exit 1
end

filepath = "assets/levels/#{ARGV[0]}.oel"
data = IO.read(filepath)
count = 0

data.gsub!(/x\=\"(\d+)\" y\=\"(\d+)\"/) do |s|
  count += 1
  "x=\"#{$1.to_i + ARGV[1].to_i}\" y=\"#{$2.to_i + ARGV[2].to_i}\""
end

file = File.new(filepath, "w")
file.write(data)
puts "Moved #{count} object#{count == 1 ? "" : "s"}"
