let
    Fonte = MySQL.Database(Servidor, Banco, [ReturnSingleDatabase = true]),
    Tabela = Fonte{[Schema = Banco, Item = "employee"]}[Data],
    Tipos = Table.TransformColumnTypes(Tabela, {{"Fname", type text}, {"Minit", type text}, {"Lname", type text}, {"Ssn", type text}, {"Bdate", type date}, {"Address", type text}, {"Sex", type text}, {"Salary", type number}, {"Super_ssn", type text}, {"Dno", Int64.Type}}, "en-US")
in
    Tipos
