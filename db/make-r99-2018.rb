#!/usr/bin/env ruby

num = 0
p = []
File.foreach("r99-2017.md") do |line|
  if line =~ /^\s*$/
    num += 1
    p[0].sub!(/^1\./, "#{num},")
    puts p.join
    puts
    p = []
  else
    p.push(line)
  end
end
