------------------------------------------------EJERCICIO #2---------------------------------------------

/*Crear un trigger en RESERVAS que registre en una bitácora el importe anterior y el importe nuevo, además de la 
fecha del cambio y el usuario que llevó a cabo la operación. El trigger debe ser capaz de controlar los errores que
se produzcan en la bitácora. La bitácora debe tener un ID único que la identifique  y el cual debe ser generado 
mediante una secuencia. (valor 20%)*/

--CREAMOS LA TABLA DONDE GUARDAREMOS LA INFORMACION

CREATE TABLE BITACORA_RESERVAS (
    ID_BITACORA NUMBER PRIMARY KEY,
    ID_RESERVA  VARCHAR2(10),
    IMPORTE_ANTERIOR NUMBER,
    IMPORTE_NUEVO NUMBER,
    FECHA_CAMBIO DATE,
    USUARIO VARCHAR2(40)
);

--SET SERVEROUTPUT ON;
--SELECT * FROM BITACORA_RESERVAS;

CREATE SEQUENCE SEQ_BITACORA
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;----------------------

CREATE OR REPLACE TRIGGER TG_BITACORA_RESERVAS AFTER UPDATE OF IMPORTE ON RESERVAS
FOR EACH ROW
DECLARE
    V_ERROR VARCHAR2(200);
    V_CODIGO NUMBER;
BEGIN   
    INSERT INTO BITACORA_RESERVAS(
        ID_BITACORA,
        ID_RESERVA,
        IMPORTE_ANTERIOR,
        IMPORTE_NUEVO,
        FECHA_CAMBIO,
        USUARIO
    )
    VALUES(
        SEQ_BITACORA.NEXTVAL,
        :OLD.ID_RESERVA,
        :OLD.IMPORTE,
        :NEW.IMPORTE,
        SYSDATE,
        USER
    );
EXCEPTION
    WHEN OTHERS THEN
        V_ERROR :=SQLERRM;
        V_CODIGO:=SQLCODE;
    IF 
        V_CODIGO =-1 THEN
        DBMS_OUTPUT.PUT_LINE('Error: ID duplicado en la bitacora');
    ELSIF 
        V_CODIGO = -6502 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Tipo de dato incorrecto');
    ELSIF 
        V_CODIGO = -1400 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Se intento insertar un valor nulo');
    ELSIF 
        V_CODIGO = -2291 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Violacion en la llave foranea');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error' || V_CODIGO || ' ' || V_ERROR );
    END IF;

END;
/


