# Desafio 5 – Data Analytics com Power BI (Relatório Criativo)

Relatório de 2 páginas sobre o **modelo estrela do Desafio 4** (`F_Vendas` + 5 dimensões). Tema claro próprio (`DioClean`) com contraste alto: texto azul-marinho sobre cartões brancos, destaque em verde-azulado e âmbar.

## Páginas
**Resumo**
- Segmentadores (Ano, Segmento, País, Faixa de desconto) sincronizados entre as páginas.
- Cartões: Vendas, Lucro, Margem %, Unidades vendidas.
- **Dispersão** Unidades vendidas × Vendas por mês, com cor por ano e Margem % e Participação nas dicas de ferramenta.
- **TOP 3 produtos** por vendas (dinâmico, respeita os filtros).
- **Principais países** por vendas.
- **Compartimentação:** treemap de lucro por segmento.

**Detalhes**
- Cartões: Ticket médio, Descontos concedidos, Vendas no ano anterior, Variação vs. ano anterior.
- Tabela de desempenho por produto (unidades, vendas, lucro, margem e índice do produto).
- Rosca de vendas por faixa de desconto e colunas de lucro por trimestre e ano.

## Experiência do usuário
- **Posicionamento:** cabeçalho com navegação sempre no mesmo lugar; filtros no topo, KPIs logo abaixo, análises no restante, seguindo a leitura em Z.
- **Proporção áurea:** colunas de análise com ~62% / 38% da largura (761 px e 455 px).
- **Contraste:** fundo cinza-claro, cartões brancos, texto `#1B2540`; os botões de navegação mudam de cor ao focar (âmbar) e destacam a página atual.
- **Segmentação:** filtros globais em lista suspensa e botão **Limpar filtros**.

## Medidas DAX novas (além das do D4)
| Medida | Fórmula |
|---|---|
| Rank Produto | `RANKX(ALL(D_Produtos[Produto]), [Total Vendas], , DESC, Dense)` |
| Vendas TOP3 | `IF([Rank Produto] <= 3, [Total Vendas])` (produtos fora do TOP 3 ficam em branco e saem do gráfico) |
| Participação Vendas % | `DIVIDE([Total Vendas], CALCULATE([Total Vendas], ALLSELECTED()))` |

## Observação sobre os dados
O Financial Sample cobre set/2013 a dez/2014, então a "Variação vs. ano anterior" de 2014 (+349,5%) compara 12 meses com apenas 4. É uma limitação da base, não da medida.

## Como abrir
Abra `vendas_analytics.pbip` no Power BI Desktop e ajuste o parâmetro `CaminhoDados` para `dataset/Financial Sample.xlsx`.
Desmarque **Arquivo → Opções → Arquivo atual → Carregamento de dados → Detectar automaticamente novas relações** para o Desktop não recriar relações por conta própria.

## Publicação
Não publicado no Power BI Service (conta pessoal). O projeto completo está neste repositório.
