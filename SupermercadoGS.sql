
CREATE SCHEMA IF NOT EXISTS `sumerca` DEFAULT CHARACTER SET latin1 ;
USE `sumerca` ;

-- -----------------------------------------------------
-- Table `sumerca`.`Usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sumerca`.`Usuarios` ;

CREATE TABLE IF NOT EXISTS `sumerca`.`Usuarios` (
  `idUsuarios` INT(18) NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `apellido` VARCHAR(45) NULL,
  `fechaNacimiento` DATE NULL,
  `direccion` VARCHAR(45) NULL,
  `telefono` VARCHAR(20) NULL,
  PRIMARY KEY (`idUsuarios`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `sumerca`.`clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sumerca`.`clientes` ;

CREATE TABLE IF NOT EXISTS `sumerca`.`clientes` (
  `cedula` INT(18) NOT NULL DEFAULT '0',
  `puntaje` INT NULL,
  `paginaWeb` VARCHAR(60) NULL,
  `direccion` VARCHAR(45) NULL,
  PRIMARY KEY (`cedula`),
  CONSTRAINT `fkusuariosClientes`
    FOREIGN KEY (`cedula`)
    REFERENCES `sumerca`.`Usuarios` (`idUsuarios`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;
-- -----------------------------------------------------
-- Table `sumerca`.`tipoproductos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sumerca`.`tipoproductos` ;

CREATE TABLE IF NOT EXISTS `sumerca`.`tipoproductos` (
  `idTipoProducto` INT(18) NOT NULL DEFAULT '0',
  `nombreTipoProducto` VARCHAR(50) CHARACTER SET 'utf8' NULL,
  PRIMARY KEY (`idTipoProducto`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;
-- -----------------------------------------------------
-- Table `sumerca`.`productos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sumerca`.`productos` ;

CREATE TABLE `productos` (
  `idProducto` INT(18) PRIMARY KEY NOT NULL,
  `idTipoProducto` INT(18) NULL,
  `nombreProducto` VARCHAR(50) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `valorVenta` INT(18) NULL DEFAULT NULL,
  CONSTRAINT `FK_TIPOPRODUCTO`
    FOREIGN KEY (`idTipoProducto`)
    REFERENCES `sumerca`.`tipoproductos` (`idTipoProducto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;
-- -----------------------------------------------------
-- Table `sumerca`.`sucursal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sumerca`.`sucursal` ;

CREATE TABLE IF NOT EXISTS `sumerca`.`sucursal` (
  `idSucursal` INT(18) NOT NULL,
  `nombre` VARCHAR(50) NULL,
  `direccion` VARCHAR(50) NULL DEFAULT NULL,
  `ciudad` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`idSucursal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;
-- -----------------------------------------------------
-- Table `sumerca`.`vendedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sumerca`.`vendedor` ;

CREATE TABLE IF NOT EXISTS `sumerca`.`vendedor` (
  `Cedula` INT(18) NOT NULL,
  `idSucursal` INT(18) NULL DEFAULT NULL,
  `salario` VARCHAR(45) NULL,
  PRIMARY KEY (`Cedula`),
  CONSTRAINT `FK_VENDEDOR`
    FOREIGN KEY (`idSucursal`)
    REFERENCES `sumerca`.`sucursal` (`idSucursal`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fkVendedorUsuarios`
    FOREIGN KEY (`Cedula`)
    REFERENCES `sumerca`.`Usuarios` (`idUsuarios`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;
-- -----------------------------------------------------
-- Table `sumerca`.`factura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sumerca`.`factura` ;

CREATE TABLE IF NOT EXISTS `sumerca`.`factura` (
  `numeroFactura` INT(18) NOT NULL DEFAULT '0',
  `idProducto` INT(18) NULL DEFAULT NULL,
  `idVendedor` INT(18) NULL DEFAULT NULL,
  `idCliente` INT(18) NULL DEFAULT NULL,
  `cantidad` INT(18) NULL DEFAULT NULL,
  `fechaVenta` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`numeroFactura`),
  CONSTRAINT `FK_CLIENTE` FOREIGN KEY (`idCliente`) REFERENCES `sumerca`.`clientes` (`cedula`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_PRODUCTOFAC` FOREIGN KEY (`idProducto`) REFERENCES `sumerca`.`productos` (`idProducto`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_VENDEDORFAC` FOREIGN KEY (`idVendedor`) REFERENCES `sumerca`.`vendedor` (`Cedula`)
    ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;
-- -----------------------------------------------------
-- Table `sumerca`.`inventario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sumerca`.`inventario` ;

CREATE TABLE IF NOT EXISTS `sumerca`.`inventario` (
  `idProducto` INT(18) NOT NULL,
  `cantidad` INT(18) NULL,
  `valor` INT(18) NULL,
  PRIMARY KEY (`idProducto`),
  CONSTRAINT `FK_PRODUCTO`
    FOREIGN KEY (`idProducto`)
    REFERENCES `sumerca`.`productos` (`idProducto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


Insert into inventario(idProducto,cantidad,valor) values(1,9,1200);
Insert into inventario(idProducto,cantidad,valor) values(2,15,2500);
Insert into inventario(idProducto,cantidad,valor) values(3,20,3000);

DELIMITER $$
CREATE TRIGGER actualizar_inventario_ 
AFTER INSERT ON factura
FOR EACH ROW
BEGIN
DECLARE cantidad_producto INT;

SELECT cantidad INTO cantidad_producto FROM inventario WHERE idProducto = NEW.idProducto;

IF cantidad_producto > 0 THEN
UPDATE inventario SET cantidad = cantidad - 1 WHERE idProducto = NEW.idProducto;
END IF;
END$$

insert into factura(numeroFactura,idProducto,cantidad,fechaVenta) values(2,3,1,now());
select * from inventario;
