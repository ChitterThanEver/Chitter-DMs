CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  handle VARCHAR(30) NOT NULL UNIQUE,
  verified boolean
);

CREATE TABLE dms (
  id SERIAL PRIMARY KEY,
  contents VARCHAR(500) NOT NULL,
  time TIMESTAMP default current_timestamp,
  sender_handle VARCHAR(30) NOT NULL REFERENCES users(handle),
  recipient_handle VARCHAR(30) NOT NULL REFERENCES users(handle)
);

CREATE TABLE blocked (
  id SERIAL PRIMARY KEY,
  blocker_id int,
  blocked_id int,
  CONSTRAINT fk_blocker_id foreign key(blocker_id) references users(id) on delete cascade,
  CONSTRAINT fk_blocked_id foreign key(blocked_id) references users(id) on delete cascade
);