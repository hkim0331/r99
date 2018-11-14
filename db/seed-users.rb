#!/usr/bin/env ruby
# coding: utf-8
require 'sequel'

DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))

num = 0
now = Time.now
users = DB[:users]
# transaction で囲んでも処理時間は変わらない。
DB.transaction do
  File.foreach("sid-uid-myid-jname.txt", encoding: "utf-8") do |line|
    next if line =~ /^\*$/
    sid, _, myid, jname =  line.chomp.split(/\s+/,4)
    users.insert(myid: myid, sid: sid, jname: jname, password: "robocar",
                 create_at: now, update_at: now)
    num += 1
  end
end
puts "total #{num} users inserted"
