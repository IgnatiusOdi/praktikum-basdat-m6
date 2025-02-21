conn prakbd/prakbd

set linesize 1000;
set pagesize 500;

--MATERI
--NO 1
select
    rpad(s.name || '(' || s.supplier_id || ') hanya pernah mensupply sebanyak ' || count(s.supplier_id),80) as "SUPPLIER"
from supplier s
join orders o on o.supplier_id = s.supplier_id
having count(s.supplier_id) = (select min(minimum) from
                                (select count(supplier_id) minimum
                                from orders
                                group by supplier_id
                                )
                              )
group by s.name, s.supplier_id;

--NO 2
select
    d.developer_id as "DEVID",
    rpad(d.name,20) as "DEVELOPER"
from developer d
join game g on g.developer_id = d.developer_id
where g.genre_id in
(
    select genre_id
    from game
    having count(game_id) = (select max(jumlah) from
                                (
                                    select count(game_id) jumlah
                                    from game
                                    group by genre_id
                                )
                            )
    group by genre_id
)
group by d.developer_id, d.name
order by substr(upper(d.name),2,1), substr(upper(d.name),3,1) desc;

--NO 3
--(select avg(t.total) from transaction t where nvl(member_id,'0')!='0')
select
    t.transaction_id,
    rpad(m.name,20) as "MEMBER",
    t.total
from transaction t
join member m on m.member_id = t.member_id
where t.total > (select avg(t.total) from transaction t where nvl(member_id,'0')!='0')
order by 1;

--NO 4
--select min(minimum) from
-- (
--     select count(member_id) minimum
--     from transaction
--     where nvl(member_id,'0')!='0'
--     group by transaction_id
-- )
select
    rpad(m.name || ' merupakan member yang paling jarang (>0) melakukan transaksi(' || count(m.member_id) || ')',80) as "MESSAGE"
from member m
join transaction t on m.member_id = t.member_id
having count(m.member_id) = (select min(minimum) from
                            (
                            select count(member_id) minimum
                            from transaction
                            where nvl(member_id,'0')!='0'
                            group by transaction_id
                            )
                          )
group by m.name
order by 1;

--TUGAS
--NO 2
-- select sum(gt.qty) as "JUMLAH"
-- from game_transaction gt
-- group by gt.game_id
-- order by "JUMLAH" desc;

select "Game", "Total"
from
(
    select
    rpad(g.name,50) as "Game",
    rpad((
        select sum(gt.qty) as "JUMLAH"
        from game_transaction gt
        where gt.game_id = g.game_id
        group by gt.game_id
    ) || ' copy',10) as "Total"
    from game g
    order by length(replace("Total",' ','')) desc, substr("Total",1,2) desc
) where rownum <= 5;

--NO 3

-- select
-- count(t.employee_id)
-- from transaction t
-- group by t.employee_id

-- select
-- (
--     case
--     when nvl(count(o.employee_id),0) = 0 then '-'
--     else to_char(nvl(count(o.employee_id),0))
--     end
-- )
-- from employee e
-- left join orders o on o.employee_id = e.employee_id
-- group by e.name

select
    rpad(e.name,20) as "Employee",
rpad((
    select
    count(t.employee_id)
    from transaction t
    where t.employee_id = e.employee_id
    group by t.employee_id
),11) as "Transaction",
rpad(
(
    select
    (
        case
        when nvl(count(o.employee_id),0) = 0 then '-'
        else to_char(nvl(count(o.employee_id),0))
        end
    )
    from employee e1
    left join orders o on o.employee_id = e1.employee_id
    where e1.employee_id = e.employee_id
    group by e1.name
),11) as "Order"
from employee e
order by
(
    (
        select count(t.employee_id) as Value1
        from transaction t
        where t.employee_id = e.employee_id
        group by t.employee_id
    ) +
    (
        select replace(nvl(count(o.employee_id),0),0,-1) as Value2
        from employee e1
        left join orders o on o.employee_id = e1.employee_id
        where e1.employee_id = e.employee_id
        group by e1.name
    )
) desc, 1 asc;

--NO 4
select
    col." ",
    col."  "
from
(
    select
        '| '|| substr(ge.name,1,1) || ' |' as " ",
        '| ' || rpad(ge.name,31) || ' |' as "  "
    from genre ge
    where ge.genre_id = 'G009'
    union
    select
        '-+++-' as " ",
        '-----------------------------------' as "  "
    from dual
    union
    select
        ' |' || substr(g.name,1,1) || '| ' as " ",
        '| ' || rpad(g.name,31) || ' |' as "  "
    from game g
    join genre ge on ge.genre_id = g.genre_id
    where g.genre_id = 'G009'
    union
    select
        ' \_/ ' as " ",
        '-----------------------------------' as "  "
    from dual
) col
order by substr(col." ",1,2) desc, length(replace(col."  ",' ','')) asc;
