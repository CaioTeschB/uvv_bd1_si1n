-- Caio Tesch Bullerjahn
-- 202306934
-- SI1N


DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS caio_tesch_bullerjahn;


-- Criar o usuário "caio_tesch_bullerjahn"
CREATE USER caio_tesch_bullerjahn WITH PASSWORD 'Caio2005';
ALTER USER caio_tesch_bullerjahn CREATEDB;
ALTER USER caio_tesch_bullerjahn CREATEROLE;


-- Criar o banco de dados "uvv"
CREATE DATABASE uvv WITH 
	OWNER 				= caio_tesch_bullerjahn 
	TEMPLATE  			= template0
	ENCODING  			= 'UTF8 ' 
	LC_COLLATE 			= 'pt_BR.UTF-8' 
	LC_CTYPE 			= 'pt_BR.UTF-8'
	ALLOW_CONNECTIONS 	= true;
	
COMMENT ON DATABASE uvv IS 'Banco de dados referente aos PSETs da matéria de Desenvolvimento de Banco de Dados.';


-- Definir a variável ambiente de senha
\setenv PGPASSWORD 'Caio2005'
-- Conectar ao banco "uvv" com o usuário "caio_tesch_bullerjahn" utilizando a senha definida anteriormente
\c uvv caio_tesch_bullerjahn;


-- Criar o esquema "lojas" e dar permissão ao usuário "caio_tesch_bullerjahn" para manipulá-lo
CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION caio_tesch_bullerjahn;

COMMENT ON SCHEMA lojas IS 'Esquema utilizado no PSET 1. Simulação de uma pequena rede de lojas';


-- Alterar o usuário para definir o esquema "lojas" como padrão
ALTER USER caio_tesch_bullerjahn SET SEARCH_PATH TO lojas, "$user", public;



-- Criar a tabela "produtos" e sua PK no esquema "lojas"
CREATE TABLE lojas.produtos (
    produto_id 					NUMERIC(38)  NOT NULL,
    nome 						VARCHAR(255) NOT NULL,
    preco_unitario 				NUMERIC(10,2),
    detalhes 					BYTEA,
    imagem 						BYTEA,
    imagem_mime_type 			VARCHAR(512),
    imagem_arquivo 				VARCHAR(512),
    imagem_charset 				VARCHAR(512),
    imagem_ultima_atualizacao 	DATE,
    CONSTRAINT pk_produtos PRIMARY KEY (produto_id)
);
-- Criar comentários que descrevem a tabela e suas colunas
COMMENT ON TABLE  lojas.produtos                           IS 'Registro dos produtos.';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'PK da tabela. Identificação do produto.';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'Nome do produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'Preço unitário do produto.';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'Detalhes do produto.';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'Imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'Tipo de mídia da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'Arquivo da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'Charset da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Data da última atualização da imagem do produto.';
-- Criar restrições de checagem para as colunas
ALTER TABLE lojas.produtos 
	ADD CONSTRAINT cc_produtos_preco_unitario CHECK (preco_unitario > 0);



