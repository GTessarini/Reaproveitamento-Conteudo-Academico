CREATE TABLE tipos_alteracao
(
	id_tipo_alteracao TINYINT IDENTITY(1,1) NOT NULL,
	nome_tipo_alteracao VARCHAR(100) NOT NULL,
	data_adicao_tipo_alteracao DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);
ALTER TABLE tipos_alteracao ADD CONSTRAINT tipos_alteracao_pk PRIMARY KEY CLUSTERED (id_tipo_alteracao);
CREATE NONCLUSTERED INDEX tipos_alteracao_nome_idx ON tipos_alteracao(nome_tipo_alteracao);

/*
	EXEC ????
	...  ????
	...  ????
*/

/* ---------------------------------------------------------------------------------------- */

CREATE TABLE categorias
(
	id_categoria TINYINT IDENTITY(1,1) NOT NULL,
	nome_categoria VARCHAR(50) NOT NULL,
	data_adicao_categoria DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);
ALTER TABLE categorias ADD CONSTRAINT categorias_pk PRIMARY KEY CLUSTERED (id_categoria);
CREATE NONCLUSTERED INDEX categorias_nome_idx ON categorias(nome_categoria);

/* ----------------------------------------------------------------------------------------*/

CREATE TABLE cursos
(
	id_curso TINYINT IDENTITY(1,1) NOT NULL,
	nome_curso VARCHAR(50) NOT NULL,
	sigla_curso CHAR(3) NOT NULL,
	data_adicao_curso DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);
ALTER TABLE cursos ADD CONSTRAINT cursos_pk PRIMARY KEY CLUSTERED (id_curso);
CREATE NONCLUSTERED INDEX cursos_sigla_idx ON cursos(sigla_curso);

/* ---------------------------------------------------------------------------------------- */

CREATE TABLE turmas
(
	id_turma INTEGER IDENTITY(1,1) NOT NULL,
	numero_turma CHAR(2) NOT NULL,
	ano_turma CHAR(4) NOT NULL,
	data_adicao_turma DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);
ALTER TABLE turmas ADD CONSTRAINT turmas_pk PRIMARY KEY CLUSTERED (id_turma);
CREATE NONCLUSTERED INDEX turmas_numero_idx ON turmas(numero_turma);
CREATE NONCLUSTERED INDEX turmas_ano_idx ON turmas(ano_turma);

EXEC sp_addextendedproperty  
@name = N'MS_Description', @value = '"1", "2", "3" ou "4"',
@level0type = N'Schema', @level0name = db_accessadmin, 
@level1type = N'Table',  @level1name = turmas, 
@level2type = N'Column', @level2name = numero_turma;

EXEC sp_addextendedproperty  
@name = N'MS_Description', @value = '"2018","2019" ...',
@level0type = N'Schema', @level0name = db_accessadmin, 
@level1type = N'Table',  @level1name = turmas, 
@level2type = N'Column', @level2name = ano_turma;

/* ---------------------------------------------------------------------------------------- */

/* ... */

CREATE TABLE conteudos
(
	id_conteudo INTEGER IDENTITY(1,1) NOT NULL,
	numero_conteudo VARCHAR(8) NOT NULL,
	nome_conteudo VARCHAR(100) NOT NULL,
	assuntos_conteudo VARCHAR(300),
	observacoes_conteudo VARCHAR(MAX),
	data_entrega_conteudo DATETIME2(3),
	data_adicao_conteudo DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
	id_tipo_conteudo TINYINT NOT NULL CONSTRAINT conteudos_tipos_conteudo_id_fk REFERENCES tipos_conteudo(id_tipo_conteudo),
	id_categoria_disciplina  TINYINT,
	id_curso_disciplina TINYINT,
	id_turma_disciplina INTEGER, 
	id_disciplina INTEGER,
	data_adicao_curso_turma_disciplina DATETIME2(7)
	/* ... */	
);
ALTER TABLE conteudos ADD CONSTRAINT conteudos_cursos_turmas_disciplinas_id_disciplina_data_adicao_categoria_fk
	FOREIGN KEY(data_adicao_curso_turma_disciplina, id_disciplina) REFERENCES cursos_turmas_disciplinas(data_adicao_curso_turma_disciplina, id_disciplina);
ALTER TABLE conteudos ADD CONSTRAINT conteudos_pk PRIMARY KEY CLUSTERED (id_conteudo);

/*
	EXEC ????
	...  ????
	...  ????
*/

/* ---------------------------------------------------------------------------------------- */

CREATE TABLE reaproveitamentos_conteudos
(
	data_reaproveitamento DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
	id_conteudo_original INTEGER NOT NULL CONSTRAINT reaproveitamentos_conteudos_conteudos_id_original_fk REFERENCES conteudos(id_conteudo),
	id_conteudo_reaproveitado  INTEGER NOT NULL CONSTRAINT reaproveitamentos_conteudos_conteudos_id_reaproveitado_fk REFERENCES conteudos(id_conteudo),
	grau_reaproveitamento TINYINT NOT NULL
);
ALTER TABLE reaproveitamentos_conteudos ADD CONSTRAINT reaproveitamentos_conteudos_pk PRIMARY KEY CLUSTERED (data_reaproveitamento, id_conteudo_original, id_conteudo_reaproveitado);

/* ---------------------------------------------------------------------------------------- */

CREATE TABLE reaproveitamentos_alteracoes
(
	data_reaproveitamento DATETIME2(7) NOT NULL,
	id_conteudo_original INTEGER NOT NULL,
	id_conteudo_reaproveitado  INTEGER NOT NULL,
	id_tipo_alteracao TINYINT NOT NULL CONSTRAINT reaproveitamentos_alteracoes_tipos_alteracao_id_fk REFERENCES tipos_alteracao(id_tipo_alteracao),
	data_reaproveitamento_alteracao DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
);
ALTER TABLE reaproveitamentos_alteracoes ADD CONSTRAINT reaproveitamentos_alteracoes_reaproveitamentos_id_conteudos_data_fk 
	FOREIGN KEY(data_reaproveitamento, id_conteudo_original, id_conteudo_reaproveitado) REFERENCES reaproveitamentos_conteudos(data_reaproveitamento, id_conteudo_original, id_conteudo_reaproveitado);
ALTER TABLE reaproveitamentos_alteracoes ADD CONSTRAINT reaproveitamentos_alteracoes_pk PRIMARY KEY CLUSTERED (data_reaproveitamento, id_conteudo_original, id_conteudo_reaproveitado, id_tipo_alteracao);

/* ---------------------------------------------------------------------------------------- */

/* ... */

/*  
	Para detalhes completos ou desejo de implantação oficial, entre em contato com o desenvolvedor responsável por este projeto:
	* Gabriel Tessarini 
	* E-mail: gtessarini@gmail.com
*/
