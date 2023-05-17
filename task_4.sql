--Удалите всех студентов с неуказанной датой рождения
DELETE FROM student
WHERE date_birth IS NULL;
--_________________________________________________________________________________
--Измените дату рождения всех студентов, с неуказанной датой рождения на 01-01-1999
UPDATE student
SET date_birth = '01-01-1999'
WHERE date_birth IS NULL;
--_________________________________________________________________________________
--Удалите из таблицы студента с номером зачётки 21
DELETE FROM student
WHERE id = 21;
--_________________________________________________________________________________
--Уменьшите риск хобби, которым занимается наибольшее количество человек
SELECT hobby_id,
    COUNT(*) AS count
FROM student_hobby
GROUP BY hobby_id
ORDER BY count DESC
LIMIT 1;
--тем самым находим хобби, которым занимается наибольшее количество человек
UPDATE hobby
SET risk = risk - 1
WHERE id = 5;
-- найденного хобби c id = 5, уменьшаем риск
--_________________________________________________________________________________
--Добавьте всем студентам, которые занимаются хотя бы одним хобби 0.01 балл
SELECT DISTINCT student_id
FROM student_hobby;
UPDATE student
SET score = score + 0.01
WHERE id IN (
        SELECT DISTINCT student_id
        FROM student_hobby
    );
--_________________________________________________________________________________
--Удалите все завершенные хобби студентов
SELECT id
FROM student_hobby
WHERE date_finish IS NOT NULL;
DELETE FROM student_hobby
WHERE id IN (
        SELECT id
        FROM student_hobby
        WHERE date_finish IS NOT NULL
    );
--_________________________________________________________________________________
--Добавьте студенту с id 4 хобби с id 5. date_start - '15-11-2009, date_finish - null
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_finish)
VALUES (4, 5, '2009-11-15', NULL);
--Напишите запрос, который удаляет самую раннюю из студентов_хобби запись, в случае, если студент делал перерыв в хобби (т.е. занимался одним и тем же несколько раз)
--_________________________________________________________________________________
--Поменяйте название хобби всем студентам, кто занимается футболом - на бальные танцы, а кто баскетболом - на вышивание крестиком.
UPDATE student_hobby
SET hobby_id = (
        SELECT id
        FROM hobby
        WHERE name = 'бальные танцы'
    )
WHERE hobby_id = (
        SELECT id
        FROM hobby
        WHERE name = 'футбол'
    );
UPDATE student_hobby
SET hobby_id = (
        SELECT id
        FROM hobby
        WHERE name = 'вышивание крестиком'
    )
WHERE hobby_id = (
        SELECT id
        FROM hobby
        WHERE name = 'баскетбол'
    );
--_________________________________________________________________________________
--Добавьте в таблицу хобби новое хобби с названием "Учёба"
INSERT INTO hobby (id, name, risk)
VALUES (9, 'Учёба', 1);
--У всех студентов, средний балл которых меньше 3.2 поменяйте во всех хобби (если занимается чем-либо) и добавьте (если ничем не занимается), что студент занимается хобби из 10 задания
--Переведите всех студентов не 4 курса на курс выше
UPDATE studentSET n_group = n_group + 1000
WHERE n_group < 4000 --Удалите из таблицы студента с номером зачётки 2
DELETE FROM student
WHERE id = 2;
--Измените средний балл у всех студентов, которые занимаются хобби более 10 лет на 5.00
UPDATE Student
SET score = 5.00WHERE id IN (
        SELECT sh.student_id
        FROM Student_hobby sh
            INNER JOIN Hobby h ON sh.hobby_id = h.id
        WHERE (current_timestamp - sh.date_start) > interval '10 years' --Удалите информацию о хобби, если студент начал им заниматься раньше, чем родился
        DELETE FROM Student_hobby
        WHERE student_id IN (
                SELECT sh.student_id
                FROM Student_hobby sh
                    JOIN Student s ON sh.student_id = s.id
                    JOIN Hobby h ON sh.hobby_id = h.id
                WHERE sh.date_start > s.date_birth