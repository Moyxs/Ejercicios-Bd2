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
    NOCACHE;----------------------

CREATE OR REPLACE TRIGGER TG_BITACORA_RESERVAS AFTER UPDATE OF IMPORTE ON RESERVAS
FOR EACH ROW
DECLARE
    V_ERROR VARCHAR2(200);
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
        :OLD,IMPORTE,
        :NEW:IMPORTE,
        SYSDATE,
        USER
    );
EXCEPTION
    WHEN OTHERS THEN
        V_ERROR :=SQLERM;
        DBMS_OUT.PUT_LINE('Error en la Bitácora: ' ||V_ERROR);

END;



