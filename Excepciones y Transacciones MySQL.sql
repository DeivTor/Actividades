
#Se crea la tabla 'usuarios' para guardar todos los usuarios que se crearán con el procedimiento 'crearUsuario'
CREATE TABLE  usuarios (
id_usuario INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR (15),
apellido VARCHAR (15)
);


DELIMITER $$
CREATE PROCEDURE crearUsuario (nombres VARCHAR(15), apellidos VARCHAR(15)) #Se colocan como parametros los nombres y apellidos del usuario que se quiere crear
BEGIN
DECLARE EXIT HANDLER FOR 1265 # Este handler hara que detenga la ejecucion en el momento de que se encuentre con el error "1265" en cual consiste en sobrepasar el rango que se tiene en una columna.
	BEGIN
		SELECT 'Se ha excedido el tamaño recomendado en el campo nombres y/o apellidos' AS 'ERROR'; # Se muestra al usuario el por que de que no se pudiera crear el usuario
        ROLLBACK; # Hace que la tabla este como antes de la transacción, debido a que, no se cumplio con los requerimientos.
    END;
    START TRANSACTION; # En dado caso de que se cumplan completamente los requerimientos, se insertan los debidos datos a la tabla usuario.
		INSERT INTO usuarios (nombre, apellido) VALUES (nombres, apellidos);
		SELECT 'Usuario creado con exito.' AS 'Completado';
    COMMIT; # Con esta palabra reservada "COMMIT" se confirman las inserciones que se han realizado.
END $$
DELIMITER ;

TRUNCATE usuarios;