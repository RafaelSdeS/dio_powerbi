let
    Fonte = MySQL.Database(Servidor, Banco, [ReturnSingleDatabase = true]),
    Tabela = Fonte{[Schema = Banco, Item = "dept_locations"]}[Data],
    Tipos = Table.TransformColumnTypes(Tabela, {{"Dnumber", Int64.Type}, {"Dlocation", type text}}, "en-US")
in
    Tipos
