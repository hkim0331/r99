#!/usr/bin/env ruby
# just a try
# make start will clear this.
require 'sequel'
DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))
num = 0
File.foreach("r99-2017.md","\n\n", encoding: "utf-8") do |line|
  if line =~ /^1\. /
    num += 1
    DB[:problems].where(num: num).update(detail: line.sub(/1\. /,""),
                    update_at: Time.now)
  end
end

