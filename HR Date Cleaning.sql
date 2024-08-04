#create database project ;
use project ;

select * from hr ;

alter table hr 
change column ï»¿id emp_id varchar(20) null ;

describe hr ;

select birthdate from hr ;

update hr
set birthdate = case
	when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
    else null
end ;

select birthdate from hr ;

alter table hr 
modify column birthdate date ;

select hire_date from hr ;

update hr
set hire_date = case
	when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
    else null
end ;

select hire_date from hr;

alter table hr
modify column hire_date date ;

select termdate from hr ;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

select termdate from hr ;
describe hr ;

select birthdate,(year(birthdate) - '2024-01-01') as age
from hr ;

select birthdate, timestampdiff(year,birthdate,curdate()) as age
from hr ;

alter table hr
add column age int ;

select * from hr ;

update hr
set age = timestampdiff(year,birthdate,curdate()) ;

select max(birthdate)
from hr ;

select count(age) from hr 
where age < 18 ;

select birthdate from hr 
where age < 18 ;

select gender, count(age) as count  from hr
where age > 18 and termdate = '0000-00-00'
group by gender 
 ;
select * from hr ;

select race,count(*) as count
from hr 
where age > 18 and termdate = '0000-00-00'
group by race
order by count desc ;

select * from hr ;

select 
	min(age) as youngest,
    max(age) as oldest
    from hr 
where age >= 18 and termdate = '0000-00-00'
;

select 
	case
		when age >= 18 and age<=24 then '18-24'
        when age >= 25 and age<=34 then '25-34'
        when age >= 35 and age<=44 then '35-44'
        when age >= 45 and age<=54 then '45-54'
        when age >= 55 and age<=64 then '55-64'
        else '65+'
    end as age_group,gender,
count(age) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by age_group,gender
order by age_group,gender ;

select location,count(location) as count
from hr 
where age >= 18 and termdate = '0000-00-00'
group by location ;

select 
	round(avg(datediff(termdate,hire_date))/365,0) as avg_length_of_employment
from hr 
where termdate < '2024-01-01' and age >=18
;

select 
	gender,department,jobtitle,
    count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by gender,department,jobtitle
order by gender,department ;

select 
	department,gender,
    count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by department,gender
order by department ;

select 
	jobtitle,
    count(jobtitle) as count 
from hr
where age >= 18 and termdate = '0000-00-00'
group by jobtitle 
order by jobtitle desc ;

select 
	department,
    total_count,
    terminated_count,
    terminated_count/total_count as termination_rate
from (
	select department,
    count(*) as total_count,
    sum(case when termdate <> '0000-00-00' and termdate <= curdate()then 1 else 0 end) as terminated_count
    from hr
    where age >= 18
    group by department
) as subquery
order by termination_rate desc ;

select 
    location_state,
    count(*) as employee_count
from hr 
where age >= 18 and termdate = '0000-00-00'
group by location_state
order by employee_count desc;

select distinct location_state
from hr 
where age >= 18 and termdate = '0000-00-00'
;

select
	year,
    hires,
    termination,
    hires - termination as net_change,
    round((hires - termination) / hires *100,2) as net_change_percent
from(
	select year(hire_date) as year,
    count(*) as hires,
    sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end ) as termination
    from hr
    where age >= 18
    group by year(hire_date)
) as subquery
order by year ;

select department,round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate <> curdate() and termdate <> '0000-00-00' and age >=18
group by department ;