# Desafio 4 – Modelagem Star Schema (Financial Sample)

A tabela única `financials` (700 linhas) foi decomposta em um **esquema em estrela**: uma tabela fato e dimensões, todas construídas no Power Query (M) a partir de uma cópia oculta da origem, mais um calendário em DAX.

> Esquema: salve aqui o print da aba **Modelo** como `esquema_estrela.png` (Power BI Desktop → Exibição de modelo; o layout já está salvo em `diagramLayout.json`).

```
            D_Produtos ──┐                 ┌── D_Descontos
 D_Produtos_Detalhes ────┼──►  F_Vendas  ◄─┼── D_Detalhes
                         │                 └── D_Calendario
        (Financials_origem: oculta, backup)
```

## Tabelas
| Tabela | Granularidade | Colunas principais |
|---|---|---|
| `Financials_origem` (oculta) | 1 linha por venda (700) | Cópia tipada do Excel; backup para as demais |
| `D_Produtos` | 1 por produto (6) | ID_Produto, Produto, **Índice de Produtos** (coluna condicional Alto/Médio/Baixo), média de unidades, média/mediana/máximo/mínimo do valor de vendas (`Table.Group`) |
| `D_Produtos_Detalhes` | produto × preço de venda × preço de fabricação (42) | ID_Produto_Detalhe, ID_Produto, Produto, Sale Price, Manufacturing Price, Total Unidades Vendidas |
| `D_Descontos` | faixa × percentual de desconto (16) | ID_Desconto, Discount Band (ordenada), Desconto % |
| `D_Detalhes` | segmento × país (25) | ID_Detalhe, Segment, Country |
| `D_Calendario` | 1 por dia (DAX) | Date, Ano, Mês, Trimestre; marcada como tabela de datas |
| `F_Vendas` | 1 por venda (700) | SK_ID, chaves das dimensões, Date, Units Sold, Sale Price, Gross Sales, Discounts, Sales, COGS, Profit |

### Decisões que diferem do enunciado
- **Chaves próprias nas dimensões.** Em `D_Descontos` e `D_Produtos_Detalhes` o enunciado usa `ID_produto` como chave, mas isso repetiria o produto e quebraria a relação 1:N. Cada dimensão tem uma chave substituta (índice) própria.
- **`Discount` não existe na origem:** foi calculado como `Discounts / Gross Sales`, arredondado em 4 casas.
- **Segment, Country e Discount Band** ficam nas dimensões (`D_Detalhes`, `D_Descontos`), não repetidos na fato, para evitar redundância.
- Os nomes não têm acento para evitar problemas de compatibilidade (`D_Calendario`, `Media Valor Vendas`).

## Processo de construção
1. Importar o Excel (parâmetro `CaminhoDados`) e tipar as colunas em `Financials_origem` (oculta).
2. Criar cada dimensão referenciando `Financials_origem`: `Table.Group` (produtos), `Table.Distinct` (descontos, detalhes), `Table.AddIndexColumn` (chaves).
3. Criar `F_Vendas`: índice `SK_ID`, quatro `Table.NestedJoin` (mesclagem, left outer) para trazer as chaves, e `Table.SelectColumns` para manter só chaves e valores.
4. `Table.ReorderColumns` para reorganizar as colunas de cada tabela.
5. Criar `D_Calendario` em DAX e relacionar tudo (1:N, direção única, fato no lado N).

## Funções utilizadas
- **Power Query (M):** `Excel.Workbook`, `Table.Group`, `List.Average/Median/Max/Min/Sum`, `Table.Distinct`, `Table.AddIndexColumn`, `Table.NestedJoin` + `Table.ExpandTableColumn`, `Table.AddColumn` com `if/else` (índice de produtos), `Number.Round`, `Table.ReorderColumns`.
- **DAX:** `CALENDAR`, `ADDCOLUMNS`, `YEAR/MONTH/QUARTER/FORMAT`, `SUM`, `DIVIDE`, `CALCULATE`, `SAMEPERIODLASTYEAR`.

## Medidas (em `F_Vendas`)
Total Vendas, Total Lucro, Unidades Vendidas, Total Descontos, Margem %, Ticket Médio, Vendas Ano Anterior, Variação Vendas %.

## Como abrir
Abra `star_schema_financial.pbip` no Power BI Desktop e ajuste o parâmetro `CaminhoDados` para `dataset/Financial Sample.xlsx`.
