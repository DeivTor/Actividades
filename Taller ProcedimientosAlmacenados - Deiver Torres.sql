/*----------------| TALLER |---------------------*/

/* 1. 	Escribe un procedimiento que no tenga ningún parámetro de entrada ni de salida y que muestre el texto ¡Hola mundo!.*/

DELIMITER //
CREATE PROCEDURE holaMundo ()
BEGIN
	DECLARE respuesta VARCHAR (20) DEFAULT "¡Hola Mundo!";
	SELECT respuesta;
END //
DELIMITER ;

/*2. 	Escribe un procedimiento que reciba un número real de entrada, que representa el valor de la nota de un alumno, 
     	y muestre un mensaje indicando qué nota ha obtenido teniendo en cuenta las siguientes condiciones.*/

DELIMITER //
CREATE PROCEDURE evaluadorNota (IN nota FLOAT)
BEGIN
	DECLARE calificacion VARCHAR(20);
    
    	IF (nota >= 0) && (nota < 5) THEN
		SET calificacion = "Insuficiente";
	ELSEIF (nota >= 5) && (nota < 6) THEN
		SET calificacion = "Aprobado";
	ELSEIF (nota >= 6) && (nota < 7) THEN
		SET calificacion = "Bien";
	ELSEIF (nota >= 7) && (nota < 9) THEN
		SET calificacion = "Notable";
	ELSEIF (nota >= 9) && (nota < 10) THEN
		SET calificacion = "Sobresaliente";
	ELSE
		SET calificacion = "Nota no valida";
	END IF;
    
	SELECT calificacion AS "Resultado";
END //
DELIMITER ;

/*3.	Escriba un procedimiento llamado cantidadProductos que reciba como entrada el nombre del tipo de producto 
	y devuelva el número de productos que existen dentro de esa categoría.*/

CREATE TABLE productos (
idProducto INT PRIMARY KEY NOT NULL,
producto VARCHAR(20),
precio INT,
cantidad INT,
tipoProducto VARCHAR(20)
);

INSERT INTO productos (idProducto, producto, precio, cantidad, tipoProducto) 
	VALUE    
		(1,"lapiz",800,34,"utiles"),
		(2,"borrador",500,54,"utiles"),
		(3,"esfero",1000,67,"utiles"),
		(4,"corrector",1200,12,"utiles"),
		(5,"cuaderno",4800,34,"utiles"),
		(6,"regla",2000,78,"utiles"),
		(7,"cubio",600,5,"verduras"),
		(8,"ahuyama",1500,45,"verduras"),
		(9,"brocoli",3000,32,"verduras"),
		(10,"coliflor",3000,10,"verduras"),
		(11,"milanesa",5400,24,"carnes");
        

DELIMITER %%
CREATE PROCEDURE cantidadProductos (IN tipo VARCHAR(20))
BEGIN
	SELECT count(*) AS 'Cantidad_Productos' FROM productos
		WHERE tipoProducto = tipo;
END %%
DELIMITER ;

/*4. 	Escribe un procedimiento que se llame preciosProductos, que reciba como
	parámetro de entrada el nombre del tipo de producto y devuelva como salida tres
	parámetros. El precio máximo, el precio mínimo y la media de los productos que 
	existen en esa categoría. */

DELIMITER %%
CREATE PROCEDURE preciosProductos (IN tipo VARCHAR(20), OUT maxPrecio INT, OUT minPrecio INT, OUT mediaPr INT)
BEGIN
	SELECT max(precio) FROM productos WHERE tipoProducto = tipo INTO maxPrecio;
	SELECT min(precio) FROM productos WHERE tipoProducto = tipo INTO minPrecio;
	SELECT avg(precio) FROM productos WHERE tipoProducto = tipo INTO mediaPrecio;
END %%
DELIMITER ;

/* 5. 	Realice un procedimiento que se llame funcionIVA que incluya una función 
	que calcule el total con el incremento del iva. */
    
