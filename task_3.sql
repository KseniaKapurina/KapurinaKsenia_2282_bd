--2.3 Многотабличные запросы
--________________________________1___________________________________
--Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент
-- (student_hobby.student_id равен student.id и student_hobby.hobby_id равен hobby.id.)
SELECT st.name,
    st.surname,
    h.name
FROM student st
    INNER JOIN hobby h ON st.id = h.id --INNER JOIN – внутреннее соединение, выведет только те строки, если условие соединения выполняется (является истинным, т.е. TRUE).
    --________________________________2___________________________________
    --Вывести информацию о студенте, занимающимся хобби самое продолжительное время.
SELECT st.name,
    st.surname,
    h.name AS hobby_name,
    MAX(sh.date_finish - sh.date_start) AS duration
FROM student st
    JOIN student_hobby sh ON st.id = sh.student_id
    JOIN hobby h ON sh.hobby_id = h.id
GROUP BY st.id,
    h.id
ORDER BY duration DESC
LIMIT 1;
--________________________________3___________________________________
--Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего,
-- а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9.
SELECT st.name,
    st.surname,
    st.date_birth,
    AVG(score),
    SUM(h.risk)
FROM student st
    INNER JOIN student_hobby sh ON st.id = sh.student_id
    INNER JOIN hobby h ON sh.hobby_id = h.id
WHERE sh.date_finish IS NULL
GROUP BY st.name,
    st.surname,
    st.score,
    st.date_birth
HAVING SUM(h.risk) > 0.9
    AND st.score > (
        SELECT AVG(score)
        FROM student
    ) --________________________________4___________________________________
    --Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби Диапазон дат.
SELECT st.surname,
    st.name,
    h.name,
    extract (
        year
        from age(sh.date_finish, sh.date_start)
    ) * 12 + extract(
        month
        from age(sh.date_finish, sh.date_start)
    ) as month
FROM student st
    INNER JOIN student_hobby sh ON st.id = sh.student_id
    INNER JOIN hobby h ON sh.hobby_id = h.id
WHERE (sh.date_finish is not NULL) --Функция EXTRACT извлекает отдельные части из даты или даты-времени.
    --________________________________5___________________________________
    --Вывести фамилию, имя, зачетку, дату рождения студентов, которым исполнилось N полных лет на текущую дату,
    -- и которые имеют более 1 действующего хобби.
SELECT st.surname,
    st.name,
    st.date_birth,
    COUNT(sh.hobby_id)
FROM student st
    INNER JOIN student_hobby sh ON st.id = sh.student_id
WHERE extract(
        year
        from age(now()::date, st.date_birth)
    ) = 20
    AND (sh.date_finish IS Null)
GROUP BY st.surname,
    st.name,
    st.date_birth
HAVING COUNT(sh.hobby_id) > 1 --________________________________6___________________________________
    --Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби
SELECT st.n_group,
    avg(st.score)
from student st,
    student_hobby sh
WHERE (sh.date_finish is not NULL)
GROUP BY n_group --________________________________7___________________________________
    --Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, указав номер зачетки студента.
Select h.name,
    h.risk,
    extract (
        year
        from age(now()::date, sh.date_start)
    ) * 12 + extract(
        month
        from age(now()::date, sh.date_start)
    ) as length_hobby,
    st.n_group
FROM hobby h
    INNER JOIN student_hobby sh ON h.id = sh.hobby_id
    INNER JOIN student st ON sh.student_id = st.id
WHERE (sh.date_finish IS null)
ORDER BY sh.date_start ASC --________________________________8___________________________________
    --Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.
SELECT st.n_group,
    st.name,
    st.surname,
    h.name
FROM student st
    INNER JOIN student_hobby sh ON st.id = sh.student_id
    INNER JOIN hobby h ON sh.hobby_id = h.id
WHERE sh.date_finish is not NULL
GROUP BY st.n_group,
    st.name,
    h.name,
    st.surname --________________________________9___________________________________
    --Найти все действующие хобби, которыми увлекаются троечники 2-го курса.
