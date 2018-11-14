#!/usr/bin/env ruby
# coding: utf-8
# just a try
# make start will clear this.

require 'sequel'

raise "usage: $0 standard_file extra_file" unless ARGV.length ==2

DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))

num = 0
now = Time.now

# transaction で囲んでも処理時間は変わらない。
DB.transaction do
  File.foreach(ARGV[0], "\n\n", encoding: "utf-8") do |line|
    next if line =~ /^;/
    num += 1
    DB[:problems].insert(num: num, detail: line,
                         create_at: now, update_at: now)
    #  puts "#{num} #{line[0..30]}"
  end

  File.foreach(ARGV[1], "\n\n", encoding: "utf-8") do |line|
    next if line =~ /^;/
    num += 1
    DB[:problems].insert(num: num, detail: "[extra] "+ line,
                         create_at: now, update_at: now)
    #  puts "#{num} #{line[0..30]}"
  end

end
puts "total #{num} problems inserted"

# File.foreach(ARGV[0],"\n\n", encoding: "utf-8") do |line|
#   next if line =~ /^;/
#   num += 1
#   DB[:problems].where(num: num).update(detail: line, update_at: Time.now)
#   puts "#{num} #{short(line)}"
# end
#
# File.foreach(ARGV[1],"\n\n", encoding: "utf-8") do |line|
#   next if line =~ /^;/
#   num += 1
#   DB[:problems].where(num: num).update(detail: line, update_at: Time.now)
#   puts "#{num} #{short(line)}"
# end
