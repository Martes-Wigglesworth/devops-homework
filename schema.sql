CREATE TABLE users (
  id integer primary key autoincrement,
  username text not null,
  password text not null,
  token text not null);

INSERT INTO users (username, password, token) VALUES ('wcf', 'password123', 'wcftoken');