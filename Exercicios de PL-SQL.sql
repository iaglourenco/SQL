--Exercicios de PL-SQL



--CRIA A TABLE SALDO
CREATE TABLE SALDO(NR_CONTA NUMBER,VALOR NUMBER);

--CRIA A TABLE MOVIMENTO
CREATE TABLE MOVIMENTO(NR_MOV NUMBER,NR_CONTA NUMBER,DT_MOV DATE,TP_MOV CHAR,VALOR NUMBER(15,2));

--CRIA A TABLE MOVIMENTO_HISTORICO
CREATE TABLE MOVIMENTO_HISTORICO(NR_MOV NUMBER,DT_REGISTRO DATE,NR_CONTA NUMBER,DT_MOV DATE,TP_MOV CHAR,VALOR NUMBER(15,2));


--CRIA PRIMARY KEY E FOREIGN KEY
ALTER TABLE SALDO ADD CONSTRAINT PK_CONTA PRIMARY KEY(NR_CONTA);
ALTER TABLE MOVIMENTO ADD CONSTRAINT PK_MOV PRIMARY KEY(NR_MOV);
ALTER TABLE MOVIMENTO ADD CONSTRAINT CH_MOV_TP_MOV CHECK(TP_MOV IN('D','C'));

--INSERTS

INSERT INTO MOVIMENTO VALUES(1,20,TO_DATE('16/04/18','DD/MM/YY'),'C',3000);
INSERT INTO MOVIMENTO VALUES(2,30,TO_DATE('16/04/18','DD/MM/YY'),'C',1000);
INSERT INTO MOVIMENTO VALUES(3,40,TO_DATE('16/04/18','DD/MM/YY'),'D',1000);
INSERT INTO MOVIMENTO VALUES(4,20,TO_DATE('27/03/18','DD/MM/YY'),'C',120.3);
INSERT INTO MOVIMENTO VALUES(5,20,TO_DATE('27/03/18','DD/MM/YY'),'D',200);
INSERT INTO MOVIMENTO VALUES(6,20,TO_DATE('27/03/18','DD/MM/YY'),'C',1220);
INSERT INTO MOVIMENTO VALUES(7,30,TO_DATE('12/07/11','DD/MM/YY'),'C',200);
INSERT INTO MOVIMENTO VALUES(8,30,TO_DATE('02/06/11','DD/MM/YY'),'D',100);
INSERT INTO MOVIMENTO VALUES(9,40,TO_DATE('27/03/18','DD/MM/YY'),'C',120);
INSERT INTO MOVIMENTO VALUES(10,20,TO_DATE('16/04/18','DD/MM/YY'),'C',2000);

INSERT INTO SALDO VALUES(20,0);
INSERT INTO SALDO VALUES(30,0); 
INSERT INTO SALDO VALUES(40,0);

--PROCEDURES
--ANTES DE TUDO ATIVE A SAIDA DE DADOS:
--	SET SERVEROUTPUT ON; PERMITE IMPRESSAO DE DADOS
--PARA EXECUTAR UMA PROCEDURE:
--	EXEC <NOME-DA-PROCEDURE>(<PARAMETROS>);

--CALCULA SALDO DE UMA CONTA
 CREATE OR REPLACE PROCEDURE CALC_SALDO (P_NR_CONTA NUMBER)  AS RSALDO NUMBER(15,2); --RETORNA RSALDO 
 BEGIN
   
RSALDO := 0;--ZERO A VARIAVEL
FOR SMOV IN (SELECT * FROM MOVIMENTO) --SELECIONO CADA LINHA
LOOP
	IF SMOV.NR_CONTA = P_NR_CONTA THEN --VERIFICO SE A MOVIMENTACAO FOIA NA CONTA PEDIDA

	IF SMOV.TP_MOV = 'C' THEN --CASO SEJA CREDITO ADICIONO A RSALDO
        RSALDO := RSALDO  + SMOV.VALOR;
	END IF;
    
	IF SMOV.TP_MOV = 'D' THEN
		RSALDO := RSALDO  - SMOV.VALOR; -- CASO SEJA DEBITO REMOVO DE RSALDO
	END IF;
 
	END IF;

 END LOOP;
 DBMS_OUTPUT.PUT_LINE(RSALDO); -- PRINT
END;
/

