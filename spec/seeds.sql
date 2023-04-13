TRUNCATE TABLE users, dms, blocked RESTART IDENTITY;

INSERT INTO users 
    (user_handle, verified)
  VALUES
    ('Bob', false),
    ('Sam', true),
    ('Irene', true),
    ('Mary', true),
    ('George', false),
    ('Jim', true),
    ('Lucy', false);

INSERT INTO dms
    (message_contents, recipient_handle, sender_handle, message_time)
  VALUES
    ('Hello Bob', 'Bob', 'Sam', '2023-04-13 12:33:29'),
    ('Whats up?', 'Sam', 'Bob', '2023-04-13 12:35:41'),
    ('Good morning!', 'Irene', 'Mary', '2023-04-12 10:45:10'),
    ('Good afternoon!', 'Mary', 'Irene', '2023-04-12 12:45:19'),
    ('How are you?', 'George', 'Jim', '2023-04-14 14:11:11'),
    ('What are you up to?', 'George', 'Jim', '2023-04-14 15:01:59'),
    ('Not much', 'Jim', 'George', '2023-04-15 09:00:00'),
    ('Go away!', 'Lucy', 'Bob', '2023-04-13 17:29:59');

INSERT INTO blocked
    (sender_id, recipient_id)
  VALUES
    (1, 7);