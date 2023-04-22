-- 2 TASK

-- 2.2
--________________________________1________________________________
--Вывод номер групп и количество студентов, обучающихся в них
SELECT n_group, count(n_group) 
FROM student
GROUP BY n_group

--________________________________2________________________________
--Вывод для каждой группы максимальный средний балл
SELECT n_group, max(score) 
FROM student
GROUP BY n_group

--________________________________3________________________________
--Подсчёт количества студентов с каждой фамилией
SELECT count(DISTINCT surname)
FROM student
--DISTINCT - используется для удаления дубликатов из результирующего набора оператора SELECT

--________________________________4________________________________
--Подсчёт студентов, которые родились в каждом году
SELECT EXTRACT(year FROM date_birth), count(EXTRACT(year FROM date_birth)) 
FROM student
GROUP BY EXTRACT(year FROM date_birth) 
--EXTRACT извлекает отдельные части из даты или даты-времени

--________________________________5________________________________
--Для студентов каждого курса подсчитать средний балл
SELECT substr(CAST(n_group as text), 1, 1), avg(score) AverageScore
FROM student
GROUP BY substr(CAST(n_group as text), 1, 1)
--substr - извлекает из string начиная с from символа count символов

--________________________________6________________________________
--Для студентов заданного курса вывести один номер группы с максимальным средним баллом
SELECT n_group, max(score)
FROM student
WHERE CAST (n_group as text) LIKE '3%'
GROUP BY n_group
--CAST - используется для преобразования выражения из одного типа данных в другой тип данных

--________________________________7_______________________________
--Для каждой группы подсчитать средний балл, вывести на экран только те номера групп и их средний балл,
-- в которых он менее или равен 3.5. Отсортировать по от меньшего среднего балла к большему.
SELECT n_group, AVG(score)
FROM student
GROUP BY n_group
Having avg(student.score) <= 3.5
ORDER BY avg

--________________________________8_______________________________
--Для каждой группы в одном запросе вывести количество студентов, максимальный балл в группе, средний балл в группе, минимальный балл в группе
SELECT n_group, COUNT(name), MAX(score), AVG(score), MIN(score)
FROM student st
GROUP BY n_group
ORDER BY n_group DESC

--________________________________9_______________________________
--Вывести студента/ов, который/ые имеют наибольший балл в заданной группе
SELECT n_group, name 
FROM student
WHERE score = (SELECT max(score) 
FROM student) 
GROUP BY n_group, name
--________________________________10_______________________________
SELECT s.n_group, s.name, s.score
FROM student s
JOIN (
SELECT n_group, MAX(score) AS max_score
FROM student
GROUP BY n_group
) s_max ON s.n_group = s_max.n_group AND s.score = s_max.max_score
ORDER BY s.n_group;