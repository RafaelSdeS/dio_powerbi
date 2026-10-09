let
    Origem = Colaboradores,
    // quem não tem gerente (topo da hierarquia) não entra na contagem
    ComGerente = Table.SelectRows(Origem, each [Gerente] <> null),
    Agrupado = Table.Group(ComGerente, {"Gerente"}, {{"Qtd_Colaboradores", each Table.RowCount(_), Int64.Type}}),
    Ordenado = Table.Sort(Agrupado, {{"Qtd_Colaboradores", Order.Descending}, {"Gerente", Order.Ascending}})
in
    Ordenado
