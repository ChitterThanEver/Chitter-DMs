CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  user_handle VARCHAR(30) NOT NULL UNIQUE,
  verified boolean
);

CREATE TABLE dms (
  id SERIAL PRIMARY KEY,
  message_contents VARCHAR(500) NOT NULL,
  message_time TIMESTAMP default current_timestamp,
  sender_handle VARCHAR(30) NOT NULL REFERENCES users(user_handle),
  recipient_handle VARCHAR(30) NOT NULL REFERENCES users(user_handle)
);

CREATE TABLE blocked (
  id SERIAL PRIMARY KEY,
  blocker_id int,
  blocked_id int,
  CONSTRAINT fk_blocker_id foreign key(blocker_id) references users(id) on delete cascade,
  CONSTRAINT fk_blocked_id foreign key(blocked_id) references users(id) on delete cascade
);