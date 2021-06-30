BEGIN;
SET max_parallel_workers_per_gather=4;
SET force_parallel_mode=on;

CREATE TABLE parallel_test(i int, c spoken_spoken_lang) WITH (parallel_workers = 4);
INSERT INTO parallel_test (i, c)
SELECT i, c.country
FROM generate_series(1,1e6) i,
LATERAL (SELECT CASE WHEN i % 3 = 0 THEN 'en'::spoken_spoken_lang
                     WHEN i % 3 = 1 THEN 'de'::spoken_spoken_lang
                     WHEN i % 3 = 2 THEN 'id'::spoken_spoken_lang
         END as country) c;

EXPLAIN (costs off,verbose)
SELECT COUNT(*) FROM parallel_test WHERE  c = 'id'::spoken_spoken_lang;

EXPLAIN (costs off,verbose)
SELECT c, COUNT(*) FROM parallel_test GROUP BY 1;
ROLLBACK;
