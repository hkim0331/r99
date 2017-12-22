create table answers (
       id integer primary key auto_increment,
       myid       integer not null,
       pid        integer not null,
       answer     text,
       update_at  timestamp);

create table users (
       id integer primary key auto_increment,
       myid       integer not null unique,
       sid        integer not null unique,
       jname      varchar(30),
       password   varchar(30),
       update_at  timestamp);

create table problems (
       id integer primary key auto_increment,
       num integer not null unique,
       func varchar(30),
       detail text,
       update_at timestamp);

