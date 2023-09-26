CREATE DATABASE ecommerce;

USE ecommerce;

CREATE TABLE Vendas (
  NumeroPedido INT AUTO_INCREMENT PRIMARY KEY,
  DataVenda DATE NOT NULL,
  NomeCliente VARCHAR(80),
  DDD VARCHAR(2),
  Telefone VARCHAR(9),
  NomeVendedor VARCHAR(80) NOT NULL,
  ValorPedidoTotal DECIMAL(8, 2) NOT NULL,
  FormaPagamento ENUM ('CH', 'R$', 'BO', 'CC', 'CD'),
  -- CHeque, Dinheiro, BOleto, Cartão Crédito, Cartão Débito
  OBS TEXT
);

CREATE TABLE EntregaEncomenda (
  NumeroEntrega INT AUTO_INCREMENT PRIMARY KEY,
  DataEntrega DATE NOT NULL,
  NumeroPedido INT NOT NULL,
  CodigoEntregador INT NOT NULL,
  EnderecoEntrega VARCHAR(100) NOT NULL,
  Bairro VARCHAR(25) NOT NULL,
  Cidade VARCHAR(40) NOT NULL,
  CEP VARCHAR(9) NOT NULL,
  Entregue BOOLEAN DEFAULT 0,
  PesoBruto DECIMAL(6, 3) NOT NULL,
  OBS TEXT
);

CREATE TABLE ContasReceber (
  DataPrevista DATE,
  NumeroPedido INT AUTO_INCREMENT PRIMARY KEY,
  DataVenda DATE,
  NumeroParcela INT,
  ValorParcela DECIMAL(8, 2),
  NomeCliente VARCHAR (80),
  NomeVendedor VARCHAR(80)
);
