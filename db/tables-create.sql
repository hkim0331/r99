create table answers (
       id         serial primary key,
       myid       integer not null,
       num        integer not null,
       answer     text,
       timestamp  timestamp);

create table old_answers (
       id         serial primary key,
       myid       integer not null,
       num        integer not null,
       answer     text,
       timestamp  timestamp);

create table problems (
       id         serial primary key,
       num        integer not null unique,
       detail     text,    -- detail じゃないけど、2017 を継承して。
       timestamp  timestamp);

create table users (
       id         serial primary key,
       myid       integer not null unique,
       sid        varchar(8) unique,
       jname      varchar(30),
       password   varchar(30),
       timestamp  timestamp);


