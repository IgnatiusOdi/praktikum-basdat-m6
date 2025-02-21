drop user prakbd cascade;
create user prakbd identified by prakbd;
conn prakbd/prakbd

set linesize 1000;
set pagesize 500;

spool "D:\220116919_spool.sql";
set time on;
set sqlprompt "220116919 >";

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
    d.name as "DEVELOPER"
from developer d
join game g on g.developer_id = d.developer_id
where g.genre_id in (
    select max(jumlah) from
    (
        select
        genre_id,
        count(game_id) jumlah
        from game group by genre_id
    )
)

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

spool off;