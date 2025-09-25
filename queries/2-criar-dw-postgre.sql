create table uf (
  "codUF" numeric(10) primary key,
  "nomeUF" varchar(255)
);

create table cidade (
  "codCidade" numeric(10) primary key,
  "nomeCidade" varchar(255),
  "codUF" numeric(10),
  foreign key ("codUF") references uf ("codUF")
);

create table endereco (
  "codEndereco" numeric(10) primary key,
  "endereco" varchar(255),
  "codCidade" numeric(10),
  foreign key ("codCidade") references cidade ("codCidade")
);

create table loja (
  "codLoja" numeric(10) primary key,
  "cnpj" varchar(255)
);

create table tipo (
  "codTipo" numeric(10) primary key,
  "nomeTipo" varchar(255)
);

create table categoria (
  "codCategoria" numeric(10) primary key,
  "nomeCategoria" varchar(255)
);


create table produto (
  "codProduto" numeric(10) primary key,
  "descricao" varchar(255)
);

create table dia (
  "dia" integer primary key
);

create table mes (
  "mes" integer primary key,
  "nomeMes" varchar(255)
);

create table ano (
  "ano" integer primary key
);

create table cliente (
  "codCliente" numeric(15) primary key,
  "nomeCliente" varchar(255)
);

create table funcionario (
  "codFunci" numeric(10) primary key,
  "nomeFunionario" varchar(255)
);

create table venda (
  quantidade integer,
  valor decimal,
  "codEndereco" numeric(10),
  "codCliente" numeric(15),
  "codFunci" numeric(10),
  "codLoja" numeric(10),
  "codProduto" numeric(10),
  "codTipo" numeric(10),
  "codCategoria" numeric(10),
  "dia" integer,
  "mes" integer,
  "ano" integer,
  foreign key ("codEndereco") references endereco ("codEndereco"),
  foreign key ("codCliente") references cliente ("codCliente"),
  foreign key ("codFunci") references funcionario ("codFunci"),
  foreign key ("codLoja") references loja ("codLoja"),
  foreign key ("codProduto") references produto ("codProduto"),
  foreign key ("dia") references dia ("dia"),
  foreign key ("mes") references mes ("mes"),
  foreign key ("ano") references ano ("ano"),
  foreign key ("codTipo") references tipo ("codTipo"),
  foreign key ("codCategoria") references categoria ("codCategoria")
);
