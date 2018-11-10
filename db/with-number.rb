#!/usr/bin/env ruby
num = 0
File.foreach(ARGV[0], "\n\n", encoding:"utf-8") do |line|
  num += 1
  puts "#{num} #{line[0..20]}"
end
