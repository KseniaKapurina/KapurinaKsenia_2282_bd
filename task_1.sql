-- 2 TASK

-- 2.1
--________________________________1________________________________
-- Вывод имен и фамилий студентов, средний балл которых от 4 до 4.5
-- 1 Способ
SELECT name, surname
FROM student
WHERE (score >= 4 AND score <= 4.5);
-- 2 Способ
SELECT name, surname
FROM student
WHERE(score between 4 AND 4.5);

--________________________________2________________________________
--Вывод студентов заданного курса (с использованием Like)
SELECT *
FROM student
WHERE CAST(n_group as text) LIKE '3%';
--CAST - используется для преобразования из одного типа данных в другой тип данных

--________________________________3________________________________
--Вывод студентов, предварительно осортировав по убыванию номера группы и имена от а до я
SELECT *
FROM student
ORDER BY n_group desc, name ASC;
--ORDER BY - Сортировка данных (по убыванию - ASC, по возрастанию - DESC)

--________________________________4________________________________
--Выод студентов, средний балл которых больше 4 и сортировка по баллу от большего к меньшему
SELECT *
FROM student
WHERE(score > 4)
ORDER BY score DESC;

--________________________________5________________________________
--Вывод названий и риск 2-х хобби
SELECT name, risk
FROM hobby
LIMIT 2;

--________________________________6________________________________
--Вывод id_hobby и id_student которые начали заниматься хобби между двумя заданными датами (выбрать самим) и студенты должны до сих пор заниматься хобби
SELECT student_id, hobby_id 
FROM student_hobby
WHERE date_start BETWEEN '1994-01-01' AND '2001-01-01' AND date_finishIS IS NOT NULL;

--________________________________7________________________________
--Вывод студентов, средний балл которых больше 4.5 и отсортировать по баллу от большего к меньшему
SELECT *
FROM student
WHERE(score > 4.5)
ORDER BY score DESC;

--________________________________8________________________________
--з запроса №7 вывод несколькими способами на экран только 5 студентов с максимальным баллом
--1 способ
SELECT *
FROM student
ORDER BY score DESC
LIMIT 5;
--2 способ

SELECT *
FROM student
ORDER BY SCORE
OFFSET 5;

--________________________________9________________________________
--Вывод хобби и с использованием условного оператора
SELECT name,
CASE
WHEN risk >= 8 THEN 'очень высокий риск'
WHEN risk >= 6 and risk < 8 THEN 'высокий риск'
WHEN risk >=4 and risk < 6 THEN 'средний риск'
WHEN risk >= 2 and risk < 4 THEN 'низкий риск'
When risk < 2 THEN 'очень низкий риск'
ELSE 'Возможно вы допустили ошибку'
End risk_category
FROM hobby;

--________________________________10________________________________
--Вывод 3 хобби с максимальным риском
SELECT name, risk
FROM hobby
ORDER BY risk DESC
LIMIT 3;