#!/usr/bin/env ruby
require 'sequel'

DB = Sequel.postgres("r99",
                   username: (ENV["R99_USER"] or "user1"),
                   password: (ENV["R99_PASS"] or "pass1"),
                   host: (ENV["R99_HOST"] or "localhost"))

DS = DB[:problems]
DS.each do |row|
  id = row[:id]
  detail = row[:detail].gsub(/\[\]/,"[ ]")
  DS.where(id: id).update(detail: detail)
end
