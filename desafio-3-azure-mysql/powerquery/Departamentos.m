let
    // Mescla departament com dept_locations: um departamento com N locais gera N linhas
    Mescla = Table.NestedJoin(departament, {"Dnumber"}, dept_locations, {"Dnumber"}, "Locais", JoinKind.LeftOuter),
    Expande = Table.ExpandTableColumn(Mescla, "Locais", {"Dlocation"}),
    // Nome do gerente do departamento
    Nomes = Table.AddColumn(Table.SelectColumns(employee, {"Ssn", "Fname", "Lname"}), "Gerente_Departamento", each [Fname] & " " & [Lname], type text),
    MesclaGer = Table.NestedJoin(Expande, {"Mgr_ssn"}, Table.SelectColumns(Nomes, {"Ssn", "Gerente_Departamento"}), {"Ssn"}, "G", JoinKind.LeftOuter),
    ExpandeGer = Table.ExpandTableColumn(MesclaGer, "G", {"Gerente_Departamento"}),
    // Mescla local + departamento em uma coluna única (Store), como no enunciado
    Store = Table.CombineColumns(ExpandeGer, {"Dlocation", "Dname"}, Combiner.CombineTextByDelimiter(" ", QuoteStyle.None), "Store"),
    Colunas = Table.SelectColumns(Store, {"Store", "Dnumber", "Mgr_ssn", "Gerente_Departamento"}),
    Ordenado = Table.Sort(Colunas, {{"Dnumber", Order.Ascending}, {"Store", Order.Ascending}})
in
    Ordenado