-- Criar a tabela "lojas" e sua PK no esquema "lojas"
CREATE TABLE lojas.lojas (
    loja_id 				NUMERIC(38) 	NOT NULL,
    nome 					VARCHAR(255) 	NOT NULL,
    endereco_web 			VARCHAR(100),
    endereco_fisico 		VARCHAR(512),
    latitude 				NUMERIC,
    longitude 				NUMERIC,
    logo 					BYTEA,
    logo_mime_type 			VARCHAR(512),
    logo_arquivo 			VARCHAR(512),
    logo_charset 			VARCHAR(512),
    logo_ultima_atualizacao DATE,
    CONSTRAINT pk_lojas PRIMARY KEY (loja_id)
);
-- Criar comentários que descrevem a tabela e suas colunas
COMMENT ON TABLE  lojas.lojas                         IS 'Registro de lojas.';
COMMENT ON COLUMN lojas.lojas.loja_id                 IS 'PK da tabela. Identificação da loja.';
COMMENT ON COLUMN lojas.lojas.nome                    IS 'Nome da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_web            IS 'Endereço web da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico         IS 'Endereço físico da loja.';
COMMENT ON COLUMN lojas.lojas.latitude                IS 'Latitude da loja.';
COMMENT ON COLUMN lojas.lojas.longitude               IS 'Longitude da loja.';
COMMENT ON COLUMN lojas.lojas.logo                    IS 'Logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type          IS 'Tipo de mídia do logo do site.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo            IS 'Arquivo do logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_charset            IS 'Charset da logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Data da última atualização da logo da loja.';
-- Criar restrições de checagem para as colunas
ALTER TABLE lojas.lojas 
	ADD CONSTRAINT cc_lojas_endereco_fisico CHECK (
		CASE 
			WHEN endereco_fisico IS NULL     THEN endereco_web IS NOT NULL
			WHEN endereco_fisico IS NOT NULL THEN endereco_web IS NOT NULL OR endereco_web IS NULL
		END
	);



-- Criar a tabela "estoques" e sua PK no esquema "lojas"
CREATE TABLE lojas.estoques (
	estoque_id 	NUMERIC(38) NOT NULL,
	loja_id 	NUMERIC(38) NOT NULL,
	produto_id 	NUMERIC(38) NOT NULL,
	quantidade 	NUMERIC(38) NOT NULL,
	CONSTRAINT pk_estoques PRIMARY KEY (estoque_id)
);
-- Criar comentários que descrevem a tabela e suas colunas
COMMENT ON TABLE  lojas.estoques            IS 'Registro de produtos em estoque.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'PK da tabela. Identificação do estoque.';
COMMENT ON COLUMN lojas.estoques.loja_id    IS 'FK com lojas. Identificação da loja que o estoque pertence.';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'FK com produtos. Identificação do produto em estoque.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Quantidade em estoque do produto.';
-- Criar restrições de checagem para as colunas
ALTER TABLE lojas.estoques 
	ADD CONSTRAINT cc_estoques_quantidade CHECK (quantidade > 0);
	


-- Criar a tabela "clientes" e sua PK no esquema "lojas"
CREATE TABLE lojas.clientes (
    cliente_id 	NUMERIC(38) 	NOT NULL,
    email 		VARCHAR(255) 	NOT NULL,
    nome 		VARCHAR(255) 	NOT NULL,
    telefone1	VARCHAR(20),
    telefone2 	VARCHAR(20),
    telefone3 	VARCHAR(20),
    CONSTRAINT pk_clientes PRIMARY KEY (cliente_id)
);
-- Criar comentários que descrevem a tabela e suas colunas
COMMENT ON TABLE  lojas.clientes            IS 'Registro de clientes.';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'PK da tabela. Identificação do cliente.';
COMMENT ON COLUMN lojas.clientes.email      IS 'Endereço de email do cliente.';
COMMENT ON COLUMN lojas.clientes.nome       IS 'Nome completo do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone1  IS 'Primeiro número de telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'Segundo número de telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone3  IS 'Terceiro número de telefone do cliente.';
-- Criar restrições de checagem para as colunas
ALTER TABLE lojas.clientes 
	ADD CONSTRAINT cc_clientes_email CHECK (email like '%@%');



-- Criar a tabela "envios" e sua PK no esquema "lojas"
CREATE TABLE lojas.envios (
    envio_id 			NUMERIC(38) 	NOT NULL,
    loja_id				NUMERIC(38) 	NOT NULL,
    cliente_id 			NUMERIC(38) 	NOT NULL,
    endereco_entrega 	VARCHAR(512) 	NOT NULL,
    status 				VARCHAR(15) 	NOT NULL,
    CONSTRAINT pk_envios PRIMARY KEY (envio_id)
);
-- Criar comentários que descrevem a tabela e suas colunas
COMMENT ON TABLE  lojas.envios 	                IS 'Registro do envio dos pedidos.';
COMMENT ON COLUMN lojas.envios.envio_id         IS 'PK da tabela. Identificação dos envios.';
COMMENT ON COLUMN lojas.envios.loja_id          IS 'FK com lojas. Identificação da loja de onde o pedido está sendo enviado.';
COMMENT ON COLUMN lojas.envios.cliente_id       IS 'FK com clientes. Identificação do cliente para quem o pedido está sendo enviado.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Endereço de entrega do envio.';
COMMENT ON COLUMN lojas.envios.status           IS 'Status do envio.';
-- Criar restrições de checagem para as colunas
ALTER TABLE lojas.envios 
	ADD CONSTRAINT cc_envios_status CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));



