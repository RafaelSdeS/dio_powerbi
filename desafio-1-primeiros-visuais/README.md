# Desafio 1 – Primeiros visuais com Power BI (Financial Sample)

Relatório `DIO1.pbix` com 3 páginas sobre o **Financial Sample** (700 linhas de vendas por segmento, país, produto e data). As duas primeiras páginas replicam as construídas durante o curso; a terceira foi criada de forma autônoma, como pede o desafio.

Dados: [`dataset/Financial Sample.xlsx`](../dataset/Financial%20Sample.xlsx) · Repositório do curso: [julianazanelatto/power_bi_analyst](https://github.com/julianazanelatto/power_bi_analyst)

## Páginas e visuais
| Página | Visuais |
|---|---|
| **Página 1** | Segmentador de data (ano e mês), pizza de **vendas por produto**, colunas de **vendas por ano/mês e segmento** e gráfico de áreas do **preço de venda por produto**, com caixa de texto de título |
| **Página 2** | Cartões de **vendas** e **unidades vendidas**, colunas de **lucro por ano/mês**, pizza de **lucro por país** e colunas de **vendas por país** |
| **Página 3** (criada de forma autônoma) | **Mapa 1:** vendas por país · **Mapa 2:** lucro por país · **Rosca:** lucro por segmento · **Treemap:** lucro por segmento |

## Como o relatório foi organizado
- **Nomes dos visuais:** cada gráfico, mapa e cartão tem um título claro e direto (por exemplo, "Vendas e unidades vendidas por país" e "Lucro por segmento").
- **Dicas de ferramenta:** o mapa de vendas mostra também *Unidades vendidas* e *Lucro*; o mapa de lucro mostra também *Vendas* e *Unidades vendidas*.
- Mapas alinhados à direita (vendas e lucro por país) e visuais de segmento à esquerda, sem sobreposição.
- Medidas implícitas do Power BI (soma de `Sales`, `Profit`, `Units Sold` e `Sale Price`) sobre a tabela `financials`.
- Hierarquia de datas (ano e mês) usada nas séries temporais e no segmentador.

## Entrega
Projeto Power BI (`DIO1.pbip`, com títulos e dicas de ferramenta ajustados) e o arquivo original `DIO1.pbix`, ambos neste repositório. O relatório não foi publicado no Power BI Service nem compartilhado como suplemento do PowerPoint (conta pessoal, sem PowerPoint).

## Como abrir
Abra `DIO1.pbip` (ou `DIO1.pbix`) no Power BI Desktop. Se o Excel estiver em outro local, ajuste a origem em *Transformar dados → Configurações da fonte de dados*.
