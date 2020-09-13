#!/usr/bin/env ruby

require 'sequel'
DB = Sequel.postgres('r99', user: 'user1',  password: 'pass1', host: 'localhost')

[[ 9502 , "s1a3013t"]
 [ 9501 , "s1a3028d"]
 [ 9500 , "s1a3029s"]
 [ 9508 , "s1a3079k"]
 [ 9509 , "s1a3080n"]
 [ 9507 , "s1a3094r"]
 [ 9505 , "s1a3096y"]
 [ 9515 , "s1a3112y"]
 [ 9506 , "s1a3119y"]
 [ 9503 , "s1a3122n"]
 [ 9510 , "s1a3129r"]
 [ 9504 , "s1a3137s"]
 [ 9513 , "s1a2147h"]
 [ 9512 , "s1a3081k"]
 [ 9514 , "s1a2040r"]
 [ 9516 , "s1a3092k"]].each do |r|
  DB.insert(myid: r[0], 
