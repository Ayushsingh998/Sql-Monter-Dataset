use projects;

-- SQL Mentor User Performance

CREATE TABLE user_submissions (
    id SERIAL PRIMARY KEY,
    user_id BIGINT,
    question_id INT,
    points INT,
    submitted_at datetime ,
    username VARCHAR(50)
);

select * from user_submissions;

-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
-- Q.2 Calculate the daily average points for each user.
-- Q.3 Find the top 3 users with the most positive submissions for each day.
-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
-- Q.5 Find the top 10 performers for each week.

-- -------------------
-- My Solutions
-- -------------------


-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)

select 
username,
count(points) as total_submissions,
sum(points) as total__points
from user_submissions
group by 1
order by 2 desc;

-- Q.2 Calculate the daily average points for each user.

select 
username ,
date_format(submitted_at,'%d-%b') as day_month,
avg(points) as daily_avg
from user_submissions
group by 1,2
order by 1 ;

-- Q.3 Find the top 3 users with the most positive submissions for each day.

select * from (
select 
username,
date(submitted_at),
count(points) as possitive_submissions,
dense_rank() over(partition by username order by count(points) desc) as rnk
from user_submissions 
where points > 0 
group by 1,2 ) as x
where x.rnk = 1
order by x.possitive_submissions desc
limit 3;
 
-- Q.4 Find the top 5 users with the highest number of incorrect submissions.

select username,count(points) as incorrect_submissions
from user_submissions
where points < 0 
group by username 
order by 2 desc;

select 
username,
sum(case when points < 0 then 1 else 0 end ) as incorrect_submissions,
sum(case when points >= 0 then 1 else 0 end ) as correct_submissions,
sum(case when points < 0 then points else 0 end) as incorrect_points,
sum(case when points >= 0 then points else 0 end) as correct_points,
sum(points) as total_points
from user_submissions
group by 1
order by 2 desc;


-- Q.5 Find the top 10 performers for each week.

select * from (
select 
username,
week(submitted_at) as week_no,
sum(points) as total_points,
dense_rank() over(partition by week(submitted_at) order by sum(points) desc) rnk
from user_submissions
group by 1,2 ) as x
where x.rnk <= 10
