let
    Mescla = Table.NestedJoin(works_on, {"Pno"}, project, {"Pnumber"}, "P", JoinKind.LeftOuter),
    Expande = Table.ExpandTableColumn(Mescla, "P", {"Pname"}),
    Agrupado = Table.Group(Expande, {"Pno", "Pname"}, {{"Total_Horas", each List.Sum([Hours]), type number}, {"Qtd_Colaboradores", each Table.RowCount(_), Int64.Type}}),
    Ordenado = Table.Sort(Agrupado, {{"Pno", Order.Ascending}})
in
    Ordenado
