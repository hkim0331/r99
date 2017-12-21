#!/usr/bin/env ruby
require 'sequel'

DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))


problems = DB[:problems]
num = 0
File.foreach("r99.md","\n\n", encoding: "utf-8") do |line|
  if line =~ /^1\./
    num += 1
    problems.insert(num: num, detail: line.sub(/1\./,""), update_at: Time.now)
  end
end

users = DB[:users]
File.foreach("sid-uid-myid-jname.txt", encoding: "utf-8") do |line|
  next if line=~/^\*$/
  sid, uid, myid, jname =  line.chomp.split
  users.insert(myid: myid, sid: sid, jname: jname, password: "robocar", update_at: Time.now)
end
