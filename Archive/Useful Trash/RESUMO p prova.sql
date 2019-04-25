CREATE TABLE NOMETABELA(CAMPO1 VARCHAR2(X),CAMPO2 NUMBER); --CRIAR TABELA

ALTER TABLE NOMETABELA ADD CONSTRAINT nome_constraint PRIMARY KEY(CAMPON); --CRIA PK

ALTER TABLE NOMETABELA ADD CONSTRAINT nome_constraint FOREIGN KEY(CAMPON) REFERENCES NOMETABELA2; --CRIA FK	

ALTER TABLE NOMETABELA ADD CONSTRAINT nome_constraint CHECK(CAMPON IN ('A','B')); --CONSTRAINT CHECK SE UMA CONDIÇÃO E VDD

create sequence SEQ_NUM_MOV start with 100; --SEQ STARTA COM 100

create or replace trigger gera_num_mov
before insert on movimentacao --A CADA INSERÇÃO
for each row 	
begin

	select SEQ_NUM_MOV.nextval into :new.NUM_MOV from dual;	--SETO NUM_MOV COM O NEXTVAL DA SEQ

end;

insert into produtos values('0001',98,25,50,'cimento');  -- INSERT 

--INSERT INDICANDO QUAIS CAMPOS
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('12/01/18','dd/mm/yy'),'0001','S',3); 


create or replace trigger att_qtd_estoque
after insert on movimentacao
for each row
begin
	
		if :new.tipo_mov = 'E' then --SE TIPO MOV FOR 'E'
			update produtos set qtde_estocada = qtde_estocada + :new.qtde_mov  --:NEW VALOR NOVO
			where cod_prod = :new.cod_produ;									--:OLD VALOR ANTIGO
		else 																	--SO TENHO ACESSO A ESSES VALORES DA TABLE PRODUTOS
			update produtos set qtde_estocada = qtde_estocada - :new.qtde_mov
			where cod_prod = :new.cod_produ;
		end if;
	
end;

create or replace procedure extrato20dias_movimentacao(p_cod_produto varchar2) as
begin
	
	for rMov in(select cod_produ as COD,dataM,tipo_mov,qtde_mov
				from movimentacao where (trunc(sysdate)-dataM) <= 20 and p_cod_produto = cod_produ) --USO O TRUNC PARA FORMATAR AS DATAS
		loop
			dbms_output.put_line(chr(13)||chr(10)||'Codigo '||rMov.COD||chr(13)||chr(10)||'Data '|| rMov.dataM ||chr(13)||chr(10)||'Tipo '
			||rMov.tipo_mov||chr(13)||chr(10)||'Quantidade '||rMov.qtde_mov||chr(13)||chr(10)||chr(13)||chr(10));
		end loop; --CHR(13) E CHR(10) = CR LF

end;

--executa a procedure
exec extrato20dias_movimentacao('0001')

--FUNCTIONS
create or replace function calcula_sal_total(depto_in varchar2)
return number is
sal_tot number;
begin
select sum(salario) into sal_tot from funcionarios where c_depto = depto_in;
return (sal_tot);
end;

--CHAMA FUNCTIONS
select calcula_sal_total(‘0001’) from dual;


create or replace function exclui_instrutores
return varchar2
is
begin
   delete instrutores
       where cod not in (select distinct cod_instrutor from turma);
  if  SQL%found then
 return ('Foram eliminados: '|| to_char(SQL%rowcount) || ' Instrutores');
                 else
 return ('Nenhum instrutor eliminado');
  end if;
end;


--ATIVANDO FUNCAO EXCLUI INSTRUTORES
declare saida varchar2(40);
begin
saida := exclui_instrutores;
dbms_output.put_line ('Saida: ' || saida);
end;



create or replace procedure grava_historico_movimento as
      	begin
    	for rMov in (select * from Movimento 
                         where (trunc(sysdate) - dt_mov) > 30)  					
				loop
      		         insert into Movimento_historico 
		             (nr_Movimento, dt_registro, nr_conta, dt_mov,                    
                                           tp_movimento,valor)
        		                   values
     			 (rMov.nr_Movimento, sysdate, rMov.nr_conta,                  
                                             rMov.dt_mov, rMov.tp_movimento, rMov.valor);
  			
		          delete from MOVIMENTO where nr_Movimento = rMov.nr_Movimento;
        		end loop;
    	commit;
 end;



  