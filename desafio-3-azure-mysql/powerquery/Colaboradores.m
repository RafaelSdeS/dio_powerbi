let
    Origem = employee,
    // 1) Nome + sobrenome em uma única coluna
    Colaborador = Table.AddColumn(Origem, "Colaborador", each [Fname] & " " & [Lname], type text),
    // 2) Separa o endereço complexo "numero-rua-cidade-UF" em colunas
    Numero = Table.AddColumn(Colaborador, "Numero", each Text.Split([Address], "-"){0}, type text),
    Rua = Table.AddColumn(Numero, "Rua", each let p = Text.Split([Address], "-") in Text.Combine(List.Range(p, 1, List.Count(p) - 3), " "), type text),
    Cidade = Table.AddColumn(Rua, "Cidade", each let p = Text.Split([Address], "-") in p{List.Count(p) - 2}, type text),
    Estado = Table.AddColumn(Cidade, "Estado", each List.Last(Text.Split([Address], "-")), type text),
    // 3) Mescla com departament (LEFT OUTER a partir de employee: ninguém some se faltar departamento)
    MesclaDept = Table.NestedJoin(Estado, {"Dno"}, Table.SelectColumns(departament, {"Dnumber", "Dname"}), {"Dnumber"}, "Dept", JoinKind.LeftOuter),
    ExpandeDept = Table.ExpandTableColumn(MesclaDept, "Dept", {"Dname"}, {"Departamento"}),
    // 4) Mescla de employee com ele mesmo para obter o nome do gerente (Super_ssn -> Ssn)
    Gerentes = Table.AddColumn(Table.SelectColumns(Origem, {"Ssn", "Fname", "Lname"}), "Gerente", each [Fname] & " " & [Lname], type text),
    MesclaGer = Table.NestedJoin(ExpandeDept, {"Super_ssn"}, Table.SelectColumns(Gerentes, {"Ssn", "Gerente"}), {"Ssn"}, "G", JoinKind.LeftOuter),
    ExpandeGer = Table.ExpandTableColumn(MesclaGer, "G", {"Gerente"}),
    // 5) Mantém só o que o relatório usa
    Colunas = Table.SelectColumns(ExpandeGer, {"Ssn", "Colaborador", "Sex", "Bdate", "Salary", "Numero", "Rua", "Cidade", "Estado", "Super_ssn", "Gerente", "Dno", "Departamento"})
in
    Colunas
