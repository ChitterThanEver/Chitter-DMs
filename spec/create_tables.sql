CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  user_handle VARCHAR(30) NOT NULL UNIQUE,
  verified boolean
);

CREATE TABLE DMs (
  id SERIAL PRIMARY KEY,
  message_contents VARCHAR(500) NOT NULL,
  message_time TIMESTAMP default current_timestamp,
  sender_handle VARCHAR(30) NOT NULL REFERENCES users(user_handle),
  recipient_handle VARCHAR(30) NOT NULL REFERENCES users(user_handle)
);

CREATE TABLE blocked (
  id SERIAL PRIMARY KEY,
  sender_id int,
  recipient_id int,
  CONSTRAINT fk_sender_id foreign key(sender_id) references users(id) on delete cascade,
  CONSTRAINT fk_recipient_id foreign key(recipient_id) references users(id) on delete cascade
);