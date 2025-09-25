INSERT INTO uf ("codUF","nomeUF")
SELECT
  (COALESCE((SELECT MAX("codUF") FROM uf),0)
   + ROW_NUMBER() OVER (ORDER BY s.tb001_sigla_uf))::numeric(10) AS codUF,
  s.tb001_sigla_uf                                               AS nomeUF
FROM (
  SELECT DISTINCT tb001_sigla_uf
  FROM tb001_uf
  WHERE tb001_sigla_uf IS NOT NULL
) s;

INSERT INTO cidade ("codCidade", "nomeCidade", "codUF")
SELECT
  c.tb002_cod_cidade::numeric(10),
  c.tb002_nome_cidade,
  u."codUF"
FROM tb002_cidades c
JOIN uf u
  ON u."nomeUF" = c.tb001_sigla_uf  
WHERE c.tb002_cod_cidade IS NOT NULL
ON CONFLICT ("codCidade") DO NOTHING;

INSERT INTO categoria ("codCategoria", "nomeCategoria")
SELECT c.tb013_cod_categoria::numeric(10),
       c.tb013_descricao
FROM tb013_categorias c;

WITH presentes AS (
  SELECT 'ALIMENTOS'::varchar(255) AS "nomeTipo"
  WHERE EXISTS (SELECT 1 FROM tb014_prd_alimentos)
  UNION
  SELECT 'ELETROS'
  WHERE EXISTS (SELECT 1 FROM tb015_prd_eletros)
  UNION
  SELECT 'VESTUARIOS'
  WHERE EXISTS (SELECT 1 FROM tb016_prd_vestuarios)
),
novos AS (
  SELECT p."nomeTipo"
  FROM presentes p
  WHERE NOT EXISTS (
    SELECT 1 FROM tipo t WHERE t."nomeTipo" = p."nomeTipo"
  )
),
numerados AS (
  SELECT
    (COALESCE((SELECT MAX("codTipo") FROM tipo), 0)
     + ROW_NUMBER() OVER (ORDER BY "nomeTipo"))::numeric(10) AS "codTipo",
    "nomeTipo"
  FROM novos
)
INSERT INTO tipo ("codTipo", "nomeTipo")
SELECT "codTipo", "nomeTipo"
FROM numerados;

INSERT INTO endereco ("codEndereco", "endereco", "codCidade")
SELECT e.tb003_cod_endereco::numeric(10),
       concat_ws(' - ',
         concat_ws(', ', e.tb003_nome_rua, e.tb003_numero_rua),
         e.tb003_bairro,
         e."tb003_CEP"
       ) AS endereco_fmt,
       e.tb002_cod_cidade::numeric(10)
FROM tb003_enderecos e
ON CONFLICT ("codEndereco") DO NOTHING;

INSERT INTO loja ("codLoja", "cnpj")
SELECT l.tb004_cod_loja::numeric(10),
       l.tb004_cnpj_loja
FROM tb004_lojas l
ON CONFLICT ("codLoja") DO NOTHING;

INSERT INTO produto ("codProduto", "descricao")
SELECT p.tb012_cod_produto::numeric(10),
       p.tb012_descricao
FROM tb012_produtos p
ON CONFLICT ("codProduto") DO NOTHING;

INSERT INTO cliente ("codCliente", "nomeCliente")
SELECT c.tb010_cpf::numeric(15),
       c.tb010_nome
FROM tb010_clientes c
ON CONFLICT ("codCliente") DO NOTHING;

INSERT INTO funcionario ("codFunci", "nomeFunionario")
SELECT f.tb005_matricula::numeric(10),
       f.tb005_nome_completo
FROM tb005_funcionarios f
ON CONFLICT ("codFunci") DO NOTHING;

INSERT INTO dia ("dia")
SELECT d::int
FROM generate_series(1, 31) AS d;

WITH m AS (
  SELECT ms::int AS mes
  FROM generate_series(1, 12) AS ms
)
INSERT INTO mes ("mes", "nomeMes")
SELECT
  m.mes,
  to_char(make_date(2000, m.mes, 1), 'TMMonth') AS "nomeMes"
FROM m;

WITH anos AS (
  SELECT DISTINCT EXTRACT(YEAR FROM v.tb010_012_data)::int AS ano
  FROM tb010_012_vendas v
)
INSERT INTO ano ("ano")
SELECT ano
FROM anos;

WITH vendas_base AS (
  SELECT
    v.tb012_cod_produto::numeric(10)   AS cod_produto,
    NULLIF(v.tb010_cpf,0)::numeric(15) AS cod_cliente,
    NULLIF(v.tb005_matricula,0)::numeric(10) AS cod_funci,
    NULLIF(f.tb004_cod_loja,0)::numeric(10)  AS cod_loja,
    NULLIF(l.tb003_cod_endereco,0)::numeric(10) AS cod_endereco,
    v.tb010_012_data::timestamp        AS data_venda,
    v.tb010_012_quantidade::numeric(10)      AS qtd,
    (v.tb010_012_quantidade * v.tb010_012_valor_unitario)::numeric(18,4) AS vlr
  FROM tb010_012_vendas v
  LEFT JOIN tb005_funcionarios f ON f.tb005_matricula = v.tb005_matricula
  LEFT JOIN tb004_lojas       l ON l.tb004_cod_loja  = f.tb004_cod_loja
),
detalhe AS (
  SELECT
    cod_produto, cod_cliente, cod_funci, cod_loja, cod_endereco,
    EXTRACT(YEAR  FROM data_venda)::int AS ano,
    EXTRACT(MONTH FROM data_venda)::int AS mes,
    EXTRACT(DAY   FROM data_venda)::int AS dia,
    qtd, vlr
  FROM vendas_base
)
INSERT INTO venda (
  "quantidade","valor",
  "codEndereco","codCliente","codFunci","codLoja","codProduto",
  "dia","mes","ano"
)
SELECT
  SUM(qtd)::int                          AS quantidade,
  SUM(vlr)::numeric(18,4)                AS valor,
  cod_endereco, cod_cliente, cod_funci, cod_loja, cod_produto,
  dia, mes, ano
FROM detalhe
GROUP BY ROLLUP (
  cod_produto,
  cod_cliente,
  cod_funci,
  cod_loja,
  cod_endereco,
  ano,
  mes,
  dia
);