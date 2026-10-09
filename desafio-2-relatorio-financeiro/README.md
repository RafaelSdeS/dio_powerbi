# Desafio 2 – Relatório financeiro elaborado (Financial Sample)

Relatório Power BI (formato PBIP) com tema escuro, 2 páginas e navegação entre elas.

## Estrutura
- **Visão Geral**: cartões (Vendas, Lucro, Margem %, Unidades), evolução temporal, vendas por segmento, por país, por produto (treemap), por faixa de desconto (rosca) e por trimestre.
- **Detalhes**: cartões (Vendas, Lucro, COGS, Ticket Médio), tabela produto × país, margem por segmento e lucro por país.
- Cabeçalho em todas as páginas com botões de navegação e botão **Limpar filtros** (`ClearAllSlicers`).
- Segmentadores: Ano, Segmento, País e Métrica (Visão Geral); Ano, Segmento, País e Produto (Detalhes).

## Modelo
Tabelas: `financials` (importada do Excel), `Calendario` (calendário com Ano/Mês), `Metrica` (tabela auxiliar com Vendas, Lucro, Unidades e Descontos).
O caminho do Excel é o parâmetro `CaminhoDados` (Transformar dados → Gerenciar parâmetros); aponte para `../dataset/Financial Sample.xlsx` na sua máquina.

## Medidas DAX
| Medida | Fórmula / função |
|---|---|
| Total Vendas, Total Lucro, Unidades Vendidas, Total Descontos, Total COGS | `SUM` |
| Margem % | `DIVIDE(Lucro, Vendas)` |
| Ticket Médio | `DIVIDE(Vendas, Unidades)` |
| Vendas Ano Anterior | `CALCULATE` + `SAMEPERIODLASTYEAR` |
| Variação Vendas % | `DIVIDE` sobre a diferença para o ano anterior |
| Métrica Selecionada | `SWITCH` + `SELECTEDVALUE` sobre a tabela `Metrica`: o segmentador "Métrica" troca o que os gráficos exibem |

## Como abrir
Abra `relatrio criativo.pbip` no Power BI Desktop (modo de desenvolvedor / PBIP habilitado) e ajuste o parâmetro `CaminhoDados`.

## Publicação
Não publicado no Power BI Service (conta pessoal, sem licença para publicação); o projeto completo está neste repositório.
