--2.3 Многотабличные запросы
--________________________________1___________________________________
--Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент
-- (student_hobby.student_id равен student.id и student_hobby.hobby_id равен hobby.id.)
SELECT st.name, st.surname, h.name
FROM student st INNER JOIN hobby h
ON st.id = h.id
--INNER JOIN – внутреннее соединение, выведет только те строки, если условие соединения выполняется (является истинным, т.е. TRUE).

--________________________________2___________________________________
--Вывести информацию о студенте, занимающимся хобби самое продолжительное время.
SELECT st.*, MIN(sh.date_start)
FROM student st INNER JOIN student_hobby sh
ON st.id = sh.id
WHERE (sh.date_finish IS Null)
GROUP BY st.id
ORDER BY MIN
LIMIT 1

--________________________________3___________________________________
--Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего,
-- а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9.
SELECT st.name, st.surname, st.date_birth, AVG(score), SUM(h.risk)
FROM student st INNER JOIN student_hobby sh
ON st.id = sh.student_id
INNER JOIN hobby h
ON sh.hobby_id = h.id
WHERE sh.date_finish IS NULL
GROUP BY st.name, st.surname, st.score, st.date_birth
HAVING SUM(h.risk) > 0.9 AND st.score > (SELECT AVG(score) FROM student)

--________________________________4___________________________________
--Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби Диапазон дат.
SELECT st.surname, st.name, h.name, 
extract (year from age(sh.date_finish, sh.date_start)) * 12 + extract(month from age(sh.date_finish, sh.date_start)) as month
FROM student st INNER JOIN student_hobby sh
ON st.id = sh.student_id
INNER JOIN hobby h
ON sh.hobby_id = h.id
WHERE (sh.date_finish is not NULL)
--Функция EXTRACT извлекает отдельные части из даты или даты-времени.


--________________________________5___________________________________
--Вывести фамилию, имя, зачетку, дату рождения студентов, которым исполнилось N полных лет на текущую дату,
-- и которые имеют более 1 действующего хобби.
SELECT st.surname, st.name, st.date_birth, COUNT(sh.hobby_id)
FROM student st INNER JOIN student_hobby sh
ON st.id = sh.student_id
WHERE extract(year from age(now()::date,st.date_birth))=20 AND (sh.date_finish IS Null)
GROUP BY st.surname, st.name, st.date_birth
HAVING COUNT(sh.hobby_id) > 1

--________________________________6___________________________________
--Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби
SELECT st.n_group, avg(st.score)
from student st, student_hobby sh
WHERE (sh.date_finish is not NULL)
GROUP BY n_group

--________________________________7___________________________________
--Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, указав номер зачетки студента.
Select h.name, h.risk, extract (year from age(now()::date, sh.date_start)) * 12 + extract(month from age(now()::date, sh.date_start)) as length_hobby, st.n_group
FROM hobby h INNER JOIN student_hobby sh
ON h.id = sh.hobby_id
INNER JOIN student st
ON sh.student_id = st.id
WHERE (sh.date_finish IS null)
ORDER BY sh.date_start ASC

--________________________________8___________________________________
--Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.
SELECT st.n_group, st.name,st.surname, h.name
FROM student st INNER JOIN student_hobby sh
ON st.id = sh.student_id
INNER JOIN hobby h
ON sh.hobby_id = h.id
WHERE sh.date_finish is not NULL
GROUP BY st.n_group, st.name, h.name, st.surname

--________________________________9___________________________________
--Найти все действующие хобби, которыми увлекаются троечники 2-го курса.
SELECT DISTINCT h.name
FROM student st INNER JOIN student_hobby sh
ON st.id = sh.student_id
INNER JOIN hobby h
ON sh.hobby_id = h.id
WHERE st.n_group::varchar LIKE '2%' 
AND st.score < 4.5 AND sh.date_finish IS NULL

--________________________________10___________________________________
--Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.
SELECT DISTINCT substr(st.n_group::varchar,1,1) AS n_course
FROM student st INNER JOIN student_hobby sh
ON st.id = sh.student_id
INNER JOIN hobby h
ON sh.hobby_id = h.id
WHERE (sh.date_finish IS Null)
GROUP BY st.surname, st.name, st.n_group
