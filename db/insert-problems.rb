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
  num, problem = line.chomp.split(',')
  problems.insert(num: num, detail: problem.strip, update_at: now)
end
