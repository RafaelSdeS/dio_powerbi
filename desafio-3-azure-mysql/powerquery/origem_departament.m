let
    Fonte = MySQL.Database(Servidor, Banco, [ReturnSingleDatabase = true]),
    Tabela = Fonte{[Schema = Banco, Item = "departament"]}[Data],
    Tipos = Table.TransformColumnTypes(Tabela, {{"Dname", type text}, {"Dnumber", Int64.Type}, {"Mgr_ssn", type text}, {"Mgr_start_date", type date}, {"Dept_create_date", type date}}, "en-US")
in
    Tipos
