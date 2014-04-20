DELETE FROM users;
DELETE FROM questions;
DELETE FROM question_followers;
DELETE FROM replies;
DELETE FROM question_likes;

INSERT INTO
  users (fname, lname)
VALUES
  ('david','wu'),
  ('george', 'groh'),
  ('robert', 'baratheon'),
  ('arya', 'stark'),
  ('buck', 'shlegeris'),
  ('cj', 'avila'),
  ('will', 'hastings');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('dog?', 'how do i dog?', 4),
  ('whats the deal?', 'with all these dogs', 3),
  ('i dunno', 'what is going on in here', 4);

INSERT INTO
  question_followers (question_id, follower_id)
VALUES
  (2, 1),
  (2, 3),
  (2, 6),
  (3, 7),
  (3, 1),
  (3, 2),
  (3, 4);

INSERT INTO
  replies (question_id, parent_reply_id, user_id, body)
VALUES
  (2, NULL, 4, "you just do"),
  (2, 1, 4, "yeah, what she said");

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (1, 4),
  (3, 4),
  (3, 5),
  (3, 6);