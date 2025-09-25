# Guia para Executar o Projeto Data Warehouse

Este documento descreve os passos para preparar e executar o projeto Data Warehouse utilizando SQL Server e PostgreSQL.

---

## 1. Subir os Contêineres

No diretório onde está o `docker-compose.yml`, execute:

```bash
docker-compose up -d
```

Isso criará dois contêineres:

- **SQL Server**: `mcr.microsoft.com/mssql/server:2022-latest`
- **PostgreSQL**: imagem customizada com `tds_fdw` já instalado

---

## 2. Conectar no PostgreSQL

Use qualquer cliente SQL (DBeaver, pgAdmin, psql) com as credenciais:

- **Usuário**: `postgres`
- **Senha**: `admin`
- **Host**: `localhost`
- **Porta**: `5432`

---

## 3. Conectar no SQL Server

Use um cliente como Azure Data Studio ou `sqlcmd` com as credenciais:

- **Usuário**: `sa`
- **Senha**: `Admin123#`
- **Host**: `localhost`
- **Porta**: `1433`

---

## 4. Criar o Banco no SQL Server e Restaurar Backup

Dentro do SQL Server:

```sql
CREATE DATABASE ADS;
```

Depois rode o script `1-backup-sql-server.sql` no banco `ADS`:

```bash
sqlcmd -S localhost,1433 -U sa -P "Admin123#" -d ADS -i 1-backup-sql-server.sql
```

---

## 5. Criar o Banco do Data Warehouse no PostgreSQL

Conectado ao PostgreSQL, crie o banco:

```sql
CREATE DATABASE dw;
```

Rode o SQL `2-criar-dw-postgre.sql` no banco `dw`:

```bash
psql -h localhost -U postgres -p 5432 -d dw -f 2-criar-dw-postgre.sql
```

---

## 6. Criar Tabelas Estrangeiras no PostgreSQL

No banco `dw`, rode o script `3-criar-foreign-tables-postgre.sql`.
Esse script:

- Cria a extensão `tds_fdw` (já instalada na imagem)
- Cria as tabelas estrangeiras que apontam para o SQL Server

```bash
psql -h localhost -U postgres -p 5432 -d dw -f 3-criar-foreign-tables-postgre.sql
```

---

## 7. Popular o Data Warehouse

Ainda no banco `dw`, rode o script `4-popular-dw.sql` para inserir os dados:

```bash
psql -h localhost -U postgres -p 5432 -d dw -f 4-popular-dw.sql
```

---

## Resumo dos Scripts

| Script                               | Função                                         |
| ------------------------------------ | ---------------------------------------------- |
| `1-backup-sql-server.sql`            | Popula o banco `ADS` no SQL Server             |
| `2-criar-dw-postgre.sql`             | Cria a estrutura do DW no PostgreSQL           |
| `3-criar-foreign-tables-postgre.sql` | Cria extensão `tds_fdw` e tabelas estrangeiras |
| `4-popular-dw.sql`                   | Popula o DW com dados do SQL Server            |

Seguindo essa ordem o Data Warehouse estará pronto para consultas.