-- Criar a tabela "pedidos" e sua PK no esquema "lojas"
CREATE TABLE lojas.pedidos (
    pedido_id 	NUMERIC(38) NOT NULL,
    data_hora 	TIMESTAMP 	NOT NULL,
    cliente_id 	NUMERIC(38) NOT NULL,
    status 		VARCHAR(15) NOT NULL,
    loja_id 	NUMERIC(38) NOT NULL,
    CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id)
);
-- Criar comentários que descrevem a tabela e suas colunas
COMMENT ON TABLE  lojas.pedidos            IS 'Registro dos pedidos realizados pelos clientes.';
COMMENT ON COLUMN lojas.pedidos.pedido_id  IS 'PK da tabela. Identificação do pedido.';
COMMENT ON COLUMN lojas.pedidos.data_hora  IS 'Data e hora da realização do pedido.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'FK com clientes. Identificação do cliente que realizou o pedido.';
COMMENT ON COLUMN lojas.pedidos.status     IS 'Status do pedido.';
COMMENT ON COLUMN lojas.pedidos.loja_id    IS 'FK com lojas. Identificação da loja para qual o pedido foi feito.';
-- Criar restrições de checagem para as colunas
ALTER TABLE lojas.pedidos 
	ADD CONSTRAINT cc_pedidos_status CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));



-- Criar a tabela "pedidos_itens" e sua PK no esquema "lojas"
CREATE TABLE lojas.pedidos_itens (
    pedido_id 		NUMERIC(38) 	NOT NULL,
    produto_id 		NUMERIC(38) 	NOT NULL,
    numero_da_linha NUMERIC(38) 	NOT NULL,
    preco_unitario 	NUMERIC(10,2) 	NOT NULL,
    quantidade 		NUMERIC(38) 	NOT NULL,
    envio_id 		NUMERIC(38),
    CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);
-- Criar comentários que descrevem a tabela e suas colunas
COMMENT ON TABLE  lojas.pedidos_itens                  IS 'Registro dos produtos requisitados em um pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id        IS 'Parte da PK da tabela. FK com pedidos. Identificação do item do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id       IS 'Parte da PK da tabela. FK com produtos. Identificação do produto do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha  IS 'Número da linha do item do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario   IS 'Preço unitário do item do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade       IS 'Quantidade do item do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id         IS 'FK com envios. Envio do item do pedido.';
-- Criar restrições de checagem para as colunas
ALTER TABLE lojas.pedidos_itens 
	ADD CONSTRAINT cc_pedidos_itens_numero_linha   CHECK (numero_da_linha > 0),
	ADD CONSTRAINT cc_pedidos_itens_preco_unitario CHECK (preco_unitario > 0),
	ADD CONSTRAINT cc_pedidos_itens_quantidade     CHECK (quantidade > 0);



-- Alterar tabela pedidos_itens para criar relacionamento com produtos
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterar tabela estoques para criar relacionamento com produtos
ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterar tabela pedidos para criar relacionamento com lojas
ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterar tabeça envios para criar relacionamento com lojas
ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterar tabela estoques para criar relacionamento com lojas
ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterar tabela pedidos para criar relacionamento com clientes
ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterar tabela envios para criar relacionamento com clientes
ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterar a tabela pedidos_itens para criar relacionamento com envios
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterar a tabela pedidos_itens para criar relacionamento com pedidos
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;