CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
	
	FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  follower_id INTEGER NOT NULL,
	
	FOREIGN KEY follower_id REFERENCES users(id),
	FOREIGN KEY question_id REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
	parent_reply_id INTEGER,
	user_id INTEGER NOT NULL,
	body TEXT NOT NULL,
	
	FOREIGN KEY question_id REFERENCES questions(id),
  FOREIGN KEY parent_reply_id REFERENCES replies(id),
  FOREIGN KEY user_id REFERENCES users(id),
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,
	
	FOREIGN KEY question_id REFERENCES questions(id),
  FOREIGN KEY user_id REFERENCES users(id)
);
