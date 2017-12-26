#!/usr/bin/env ruby
require 'sequel'

DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))


users = DB[:users]
File.foreach("midterm-paper.txt", encoding: "utf-8") do |line|
  next if line=~/^\*$/
  myid, midterm =  line.chomp.split
  users.where(myid: myid).update(midterm: midterm)
end
