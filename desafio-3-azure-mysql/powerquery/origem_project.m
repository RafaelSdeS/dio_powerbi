let
    Fonte = MySQL.Database(Servidor, Banco, [ReturnSingleDatabase = true]),
    Tabela = Fonte{[Schema = Banco, Item = "project"]}[Data],
    Tipos = Table.TransformColumnTypes(Tabela, {{"Pname", type text}, {"Pnumber", Int64.Type}, {"Plocation", type text}, {"Dnum", Int64.Type}}, "en-US")
in
    Tipos
