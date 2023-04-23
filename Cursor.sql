
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

CREATE TABLE bonus (
idCliente INT,
nombre VARCHAR(45),
apellido VARCHAR(45),
FOREIGN KEY (idCliente) REFERENCES cliente (cedulaCliente)
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
            
DELIMITER //

CREATE PROCEDURE bonusCliente ()
BEGIN

	DECLARE fin INTEGER DEFAULT 0;
    DECLARE r_cedula INT;
    DECLARE r_nombre VARCHAR(45); 
    DECLARE r_apellido VARCHAR (45);
    DECLARE r_numeroFactura INT;
    
    	DECLARE cliBonus CURSOR FOR SELECT cedulaCliente, nombre, apellido, numeroFacturas
					FROM (SELECT cl.cedulaCliente, cl.nombre, cl.apellido, count(fa.idCliente) AS numeroFacturas FROM cliente cl, factura fa WHERE cl.cedulaCliente = fa.idCliente group by 1) AS NumeroFacturas
                    			WHERE numeroFacturas > 2;
            
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
        
	OPEN cliBonus;
	calcularBonus: LOOP
		FETCH cliBonus INTO r_cedula, r_nombre, r_apellido, r_numeroFactura;
        IF final = 1 THEN
		LEAVE calcularBonus;
	END IF;
        
        INSERT INTO bonus (idCliente, nombre, apellido, numeroFacturas, descripcion) 
		VALUES (r_cedula, r_nombre, r_apellido, r_numeroFactura, "Adquirio un bono del 50% por más de 2 compras");
        
    	END LOOP; 
	CLOSE cliBonus;	
END
//
