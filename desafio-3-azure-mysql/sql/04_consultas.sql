-- Consultas usadas na transformação (equivalentes às mesclagens do Power Query).
use azure_company;

-- Colaboradores e seus gerentes (auto-junção). LEFT JOIN mantém quem não tem gerente.
select concat(e.Fname, ' ', e.Lname) as Colaborador,
       concat(g.Fname, ' ', g.Lname) as Gerente
from employee e
left join employee g on g.Ssn = e.Super_ssn
order by Gerente, Colaborador;

-- Quantidade de colaboradores por gerente
select concat(g.Fname, ' ', g.Lname) as Gerente, count(e.Ssn) as Colaboradores
from employee e
join employee g on g.Ssn = e.Super_ssn
group by g.Ssn, Gerente
order by Colaboradores desc, Gerente;

-- Colaboradores com o nome do departamento (LEFT JOIN a partir de employee)
select concat(e.Fname, ' ', e.Lname) as Colaborador, d.Dname as Departamento
from employee e
left join departament d on d.Dnumber = e.Dno;

-- Combinação departamento-local (cada linha única)
select concat(l.Dlocation, ' ', d.Dname) as Store, d.Dnumber, d.Mgr_ssn
from departament d
join dept_locations l on l.Dnumber = d.Dnumber
order by d.Dnumber, l.Dlocation;
