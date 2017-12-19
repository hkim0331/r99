create table users (
       id integer primary key auto_increment,
       myid       integer not null unique,
       sid        integer not null unique,
       jname      varchar(30),
       password   varchar(30),
       update_at  timestamp);

