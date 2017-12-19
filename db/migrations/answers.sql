fcreate table answers (
       id integer primary key auto_increment,
       myid       integer not null,
       pid        integer not null,
       answer     text,
       update_at  timestamp);
