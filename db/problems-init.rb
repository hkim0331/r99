#!/usr/bin/env ruby
require 'sequel'
DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))

now = Time.now()
problems = DB[:problems]
(1..99).each do |num|
   problems.insert(num: num, detail: "",
                  update_at: now, create_at: now)
end