DELIMITER %%
CREATE FUNCTION calcularIVA (precio INT)
RETURNS INT
DETERMINISTIC
BEGIN
	SET precio = precio * 1.21;
    	RETURN precio;
END %%
DELIMITER ;


DELIMITER %%
CREATE PROCEDURE funcionIVA (IN valor INT)
BEGIN
	DECLARE total INT;
	SET total = calcularIVA (valor);
    	SELECT concat('$ ',valor) 'Precio_Base', concat('$ ',total) 'Precio_IVA';
END %%
DELIMITER ;

/* 6. 	Escribe un procedimiento que reciba el nombre de un país como parámetro de entrada 
	y realice una consulta sobre la tabla sucursal para obtener todos las sucursales que 
      	existen en la tabla de ese país. */
	
CREATE TABLE paises (
idPais INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre VARCHAR(30)
);

INSERT INTO paises 
	VALUE 	
		(1,"colombia"),
		(2,"mexico"),
		(3,"polonia"),
            	(4,"perú"),
            	(5,"argentina"),
            	(6,"chile");

CREATE TABLE sucursales (
idSucursal INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre VARCHAR (30),
id_pais INT,
FOREIGN KEY (id_pais) REFERENCES paises (idPais)
);

INSERT INTO sucursales 
	VALUE 	
		(1,"portal norte",1),
		(2,"guadalajara",2),
            	(3,"lima",4),
            	(4,"santiago",6),
            	(5,"bosa",1),
            	(6,"bariloche",5),
            	(7,"suba",1),
            	(8,"cordoba",5);

DELIMITER %%
CREATE PROCEDURE sucursalesPais (IN upais VARCHAR(20))
BEGIN
	SELECT nombre FROM sucursales WHERE id_pais = (SELECT idPais FROM paises WHERE nombre = upais);
END %%
DELIMITER ;

/* 7.	Una vez creada la tabla se decide añadir una nueva columna a la tabla llamada 
	edad que será un valor calculado a partir de la columna fecha_nacimiento. Escriba 
        la sentencia SQL necesaria para modificar la tabla y añadir la nueva columna. */
        
CREATE TABLE edad (
idUser INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre VARCHAR (20),
apellido VARCHAR (20),
fecha_nacimiento DATE
);

ALTER TABLE edad ADD COLUMN edad INT;

INSERT INTO edad (nombre, apellido, fecha_nacimiento) VALUES
	('Juan', 'García', '1990-05-23'),
	('María', 'Pérez', '1995-02-10'),
	('Pedro', 'Sánchez', '1987-11-07'),
	('Laura', 'Fernández', '2000-07-12'),
	('Ana', 'González', '1992-04-01'),
    	('Deiver', 'Torres', '2004-11-12');