SELECT DISTINCT h.name
FROM student st
    INNER JOIN student_hobby sh ON st.id = sh.student_id
    INNER JOIN hobby h ON sh.hobby_id = h.id
WHERE st.n_group::varchar LIKE '2%'
    AND st.score < 4.5
    AND sh.date_finish IS NULL --________________________________10___________________________________
    --Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.
SELECT DISTINCT substr(st.n_group::varchar, 1, 1) AS n_course
FROM student st
    INNER JOIN student_hobby sh ON st.id = sh.student_id
    INNER JOIN hobby h ON sh.hobby_id = h.id
WHERE (sh.date_finish IS Null)
GROUP BY st.surname,
    st.name,
    st.n_group --________________________________11___________________________________
    --Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.
SELECT st.n_group
FROM student st
WHERE st.score >= 4
GROUP BY st.n_group
HAVING AVG(
        CASE
            WHEN st.score >= 4 THEN 1
            ELSE 0
        END
    ) >= 0.6;
--________________________________12___________________________________
--Для каждого курса подсчитать количество различных действующих хобби на курсе.
Select LEFT(n_group::text, 1),
    COUNT(DISTINCT(hobby.name))
From student
    INNER JOIN student_hobby ON student.id = student_hobby.student_id
    INNER JOIN hobby ON hobby.id = student_hobby.hobby_id,
    WHERE (student_hobby.date_finish is NULL)
GROUP BY n_group
ORDER BY n_group --________________________________13___________________________________
    --Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби. Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.
Select LEFT(n_group::text, 1),
    student.surname,
    student.name,
    student.date_birth
From student
    INNER JOIN student_hobby ON student.id = student_hobby.student_id
    INNER JOIN hobby ON hobby.id = student_hobby.hobby_id
WHERE (
        score = 5
        and student_hobby.student_id is null
    )
GROUP BY n_group,
    student.surname,
    student.name,
    student.date_birth
ORDER BY n_group DESC,
    date_birth --________________________________14___________________________________
    --Создать представление, в котором отображается вся информация о студентах, которые продолжают заниматься хобби в данный момент и занимаются им как минимум 5 лет.
CREATE OR REPLACE VIEW Students AS
SELECT student.id,
    student.surname,
    student.name,
    student.n_group,
    student.date_birth
FROM student
    INNER JOIN student_hobby ON student.id = student_hobby.student_id
    INNER JOIN hobby ON hobby.id = student_hobby.hobby_id
WHERE student_hobby.date_finish is null
    and extract(
        year
        from age(CURRENT_DATE, date_birth)
    ) >= 5 --________________________________15___________________________________
    --Для каждого хобби вывести количество людей, которые им занимаются.
SELECT h.name,
    COUNT(sh.student_id) AS stud_on_hobby
FROM student_hobby sh
    inner join hobby h ON sh.hobby_id = h.id
GROUP BY hobby_id,
    h.name
ORDER BY stud_on_hobby DESC --________________________________16___________________________________
    --Вывести ИД самого популярного хобби.
SELECT h.id as most_popular_hobby_id
FROM student_hobby sh
    INNER JOIN hobby h ON sh.hobby_id = h.id
GROUP BY h.id
ORDER BY COUNT(sh.student_id) desc
limit 1 --________________________________17___________________________________
    --Вывести всю информацию о студентах, занимающихся самым популярным хобби.
SELECT h.name,
    h.risk,
    st.name,
    st.n_group,
    extract (
        year
        from age(now()::date, sh.date_start)
    ) * 12 + extract(
        month
        from age(now()::date, sh.date_start)
    ) as da
FROM student st
    inner join student_hobby sh ON st.id = sh.student_id
    INNER JOIN hobby h ON sh.hobby_id = h.id
ORDER BY da DESC
limit 10 --________________________________18___________________________________
    --Вывести ИД 3х хобби с максимальным риском.
SELECT h.risk AS most_risk_hobby_id
FROM hobby h
ORDER BY risk DESC
limit 3 --________________________________19___________________________________
    --Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.
