#!/usr/bin/env ruby

num = Hash.new(0)
(0..111).each do |n|
  num[n]=0
end
STDIN.readlines.each do |line|
  answered = line.strip.to_i
  num[answered] += 1
end
(0..111).each do |n|
  puts "#{n} #{num[n]}"
end
