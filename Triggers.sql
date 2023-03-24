
-- Creamos una tabla llamada tipoProducto
CREATE TABLE tipoProducto(
	idTipoProducto INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(20) NOT NULL
);

-- Creamos una tabla llamada producto
CREATE TABLE producto (
idProducto INT PRIMARY KEY AUTO_INCREMENT,
idTipoProducto INT,
nombre VARCHAR (20),
valorVenta INT,
FOREIGN KEY (idTipoProducto) REFERENCES tipoProducto(idTipoProducto)
);

-- Creamos una tabla llamada inventario
CREATE TABLE inventario (
id INT PRIMARY KEY AUTO_INCREMENT,
idProducto INT,
cantidad INT,
FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

-- Creamos una tabla llamada cliente
CREATE TABLE cliente (
cedulaCliente INT PRIMARY KEY,
nombre VARCHAR(45),
apellido VARCHAR(45),
telefono INT(20)
);

-- Creamos una tabla llamada 
CREATE TABLE vendedor (
cedulaVendedor INT PRIMARY KEY,
nombre VARCHAR(45),
apellido VARCHAR(45),
telefono INT(20)
);

-- Creamos una tabla llamada inventario
CREATE TABLE factura (
idFactura INT PRIMARY KEY AUTO_INCREMENT,
idCliente INT,
idProducto INT,
idVendedor INT,
cantidad INT,
fechaVenta DATETIME,
FOREIGN KEY (idCliente) REFERENCES cliente(cedulaCliente),
FOREIGN KEY (idProducto) REFERENCES producto(idProducto),
FOREIGN KEY (idVendedor) REFERENCES vendedor(cedulaVendedor)
);

-- Creamos una tabla llamada audiFacturaVenta
CREATE TABLE audiFacturaVenta (
idAuditoria INT PRIMARY KEY AUTO_INCREMENT,
usuario VARCHAR(45),
fechaRealizacion DATETIME,
observacion VARCHAR (100)
);

-- Hacemos inserciones a las tablas correspondientes
INSERT INTO tipoProducto (nombre)
	VALUES 	('Utiles'),
			('Dulces'),
            ('Herramientas');

INSERT INTO producto (idTipoProducto, nombre, valorVenta)
	VALUES 	(1, 'Lapiz', 800),
			(1, 'Borrador', 500),
            (2, 'Quipitos', 500),
            (3, 'Metro', 10000),
            (1, 'Corrector', 1000),
            (2, 'Masmelo', 400),
            (3, 'Mazo', 25000),
			(3, 'Martillo', 18000);
            
INSERT INTO inventario (idProducto, cantidad)
	VALUES 	(1, 30),
			(2, 30),
            (3, 30),
            (4, 30),
            (5, 30),
            (6, 30),
            (7, 30),
			(8, 30);

INSERT INTO cliente (cedulaCliente, nombre, apellido, telefono)
	VALUES	(12345, 'Andres', 'Arias', 937254019),
			(45324, 'Julian', 'Cruz', 233456234),
            (12455, 'Juan', 'Veloza', 238326234);

            
INSERT INTO vendedor (cedulaVendedor, nombre, apellido, telefono)
	VALUES	(18634, 'Sebastian', 'Arevalo', 456875234),
            (56234, 'Didier', 'Fandiño', 444576345),
			(34545, 'Isabel', 'Hurtado', 344563234);
            
INSERT INTO factura (idCliente, idProducto, idVendedor, cantidad, fechaVenta)
	VALUES	(12345, 3, 18634, 1, now()),
			(45324, 7, 56234, 5, now()),
            (12455, 1, 34545, 3, now());
            

SELECT * FROM inventario;
SELECT * FROM factura;
INSERT INTO factura (idCliente, idProducto, idVendedor, cantidad, fechaVenta) VALUES (12345, 5, 34545, 11, now());
SELECT * FROM FACTURA;
SELECT * FROM inventario;
            
-- Realizaremos el Trigger

DELIMITER //
CREATE TRIGGER ventaProducto 
AFTER INSERT ON factura FOR EACH ROW
BEGIN
	UPDATE inventario SET cantidad = cantidad - new.cantidad WHERE idProducto = new.idProducto;
END;
//

DELIMITER //
CREATE TRIGGER audiFactura
AFTER INSERT ON factura FOR EACH ROW
BEGIN
	INSERT INTO audifacturaventa (usuario, fechaRealizacion, observacion)
		VALUES (user(), now(), (CONCAT('Se agrego una venta de:  |',(SELECT nombre FROM producto p WHERE p.idProducto = new.idProducto),
										'| Precio sin IVA:   |',(SELECT valorVenta FROM producto p WHERE p.idProducto = new.idProducto),
                                        '| Precio con IVA:   |',((SELECT valorVenta FROM producto p WHERE p.idProducto = new.idProducto)*1.21),'|')));
END;
//