--INICIALIZA A TABELA SALDO BASEADO NAS MOVIMENTAÇOES
 CREATE OR REPLACE PROCEDURE INICIA_SALDO  AS
BEGIN
   UPDATE SALDO SET VALOR =0; --ZERO O SALDO ATUAL
   FOR SMOV IN (SELECT * FROM MOVIMENTO)--SELECIONO CADA LINHA
   LOOP
		IF SMOV.TP_MOV = 'C' THEN --SE FOR CREDITO AUMENTO O SALDO
           UPDATE SALDO SET VALOR = VALOR + SMOV.VALOR WHERE NR_CONTA = SMOV.NR_CONTA;
		END IF;
      
		IF SMOV.TP_MOV = 'D' THEN -- SE FOR DEBITO DECREMENTO O SALDO
           UPDATE SALDO SET VALOR = VALOR - SMOV.VALOR WHERE NR_CONTA = SMOV.NR_CONTA;
		END IF;
	
	END LOOP;
END;
 /
 
 --TRANSFERE REGISTROS MAIS ANTIGOS QUE 30 DIAS PARA A TABELA MOVIMENTO_HISTORICO
 CREATE OR REPLACE PROCEDURE GRAVA_HISTORICO_MOV AS 
 BEGIN
    FOR RMOV IN (SELECT * FROM MOVIMENTO WHERE (TRUNC(SYSDATE) - DT_MOV) > 30)  					
	LOOP
		INSERT INTO MOVIMENTO_HISTORICO(NR_MOV, DT_REGISTRO, NR_CONTA, DT_MOV,TP_MOV,VALOR) VALUES(RMOV.NR_MOV, SYSDATE, RMOV.NR_CONTA,RMOV.DT_MOV, RMOV.TP_MOV, RMOV.VALOR);
  			
		DELETE FROM MOVIMENTO WHERE NR_MOV = RMOV.NR_MOV;
    END LOOP;
    COMMIT;
END;
/

 --TRIGGERS
 
 --ATUALIZA A TABELA SALDO A CADA INSERÇÃO NA TABELA MOVIMENTO
CREATE OR REPLACE TRIGGER TRC_MOV1 AFTER INSERT ON MOVIMENTO FOR EACH ROW
BEGIN
   IF :NEW.TP_MOV = 'C' THEN
		UPDATE SALDO SET VALOR=VALOR + :NEW.VALOR WHERE NR_CONTA = :NEW.NR_CONTA;
   ELSE   
		UPDATE SALDO SET VALOR=VALOR - :NEW.VALOR WHERE NR_CONTA = :NEW.NR_CONTA;
   END IF;
END;
/

 --ATUALIZA A TABELA SALDO A CADA DELEÇÃO NA TABELA MOVIMENTO
CREATE OR REPLACE TRIGGER TRC_MOV2 AFTER DELETE ON MOVIMENTO FOR EACH ROW
BEGIN
   	IF  :OLD.TP_MOV = 'C' THEN
      	UPDATE SALDO SET VALOR = VALOR - :OLD.VALOR WHERE NR_CONTA = :OLD.NR_CONTA;
   	ELSE 
      	UPDATE SALDO SET VALOR = VALOR + :OLD.VALOR WHERE NR_CONTA = :OLD.NR_CONTA;
   	END IF;
END;
/

--ADICIONA O NR_MOV USANDO A SEQUENCE A CADA INSERÇÃO
CREATE OR REPLACE TRIGGER TRG_NR_MOV BEFORE INSERT ON MOVIMENTO FOR EACH ROW
BEGIN
	SELECT SEQ_NR_MOV.NEXTVAL INTO:NEW.NR_MOV FROM DUAL;
END;
/


--SEQUENCES

CREATE SEQUENCE SEQ_NR_MOV START WITH 100;

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--TESTES

INSERT INTO MOVIMENTO(NR_CONTA, DT_MOV, TP_MOV,VALOR)VALUES(20, SYSDATE, 'C', 30000);

INSERT INTO MOVIMENTO(NR_CONTA, DT_MOV, TP_MOV,VALOR)VALUES (30, TO_DATE('10/07/11','DD/MM/YY'), 'C', 30000);

INSERT INTO MOVIMENTO(NR_CONTA, DT_MOV, TP_MOV,VALOR)VALUES (40, TO_DATE('10/05/11','DD/MM/YY'), 'D', 1000);





 

