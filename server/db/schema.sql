DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  product_id INTEGER, 
  body VARCHAR NOT NULL,
  date_written TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  asker_name VARCHAR (50) NOT NULL,
  asker_email VARCHAR (100) NOT NULL,
  reported INTEGER DEFAULT 0,
  helpful INTEGER DEFAULT 0
);

DROP TABLE IF EXISTS answers;
CREATE TABLE answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER, 
  body VARCHAR NOT NULL,
  date_written TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  answerer_name VARCHAR (50) NOT NULL,
  answerer_email VARCHAR (100) NOT NULL,
  reported INTEGER DEFAULT 0,
  helpful INTEGER DEFAULT 0,
  photos jsonb[] DEFAULT '{}'::jsonb[]
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
  id SERIAL PRIMARY KEY,
  answer_id INTEGER,
  url VARCHAR
);

\copy questions FROM './docker-entrypoint-initdb.d/csv/questions.csv' DELIMITERS ',' CSV HEADER;

\copy answers FROM './docker-entrypoint-initdb.d/csv/seeded_answers.csv' DELIMITERS ',' CSV HEADER;

\copy photos FROM './docker-entrypoint-initdb.d/csv/answers_photos.csv' DELIMITERS ',' CSV HEADER;

SELECT setval('questions_id_seq', (SELECT count(*) FROM questions), true);
SELECT setval('answers_id_seq', (SELECT count(*) FROM answers), true);
SELECT setval('photos_id_seq', (SELECT count(*) FROM photos), true);

ALTER TABLE questions RENAME COLUMN id TO question_id;
ALTER TABLE questions RENAME COLUMN body TO question_body;
ALTER TABLE questions RENAME COLUMN date_written TO question_date;
ALTER TABLE questions RENAME COLUMN helpful TO question_helpfulness;

ALTER TABLE answers RENAME COLUMN date_written TO date;
ALTER TABLE answers RENAME COLUMN helpful TO helpfulness;

CREATE INDEX product_id_idx ON questions (product_id);
CREATE INDEX question_id_idx ON answers (question_id);

