#!/usr/bin/env ruby
require 'sequel'

DS = Sequel.mysql2("r99", user: "user", password: "pass")[:users]

File.foreach("sid-uid-myid-jname.txt") do |line|
  sid, uid, myid, jname =  line.chomp.split
  DS.insert(myid: myid, sid: sid, jname: jname, update_at: Time.now)
end
