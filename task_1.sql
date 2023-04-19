-- 2 Task
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
SELECT name,risk
FROM hobby
LIMIT 2;

--________________________________6________________________________


