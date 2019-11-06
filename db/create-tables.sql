create table answers (
       id serial primary key,
       myid       integer not null,
       num        integer not null,
       answer     text,
       create_at  timestamp,
       update_at  timestamp);

create table old_answers (
       id serial primary key,
       myid       integer not null,
       num        integer not null,
       answer     text,
       create_at  timestamp);

create table problems (
       id serial primary key,
       num integer not null unique,
       detail text,    -- detail じゃないけど、2017 を継承して。
       create_at timestamp,
       update_at timestamp);

create table users (
       id serial primary key,
       myid       integer not null unique,
       sid        integer not null unique,
       jname      varchar(30),
       password   varchar(30),
       create_at  timestamp,
       update_at  timestamp);


