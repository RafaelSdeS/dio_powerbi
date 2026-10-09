let
    Fonte = MySQL.Database(Servidor, Banco, [ReturnSingleDatabase = true]),
    Tabela = Fonte{[Schema = Banco, Item = "works_on"]}[Data],
    Tipos = Table.TransformColumnTypes(Tabela, {{"Essn", type text}, {"Pno", Int64.Type}, {"Hours", type number}}, "en-US")
in
    Tipos
