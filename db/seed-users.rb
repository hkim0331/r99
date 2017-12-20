#!/usr/bin/env ruby
require 'sequel'

DS = Sequel.mysql2("r99", user: "user", password: "pass")[:users]

File.foreach("sid-uid-myid-jname.txt",encoding: "utf-8") do |line|
  next if line=~/^\*$/
  sid, uid, myid, jname =  line.chomp.split
  DS.insert(myid: myid, sid: sid, jname: jname, password: "robocar", update_at: Time.now)
end
