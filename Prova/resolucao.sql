--RESOLUÇÃO PROVA TEORICA DE SQLCODE

--IAGO LOURENÇO 15610116

--1
--CONSTRUIR UMA FUNÇÃO PARA RETORNAR O RA COM A N-ÉSIMA MELHOR NOTA DE UMA DISCIPLINA MINISTRADA NUM DETERMINADO SEMESTRE
--("COD_DISC","SEMESTRE" E "N" SERÃO PASSADOS COMO PARÂMETROS DESTA FUNÇÃO).

CREATE OR REPLACE FUNCTION NESIMA(P_COD IN NUMBER,SEM IN VARCHAR2,N IN NUMBER) RETURN NUMBER IS
NUM NUMBER;
BEGIN
NUM:=N;
	FOR I IN (SELECT * FROM CURSARAM WHERE COD_DISC=P_COD AND SEMESTRE=SEM ORDER BY NOTA DESC)
	LOOP
	
	
		IF NUM=0 THEN
			RETURN I.RA;
		ELSE
			NUM:=NUM-1;
		END IF;
	
	END LOOP;
	
RETURN 0;
END;
/


--2
--SERIA POSSÍVEL, ATRAVÉS DESTA MESMA FUNÇÃO ACIMA, RETORNAR A NOTA, ALÉM DO RA? EXPLIQUE
--
-- SIM, BASTARIA ALTERAR A COLUNA QUE RETORNO DENTRO DO FOR,EX. "RETURN I.NOTA".



--3
--CONSTRUIR UMA PROCEDURE, PARA QUE, DADO UM DETERMINADO SEMESTRE, SEJAM LISTADOS, PARA CADA DISCIPLINA MINISTRADA 
--NAQUELE SEMESTRE, A PERFORMANCE DE TODOS OS ALUNOS COM AS RESPECTIVAS NOTAS, FREQUÊNCIA E STATUS NESTAS DISCIPLINAS. 
--PARA CADA DISCIPLINA LISTADA, CALCULAR E MOSTRAR TAMBÉM, A MÉDIA GERAL DOS ALUNOS NESTA DISCIPLINA.
CREATE OR REPLACE PROCEDURE RESUMO(SEM VARCHAR2) AS 
BEGIN

FOR I IN (SELECT * FROM CURSARAM WHERE SEMESTRE=SEM)
LOOP
	FOR J IN (SELECT * FROM CURSARAM WHERE COD_DISC=I.COD_DISC)
	LOOP
	
	
		DBMS_OUTPUT.PUT_LINE('RA: '+J.RA);
		DBMS_OUTPUT.PUT_LINE('NOME: '+(SELECT NOME FROM ALUNOS WHERE RA=J.RA));
		DBMS_OUTPUT.PUT_LINE('FREQUENCIA: '+J.FREQ);
		DBMS_OUTPUT.PUT_LINE('STATUS: '+J.STATUS);
		
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('MEDIA: '+(SELECT MEDIA(NOTA) FROM CURSARAM WHERE COD_DISC=I.COD_DISC));



END LOOP;



END;


--4
--CONSTRUA UMA TRIGGER PARA QUE TODA VEZ QUE UMA NOVA LINHA FOR INSERIDA NA TABELA CURSARAM COM OS DADOS(RA,COD_DISC,SEMESTRE,NPTA,FREQ),
--O VALOR DO CAMPO STATUS SEJA CALCULADO E INSERIDO AUTOMATICAMENTE. AS REGRAS DE APROVAÇÃO ESTÃO NA TABELA REGRAS,
--CUJO ESQUEMA SE ENCONTRA ABAIXO(ESTA TABELA NÃO ESTÁ NO ESQUEMA ORIGINAL, MAS DEVE SER CONSIDERADA PARA ESTRA QUESTÃO).
--		REGRAS(NOTA,FREQ,STATUS)
CREATE OR REPLACE ATT_STATUS BEFORE INSERT ON CURSARAM FOR EACH ROW
BEGIN


	IF :NEW.NOTA >= (SELECT NOTA FROM REGRAS) AND :NEW.FREQ >= (SELECT FREQ FROM REGRAS) THEN
		:NEW.STATUS='A';
	ELSE
		:NEW.STATUS='R';
		
	END IF;

END;