SELECT h.name as hobby_name,
    h.risk,
    st.name AS student_name,
    st.n_group,
    extract (
        year
        from age(now()::date, sh.date_start)
    ) * 12 + extract(
        month
        from age(now()::date, sh.date_start)
    ) as month_length
FROM student st
    INNER JOIN student_hobby sh ON st.id = sh.student_id
    INNER JOIN hobby h ON sh.hobby_id = h.id
ORDER BY month_length DESC
limit 10 --________________________________20___________________________________
    --Вывести номера групп (без повторений), в которых учатся студенты из предыдущего запроса.
SELECT DISTINCT st.n_group
FROM student st
    INNER JOIN(
        SELECT st.name,
            st.surname,
            st.id
        FROM student st
            INNER JOIN (
                SELECT DISTINCT sh.student_id,
                    extract(
                        day
                        from (justify_days(now() - sh.date_start))
                    ) as countofdays
                FROM student_hobby sh
                WHERE sh.date_finish IS NULL
                ORDER BY countofdays DESC
            ) tt ON tt.student_id = st.id
        ORDER BY countofdays DESC
        LIMIT 10
    ) tt ON tt.id = st.ids --________________________________21___________________________________
    --Создать представление, которое выводит номер зачетки, имя и фамилию студентов, отсортированных по убыванию среднего балла.
CREATE OR replace view fio_student AS
SELECT name,
    surname
FROM student
ORDER BY score DESC --Команда CREATE OR REPLACE VIEW обновляет представление.
    --________________________________22___________________________________
    --Представление: найти каждое популярное хобби на каждом курсе.
CREATE OR REPLACE VIEW Popular_Hobby AS
SELECT LEFT(student.n_group::text, 1) AS course,
    hobby.name AS hobby
FROM student
    INNER JOIN student_hobby ON student.id = student_hobby.student_id
    INNER JOIN hobby ON hobby.id = student_hobby.hobby_id
GROUP BY course,
    hobby
HAVING COUNT(DISTINCT student_hobby.student_id) = (
        SELECT MAX(student_count.count)
        FROM (
                SELECT COUNT(DISTINCT student_hobby.student_id) AS count,
                    LEFT(student.n_group::text, 1) AS course
                FROM student
                    INNER JOIN student_hobby ON student.id = student_hobby.student_id
                GROUP BY course,
                    student_hobby.hobby_id
            ) AS student_count
        WHERE student_count.course = course
    );
Select *
FROM popular_Hobby;
--________________________________23___________________________________
--Представление: найти хобби с максимальным риском среди самых популярных хобби на 2 курсе.
SELECT h.risk as most_popular_risk_hobby_id,
    h.name
FROM student st
    INNER JOIN student_hobby sh ON st.id = sh.student_id
    INNER JOIN hobby h ON sh.hobby_id = h.id
WHERE st.n_group::varchar LIKE '2%'
ORDER BY risk DESC
limit 1 --________________________________24___________________________________
    --Представление: для каждого курса подсчитать количество студентов на курсе и количество отличников.
CREATE OR REPLACE VIEW students AS
SELECT substr(n_group::varchar, 1, 1) as course,
    count(*),
    SUM(
        CASE
            WHEN score = 5 THEN 1
            ELSE 0
        END
    )
From student
GROUP BY course;
--________________________________25___________________________________
--Представление: самое популярное хобби среди всех студентов.
CREATE OR REPLACE VIEW the_most_popular_hobby AS
SELECT hobby.name
FROM hobby
    INNER JOIN student_hobby ON hobby.id = student_hobby.hobby_id,
    GROUP BY hobby.id
HAVING COUNT(DISTINCT student_hobby.hobby_id) = (
        SELECT MAX(hobby_counts)
        FROM (
                SELECT COUNT(DISTINCT student_hobby.hobby_id) AS hobby_counts
                FROM student_hobby
                GROUP BY student_hobby.hobby_id
            ) AS counts
    )
LIMIT 1;