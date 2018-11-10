#!/usr/bin/env ruby
require 'sequel'

DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))

now = Time.now()
problems = DB[:problems]
File.foreach(ARGV[0], encoding: "utf-8") do |line|
  next if line =~ /^\s*$/
  num, detail = line.chomp.split(',', 2)
  problems.where(num: num,) detail: detail,
                  update_at: now, create_at: now)
end
