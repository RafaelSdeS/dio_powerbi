# Desafio 3 – Integrando dados com MySQL (Azure) e transformando com Power BI

Banco `azure_company` (modelo clássico Company) em **Azure Database for MySQL**, consumido pelo Power BI Desktop e tratado no Power Query.

```
desafio-3-azure-mysql/
├─ sql/                         scripts do banco e consultas
│  ├─ 01_schema.sql             cria o schema e as tabelas
│  ├─ 02_dados.sql              carga de dados
│  ├─ 03_verificacoes.sql       nulos, gerentes, departamentos, horas
│  └─ 04_consultas.sql          consultas usadas na transformação (inclui colaborador × gerente)
├─ powerquery/                  código M de cada consulta (um arquivo por consulta)
└─ azure_company_transform.pbip projeto Power BI com as transformações
```

## 1. Banco na Azure (passo a passo)
1. **Portal Azure → Criar recurso → Azure Database for MySQL – servidor flexível.** Escolha o plano de menor custo (Burstable B1ms), defina usuário administrador e senha.
2. Em **Rede**, deixe o acesso público e marque **Adicionar o IP atual do cliente** (regra de firewall). Sem isso a conexão é recusada.
3. Conecte e rode os scripts, por uma destas formas:
   - **Cloud Shell** (ícone `>_` no portal): `mysql -h SEU-SERVIDOR.mysql.database.azure.com -u ADMIN -p` e depois `source` dos arquivos, ou
   - **MySQL Workbench**: nova conexão com o host do servidor, porta 3306, SSL ligado; abra e execute `01_schema.sql` e `02_dados.sql`.
4. Confirme com `use azure_company; select count(*) from employee;` (esperado: 8).
5. Ao terminar os testes, **pare ou exclua o servidor** para não gerar cobrança.

> Não grave senha nem o host real em arquivos do repositório.

## 2. Integração com o Power BI
Instale o **MySQL Connector/NET** (necessário para o conector MySQL do Power BI). No Power BI Desktop, abra `azure_company_transform.pbip` e edite os parâmetros em *Transformar dados → Gerenciar parâmetros*:

| Parâmetro | Valor |
|---|---|
| `Servidor` | `SEU-SERVIDOR.mysql.database.azure.com:3306` |
| `Banco` | `azure_company` |

Na primeira atualização, informe usuário e senha do banco (a credencial fica só na sua máquina). Modo de armazenamento: **Importar**.

## 3. Verificação da base (`03_verificacoes.sql`)
| Verificação | Resultado |
|---|---|
| Cabeçalhos e tipos | Valores monetários (`Salary`) e `Hours` convertidos para número decimal (double) no Power Query |
| Nulos | Só `Super_ssn` tem nulo (1 colaborador). Nenhuma outra coluna das tabelas principais tem nulos, então nada foi removido |
| Colaboradores sem gerente | Apenas **James Borg** (`Super_ssn` nulo). Ele é o gerente de topo: dirige *Headquarters* e tem 2 subordinados |
| Departamentos sem gerente | **Nenhum** (`Mgr_ssn` é obrigatório e todos apontam para um colaborador). Não houve lacuna a preencher |
| Horas dos projetos | Todos os colaboradores somam 40 h, exceto Jennifer Wallace (35 h) e James Borg (**0 h**, alocação em *Reorganization* com 0,0). Projeto com menos horas: *Reorganization* (25 h); com mais: *Computerization* e *Newbenefits* (55 h) |

## 4. Transformações no Power Query
| Consulta | O que faz |
|---|---|
| `employee`, `departament`, `dept_locations`, `project`, `works_on` | Origem (MySQL) já com tipos corrigidos; não são carregadas no modelo |
| **Colaboradores** | Mescla de `employee` com `departament` (junção **externa esquerda** a partir de `employee`); nome + sobrenome na coluna `Colaborador`; endereço separado em `Numero`, `Rua`, `Cidade`, `Estado`; mescla de `employee` com ela mesma para trazer o nome do `Gerente`; colunas desnecessárias removidas (Fname, Minit, Lname, Address) |
| **Departamentos** | Mescla de `departament` com `dept_locations`; coluna `Store` = local + departamento (cada combinação é única); nome do gerente do departamento |
| **Colaboradores_por_Gerente** | Agrupa `Colaboradores` por `Gerente` e conta (quem não tem gerente fica de fora) |
| **Horas_por_Projeto** | Mescla `works_on` com `project` e soma horas por projeto |

**Por que a junção é externa esquerda a partir de `employee`:** a tabela-base é a de colaboradores. Uma junção interna eliminaria quem não tem departamento ou gerente (James Borg); a esquerda preserva todos os 8.

### Query SQL equivalente (colaborador × gerente)
```sql
select concat(e.Fname, ' ', e.Lname) as Colaborador,
       concat(g.Fname, ' ', g.Lname) as Gerente
from employee e
left join employee g on g.Ssn = e.Super_ssn
order by Gerente, Colaborador;
```

### Por que "mesclar" e não "atribuir" para departamento + local
Um departamento pode ter **vários locais** (*Research* tem 3: Bellaire, Sugarland e Houston). Ao mesclar as consultas `departament` e `dept_locations` pela chave `Dnumber`, o Power Query gera **uma linha por combinação** departamento-local (5 linhas no total), e a coluna `Store` torna cada combinação única. "Atribuir" um valor (trazer um único local para cada departamento, como numa busca simples) só funcionaria se houvesse **um** local por departamento; aqui perderia os demais ou duplicaria o departamento de forma incorreta. Por isso a mescla é o passo certo e depois basta combinar os dois textos em uma coluna.

## 5. Validação
As transformações foram testadas carregando o mesmo schema num MySQL local e comparando o resultado do Power Query com as consultas SQL: 8 colaboradores, gerentes e departamentos idênticos, 5 combinações departamento-local, contagem por gerente (Franklin Wong 3, James Borg 2, Jennifer Wallace 2) e horas por projeto iguais. A conexão com a instância na **Azure** depende do seu servidor e deve ser conferida por você ao atualizar o relatório.