DELIMITER %%
CREATE PROCEDURE actualizarEdad ()
BEGIN
	/* Se declaran las variables en donde guardaremos los datos recogidos por el cursor.*/
	DECLARE r_fnacimiento DATE;
	DECLARE r_idusuario INT;
	
    	/* Esta variable de "r_edadfinal" hara el calculo de la edad final.*/
	DECLARE r_edadfinal INT;
	
    	/* Este sera quien resguarde el cursor de algun error que suceda en caso de no encontrar datos. */
    	DECLARE fin INTEGER DEFAULT 0;
    
    	/* Declaro mi cursor, en el que recogerá el "idUser, fecha_nacimiento" de la tabla "edad". */
    	DECLARE calcularEdad CURSOR FOR SELECT idUser, fecha_nacimiento FROM edad;
    
    	/* Esta es una sentencia en donde se verifica si siguen encontrando datos, en caso de que no, se ha de cambiar el valor de la variable fin, haciendo que cierre el proceso debido.*/
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
    
	/* Abro o Inicio el cursor */
	OPEN calcularEdad;
		proceso:LOOP
		
		/* Acá en el FETCH, es donde tomará los valores recogidos de "idUser, fecha_nacimiento" y los guardará en las variables correspondientes.*/
		FETCH calcularEdad INTO r_idusuario, r_fnacimiento;

		/* En éste IF, es donde se evalua lo anteriormente dicho sobre cerrar el proceso.*/
		IF fin = 1 THEN
			LEAVE proceso;
		END IF;

		/* Aquí es donde se realiza el calculo de la edad final, en el que sacamos el año del CURDATE y el año de r_fnacimiento, y se guarda en r_edadfinal. */
		SET r_edadfinal = YEAR(CURDATE()) - YEAR(r_fnacimiento);

		/* Acá se hace la debida actualizacion de edad, en el que en la columna edad, insertamos el dato de r_edadfinal, y le colocamos de condicion el id del usuario al que le recogimos los datos.*/
		UPDATE edad SET edad = (r_edadfinal) WHERE idUser = r_idusuario;

	/* Cerramos el LOOP y el Cursor */
	END LOOP; 
	CLOSE calcularEdad;
    
    /* Y listo, asi tenemos la procedimiento de calcular edad con un cursor. */
END %%
DELIMITER ;

/* 8.	Escriba una función llamada calcularEdad que reciba una fecha y devuelva el número de años que han pasado desde la fecha actual hasta la fecha pasada como parámetro: */


DELIMITER %%
CREATE PROCEDURE calcularEdad (IN fecha_usuario DATE)
BEGIN
	DECLARE tiempoTrans INT;
	SET tiempoTrans = YEAR(CURDATE()) - YEAR(fecha_usuario);
    	SELECT CONCAT("Han pasado ", tiempoTrans, " años desde el año ", YEAR(fecha_usuario)," hasta el ",YEAR(CURDATE())) AS 'Años Transcurridos';
END %%
DELIMITER ;

/* 9.	Escriba un procedimiento que permita calcular la edad de todos los usuarios que ya existen en la tabla. Para esto será necesario crear un 
	procedimiento llamado actualizarColumnaEdad que calcule la edad de cada usuario y actualice la tabla. Este procedimiento hará uso de la 
        función calcularEdad que hemos creado en el paso anterior. */
        
	# PROFESORA, SIN QUERER QUERIENDO, YO ENTENDÍ QUE DEBIA HACER LO MISMO PERO EN EL PUNTO 7, PERO AL PARECER ERA MÁS SIMPLE, ENTONCES PUES NO CREO QUE DEBA HACERLO
	# YA QUE LO HICE EN EL PUNTO 7 Y HASTA CON UN CURSOR, ENTONCES NO CREO QUE DEBA HACER LO MISMO, GRACIAS POR SU ENTENDIMIENTO.
    
/* 10.	Escribe un procedimiento almacenado para su proyecto integrador que sea útil. */


CREATE TABLE estructura (
id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre VARCHAR(30),
peso FLOAT,
descripcion VARCHAR(100)
);

CREATE TABLE rueda (
id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre VARCHAR(30),
tamaño FLOAT,
peso FLOAT
);


INSERT INTO estructura (nombre,peso,descripcion) VALUES
	("Convecional", 9.2 ,"Es muy eficaz para terrenos firmes"),
	("Oruga", 12.5 ,"Es muy eficaz para terrenos blandos");

INSERT INTO RUEDA (nombre, tamaño, peso) VALUES
	("Tipo panal", 10, 2.6),
	("Tipo neumatico ancho", 10, 5.5);

DELIMITER %%

CREATE PROCEDURE calcularPesoRover(id_estructura int, id_rueda int)
BEGIN
    	SELECT ROUND(r.peso + e.peso,2) AS PESO_ROVER FROM rueda AS r, estructura AS e 
		WHERE r.id = id_rueda AND e.id = id_estructura;
END %%
DELIMITER ;
