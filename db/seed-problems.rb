#!/usr/bin/env ruby
require 'sequel'

DS = Sequel.mysql2("r99", user: "user", password: "pass")[:problems]

num = 0
File.foreach("r99.md","\n\n", encoding: "utf-8") do |line|
  if line =~ /^1\./
    num += 1
    DS.insert(num: num, detail: line.sub(/1\./,""), update_at: Time.now)
  end
end
