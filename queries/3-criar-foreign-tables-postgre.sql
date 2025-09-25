CREATE EXTENSION IF NOT EXISTS tds_fdw;

CREATE SERVER mssql_srv
FOREIGN DATA WRAPPER tds_fdw
OPTIONS (
  servername  'sqlserver',  -- nome do container
  port        '1433',
  database    'ADS'
);

CREATE USER MAPPING FOR CURRENT_USER
SERVER mssql_srv
OPTIONS (
  username 'sa',
  password 'Admin123#'
);

-- tb001_uf
CREATE FOREIGN TABLE tb001_uf (
  tb001_sigla_uf     varchar(2)   NOT NULL,
  tb001_nome_estado  varchar(255) NOT NULL
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb001_uf');

-- tb002_cidades
CREATE FOREIGN TABLE tb002_cidades (
  tb002_cod_cidade   numeric(10),
  tb001_sigla_uf     varchar(2)   NOT NULL,
  tb002_nome_cidade  varchar(255) NOT NULL
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb002_cidades');

-- tb003_enderecos
CREATE FOREIGN TABLE tb003_enderecos (
  tb003_cod_endereco     numeric(10),
  tb001_sigla_uf         varchar(2)   NOT NULL,
  tb002_cod_cidade       numeric(10)  NOT NULL,
  tb003_nome_rua         varchar(255) NOT NULL,
  tb003_numero_rua       varchar(10)  NOT NULL,
  tb003_complemento      varchar(255),
  tb003_ponto_referencia varchar(255),
  tb003_bairro           varchar(255) NOT NULL,
  "tb003_CEP"            varchar(15)  NOT NULL
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb003_enderecos');

-- tb004_lojas
CREATE FOREIGN TABLE tb004_lojas (
  tb004_cod_loja        numeric(10),
  tb003_cod_endereco    numeric(10),
  tb004_matriz          numeric(10),
  tb004_cnpj_loja       varchar(20)  NOT NULL,
  tb004_inscricao_estadual varchar(20)
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb004_lojas');

-- tb005_006_funcionarios_cargos
CREATE FOREIGN TABLE tb005_006_funcionarios_cargos (
  tb005_matricula              numeric(10)  NOT NULL,
  tb006_cod_cargo              numeric(10)  NOT NULL,
  tb005_006_valor_cargo        numeric(10,2) NOT NULL,
  tb005_006_perc_comissao_cargo numeric(5,2) NOT NULL,
  tb005_006_data_promocao      timestamp without time zone NOT NULL
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb005_006_funcionarios_cargos');

-- tb005_funcionarios
CREATE FOREIGN TABLE tb005_funcionarios (
  tb005_matricula      numeric(10),
  tb004_cod_loja       numeric(10)  NOT NULL,
  tb003_cod_endereco   numeric(10)  NOT NULL,
  tb005_nome_completo  varchar(255) NOT NULL,
  tb005_data_nascimento timestamp without time zone NOT NULL,
  "tb005_CPF"          varchar(17)  NOT NULL,
  "tb005_RG"           varchar(15)  NOT NULL,
  tb005_status         varchar(20)  NOT NULL,
  tb005_data_contratacao timestamp without time zone NOT NULL,
  tb005_data_demissao  timestamp without time zone
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb005_funcionarios');

-- tb006_cargos
CREATE FOREIGN TABLE tb006_cargos (
  tb006_cod_cargo  numeric(10),
  tb006_nome_cargo varchar(255) NOT NULL
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb006_cargos');

-- tb010_012_vendas
CREATE FOREIGN TABLE tb010_012_vendas (
  tb010_012_cod_venda  numeric(10),
  tb010_cpf            numeric(15)  NOT NULL,
  tb012_cod_produto    numeric(10)  NOT NULL,
  tb005_matricula      numeric(10)  NOT NULL,
  tb010_012_data       timestamp without time zone NOT NULL,
  tb010_012_quantidade numeric(10)  NOT NULL,
  tb010_012_valor_unitario numeric(12,4) NOT NULL
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb010_012_vendas');

-- tb010_clientes
CREATE FOREIGN TABLE tb010_clientes (
  tb010_cpf              numeric(15)  NOT NULL,
  tb010_nome             varchar(255) NOT NULL,
  tb010_fone_residencial varchar(255) NOT NULL,
  tb010_fone_celular     varchar(255)
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb010_clientes');

-- tb010_clientes_antigos
CREATE FOREIGN TABLE tb010_clientes_antigos (
  tb010_cpf  numeric(15,0) NOT NULL,
  tb010_nome varchar(255)
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb010_clientes_antigos');

-- tb011_logins
CREATE FOREIGN TABLE tb011_logins (
  tb011_logins        varchar(255) NOT NULL,
  tb010_cpf           numeric(15)  NOT NULL,
  tb011_senha         varchar(255) NOT NULL,
  tb011_data_cadastro timestamp without time zone
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb011_logins');

-- tb012_017_compras
CREATE FOREIGN TABLE tb012_017_compras (
  tb012_017_cod_compra  numeric(10),
  tb012_cod_produto     numeric(10)   NOT NULL,
  tb017_cod_fornecedor  numeric(10)   NOT NULL,
  tb012_017_data        timestamp without time zone,
  tb012_017_quantidade  numeric(10),
  tb012_017_valor_unitario numeric(12,2)
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb012_017_compras');

-- tb012_produtos
CREATE FOREIGN TABLE tb012_produtos (
  tb012_cod_produto  numeric(10)  NOT NULL,
  tb013_cod_categoria numeric(10) NOT NULL,
  tb012_descricao    varchar(255) NOT NULL
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb012_produtos');

-- tb013_categorias
CREATE FOREIGN TABLE tb013_categorias (
  tb013_cod_categoria numeric(10),
  tb013_descricao     varchar(255) NOT NULL
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb013_categorias');

-- tb014_prd_alimentos
CREATE FOREIGN TABLE tb014_prd_alimentos (
  tb014_cod_prd_alimentos numeric(10),
  tb012_cod_produto       numeric(10)  NOT NULL,
  tb014_detalhamento      varchar(255) NOT NULL,
  tb014_unidade_medida    varchar(255) NOT NULL,
  tb014_num_lote          varchar(255),
  tb014_data_vencimento   timestamp without time zone,
  tb014_valor_sugerido    numeric(10,2)
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb014_prd_alimentos');

-- tb015_prd_eletros
CREATE FOREIGN TABLE tb015_prd_eletros (
  tb015_cod_prd_eletro numeric(10),
  tb012_cod_produto    numeric(10)  NOT NULL,
  tb015_detalhamento   varchar(255) NOT NULL,
  tb015_tensao         varchar(255),
  tb015_nivel_consumo_procel char(1),
  tb015_valor_sugerido numeric(10,2)
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb015_prd_eletros');

-- tb016_prd_vestuarios
CREATE FOREIGN TABLE tb016_prd_vestuarios (
  tb016_cod_prd_vestuario numeric(10),
  tb012_cod_produto       numeric(10)  NOT NULL,
  tb016_detalhamento      varchar(255) NOT NULL,
  tb016_sexo              char(1)      NOT NULL,
  tb016_tamanho           varchar(255),
  tb016_numeracao         numeric(3),
  tb016_valor_sugerido    numeric(10,2)
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb016_prd_vestuarios');

-- tb017_fornecedores
CREATE FOREIGN TABLE tb017_fornecedores (
  tb017_cod_fornecedor numeric(10),
  tb017_razao_social   varchar(255),
  tb017_nome_fantasia  varchar(255),
  tb017_fone           varchar(15),
  tb003_cod_endereco   numeric(10)
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb017_fornecedores');

-- tb999_log
CREATE FOREIGN TABLE tb999_log (
  tb999_cod_log numeric(10),
  "tb099_objeto" varchar(100) NOT NULL,
  tb999_dml      varchar(25)  NOT NULL,
  tb999_data     timestamp without time zone NOT NULL
)
SERVER mssql_srv
OPTIONS (schema_name 'dbo', table_name 'tb999_log');
