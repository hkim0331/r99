create table problems (
       id integer primary key auto_increment,
       num integer not null unique,
       func varchar(30),
       detail text,
       update_at timestamp);
