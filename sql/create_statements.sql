CREATE STREAM IF NOT EXISTS pageviews WITH (kafka_topic='demo-pageviews', value_format='AVRO');
CREATE TABLE IF NOT EXISTS users (id STRING PRIMARY KEY) WITH (kafka_topic='demo-users', value_format='AVRO');
CREATE STREAM IF NOT EXISTS pageviews_female AS SELECT users.id AS userid, CAST(USERS.id as STRING) AS user_id, pageid, regionid, gender FROM pageviews LEFT JOIN users ON pageviews.userid = users.id WHERE gender = 'FEMALE' EMIT CHANGES;
CREATE STREAM IF NOT EXISTS accomplished_female_readers WITH (kafka_topic='demo-accomplished_female_readers', value_format='AVRO') AS SELECT * FROM pageviews_female WHERE CAST(SPLIT(PAGEID,'_')[2] as INT) >= 50 EMIT CHANGES;
