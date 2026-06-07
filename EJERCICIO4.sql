--4) Mediante un bloque anónimo utilizar un BULK COLLECT para cargar en todas las reservas, 
--luego en el cuerpo del bloque anónimo se debe verificar si la reserva se ha realizado por Internet y cuyo importe sea inferior a 175, 
--los registros que cumplen la condición se deben imprimir. Los datos para mostrar son todos los de la tabla reservas, 
--el nombre de la agencia y la fecha del vuelo. (valor 20%)


--SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    CURSOR C_RESERVAS IS 
        SELECT r.id_reserva, r.importe, r.cli_nif, r.trs_id_treserva,
               ev.cn_emp_viaje AS nombre_agencia, 
               v.fecha_vuelo AS fecha_vuelo
        FROM reservas r
        INNER JOIN vuelos v ON r.vue_id_vuelo = v.id_vuelo
        INNER JOIN agencias a ON r.age_id_agencia = a.id_agencia
        INNER JOIN empresas_viajes ev ON a.evia_id_emp_viaje = ev.id_emp_viaje
        WHERE r.trs_id_treserva = 'INT' 
          AND r.importe < 175;

    TYPE T_RESERVAS IS TABLE OF C_RESERVAS%ROWTYPE;
    V_RESERVAS T_RESERVAS;
BEGIN
    DBMS_OUTPUT.ENABLE(NULL); 

    OPEN C_RESERVAS;
    LOOP
        FETCH C_RESERVAS BULK COLLECT INTO V_RESERVAS LIMIT 1000;
        EXIT WHEN V_RESERVAS.COUNT = 0;

        FOR I IN 1..V_RESERVAS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                'ID: '      || RPAD(TRIM(V_RESERVAS(I).id_reserva), 10) || ' | ' ||
                'IMP: '     || RPAD(V_RESERVAS(I).importe, 7)           || ' | ' ||
                'NIF: '     || RPAD(TRIM(V_RESERVAS(I).cli_nif), 11)    || ' | ' ||
                'TIPO: '    || RPAD(TRIM(V_RESERVAS(I).trs_id_treserva), 5)|| ' | ' ||
                'AGENCIA: ' || RPAD(TRIM(V_RESERVAS(I).nombre_agencia), 25)|| ' | ' ||
                'FECHA: '   || TO_CHAR(V_RESERVAS(I).fecha_vuelo, 'DD/MM/YY')
            );
        END LOOP;
    END LOOP;
    CLOSE C_RESERVAS;
END;



--------------------------------------------------------------COMENTARIOS---------------------------------------------------------------------
/*SELECT COUNT(*) FROM RESERVAS 
WHERE TRS_ID_TRESERVA = 'INT' AND IMPORTE < 175;
42,681 registros desbordan el buffer*/
--AL SER ESA CANTIDAD TAN GRANDE DE REGISTROS DESBORDAN EL BUFFER ENTONCES USAMOS
--DBMS_OUTPUT.ENABLE(NULL); ESTA LINEA NOS HABILITA EL BUFFER ILIMITADO PARA EL TEXTO Y LO EJECUTAMOS EN BLOQUES DE 1000 EN 1000 PARA QUE NO SE SATURE
--Y UTILIZAMOS JOINS PARA FACILITAR LA BUSQUEDA DE DATOS
--AL TENER TANTOS REGISTROS OPTAMOS POR USAR UN SOLO DBMS_OUTPUT.PUT_LINE 
--POR LA CANTIDAD DE REGISTROS EL SCRIPT TARDARÁ APROXIMADAMENTE 7 MINUTOS EN TERMINAR DE EJECTURASE
--TAMBIEN USAR LA LINEA = (SET SERVEROUTPUT ON SIZE UNLIMITED;)
