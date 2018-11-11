#!/usr/bin/env ruby
require 'sequel'

DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))

DB[:answers].insert(myid: 8999, num: 1, answer: "void hello_p(void) {
printf(\"hello,robocar\n\");
}", create_at: Time.now, update_at: Time.now)
