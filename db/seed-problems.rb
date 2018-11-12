#!/usr/bin/env ruby
# just a try
# make start will clear this.

require 'sequel'

raise "usage: $0 problem_file" unless ARGV.length ==1

def short(line)
  line[0..20]
end

DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))

num = 0
File.foreach(ARGV[0],"\n\n", encoding: "utf-8") do |line|
  next if line =~ /^;/
  num += 1
  DB[:problems].where(num: num).update(detail: line, update_at: Time.now)
  puts "#{num} #{short(line)}"
end
puts "total #{num} problems inserted"
