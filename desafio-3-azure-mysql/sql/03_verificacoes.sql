-- Verificações de qualidade pedidas pelo desafio. Rode depois de 01 e 02.
use azure_company;

-- 1) Nulos por coluna nas tabelas principais
select
    sum(Minit is null)      as Minit_nulos,
    sum(Bdate is null)      as Bdate_nulos,
    sum(Address is null)    as Address_nulos,
    sum(Sex is null)        as Sex_nulos,
    sum(Salary is null)     as Salary_nulos,
    sum(Super_ssn is null)  as Super_ssn_nulos
from employee;

-- 2) Colaboradores sem gerente (Super_ssn nulo): podem ser gerentes de topo
select Ssn, concat(Fname, ' ', Lname) as Colaborador,
       (select count(*) from departament d where d.Mgr_ssn = e.Ssn) as gerencia_departamentos,
       (select count(*) from employee s where s.Super_ssn = e.Ssn)  as subordinados
from employee e
where Super_ssn is null;

-- 3) Departamentos sem gerente (Mgr_ssn nulo ou apontando para ninguém)
select d.Dnumber, d.Dname, d.Mgr_ssn
from departament d
left join employee e on e.Ssn = d.Mgr_ssn
where d.Mgr_ssn is null or e.Ssn is null;

-- 4) Horas por colaborador (esperado: até 40 h) e por projeto
select e.Ssn, concat(e.Fname, ' ', e.Lname) as Colaborador,
       coalesce(sum(w.Hours), 0) as horas_totais,
       sum(w.Hours = 0)          as alocacoes_com_zero_horas
from employee e
left join works_on w on w.Essn = e.Ssn
group by e.Ssn, Colaborador
order by horas_totais;

select p.Pnumber, p.Pname, count(w.Essn) as colaboradores, coalesce(sum(w.Hours), 0) as horas_totais
from project p
left join works_on w on w.Pno = p.Pnumber
group by p.Pnumber, p.Pname
order by p.Pnumber;

-- 5) Projetos sem nenhuma alocação
select p.Pnumber, p.Pname
from project p
left join works_on w on w.Pno = p.Pnumber
where w.Essn is null;
