-- sailors who reserved at least one boat
SELECT S.name
FROM Sailors S, Reserves R
WHERE S.sid = R.sid

SELECT S.age, age1=S.age-5, 2*S.age AS age2 -- AS, = ways to name resulting fields
FROM Sailors S
WHERE S.sname LIKE `B_%s`  -- % >= 0 arbitary characters _ any single char

-- red or green boat reserved
SELECT S.sid
FROM Sailors S, Reserves R, Boats B
WHERE S.sid=R.sid AND R.bid=B.bid
AND (B.color='red' OR B.color='green')
-- Union can be used on two seperate colors

-- red and green
SELECT S.sid
FROM Sailors S, Reserves R, Boats B, Reserves R2, Boats B2
WHERE S.sid=R.sid AND R.bid=B.bid AND B.color='green'
AND S.sid=R2.sid AND R2.bid=B2.bid AND B2.color='red'
-- intersect can be used instead


-- nested way to find 103 reserved
SELECT S.sname
FROM Sailors S
WHERE S.sid IN (SELECT R.sid
                FROM Reserves R
                WHERE R.bid=103)
-- NOT IN to get sailors who did not reserve boar 103
-- EXISTS example
SELECT S.sname
FROM Sailors S
WHERE EXISTS (SELECT * -- get every column
              FROM Reserves R
              WHERE R.bid=103 AND S.sid=R.sid) -- use S from outer query

-- sailors raitings greater than someone called horatio
SELECT S.sname
FROM Sailors S
WHERE S.rating > ANY (SELECT S2.rating
                      FROM Sailors S2
                      WHERE S2.sname="Horatio")
-- use ALL instead to compare against all Horatio's

--Highest rating sailors
SELECT S.sname
FROM Sailors S
WHERE S.rating >= ALL (SELECT S2.rating
                       FROM Sailors S2)

-- IN same as =ANY
-- NOT IN same as <>ALL

19 20

19 20

19 20

19 20

19 20

19 20

19 20

-- Who reserved all boats
SELECT S.sname
FROM Sailors S
WHERE NOT EXISTS ((SELECT B.bid
                  FROM Boats B)
                  EXCEPT
                  SELECT R.bid
                  FROM Reserves R
                  WHERE S.sid=R.sid)
-- Sailors such that there are no reserve tuples that do not include their name for each boat
SELECT S.sname
FROM Sailors S
WHERE NOT EXISTS SELECT B.bid
                 FROM Boats B
                 WHERE NOT EXISTS SELECT R.bid
                                  FROM Reserves R
                                  WHERE R.sid=S.sid
                                  AND R.bid=B.bid
/*
COUNT
MIN A
MAX A
COUNT DISTINC A
SUM ~ ~
AVG ~ ~
A is a single column
*/

-- name and age of oldest
-- SELECT S.sname, MAX(S.age) cannot combine regular and aggregate
SELECT S.sname, S.age
FROM Sailors S
-- WHERE S.age = MAX(S.age) --where operates on single rows not aggregate without sub queries
WHERE S.age = (SELECT MAX(S2.age)
               FROM Sailors S2)

-- age of the youngest sailor with age>18 for each rating with >2 sailors like that
SELECT S.rating, MIN(S.age) AS Yage
FROM Sailors S
WHERE S.age >= 18
GROUP BY S.rating
HAVING COUNT(*) > 1
-- each group can only produce one row /tuple in the answer


-- for each read boat get number of reservations
SELECT B.bid, COUNT(*) AS rcount --aggregate operators work on groups separately
FROM Boats B, Sailors S, Reserves R
WHERE B.bid=R.bid AND R.sid=S.sid AND B.color="red"
GROUP BY B.bid

-- rating levels with the min average age
SELECT S.rating
FROM Sailors S
WHERE (SELECT AVG(S2.age)
       FROM Sailors S2
       WHERE S2.rating=S.rating) <= ALL (SELECT AVG(S3.age)
                                         FROM Sailors S3
                                         GROUP BY S3.rating)

SELECT S.sname, S.sid, (SELECT COUNT(*)
                       FROM Reserves R3
                       WHERE R3.sid=S.sid AND R3.day="10/10/96")
FROM Sailor S, Reserves R, Boats B, Reserves R2, Boats B2
WHERE S.sid=R.sid AND B.bid=R.bid AND B.color="red" AND R.day="10/10/96"
AND S.sid=R2.sid AND B2.bid=R2.bid AND B2.color="green" AND R2.day="10/10/96"
GROUP BY S.sid

-- for each rating level with at least 3 sailors, sailors with highest number of reservartions
SELECT S.rating
FROM S.

      SELECT S.rating
      FROM Sailors S
      GROUP BY S.rating
      HAVING Count(*) >= 3

SELECT S.sname
FROM Sailors S
WHERE (SELECT COUNT(*)
       FROM Reserves R
       WHERE R.sid=S.sid
       GROUP BY S.rating
       HAVING COUNT(*) >= 3) >= ALL (SELECT COUNT(*)
                                     FROM Reserves R2
                                     GROUP BY R2.sid)
