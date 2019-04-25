-- cria tabela produtos
CREATE TABLE PRODUTOS(cod_prod varchar2(4),qtde_estocada number,qtde_min number,peso number,tipo_prod varchar2(10));

--cria tabela movimentação
CREATE TABLE MOVIMENTACAO(num_mov varchar2(4),dataM date,cod_produ varchar2(4),tipo_mov char,qtde_mov number);

--cria a primary key do produto
alter table produtos add constraint pk_codprod primary key (cod_prod);

--cria a foreign key do movimentacao 
alter table movimentacao add constraint fk_codprod foreign key(cod_produ) references produtos;

--cria a cosntraint de check para E ou S
alter table movimentacao add constraint ck_tmov check(tipo_mov in ('E','S'));

--cria a sequence startando em 100
create sequence SEQ_NUM_MOV start with 100;

--cria a trigger para gerar os num_mov automaticamente
create or replace trigger gera_num_mov
before insert on movimentacao
for each row 
begin

	select SEQ_NUM_MOV.nextval into :new.NUM_MOV from dual;

end;

--inserçao de dados

insert into produtos values('0001',98,25,50,'cimento'); 
insert into produtos values('0002',190,20,30,'ceramica');
insert into produtos values('0003',170,20,20,'argamassa');
insert into produtos values('0004',2560,500,5,'tijolo');
insert into produtos values('0005',1678,300,9,'bloco');
insert into produtos values('0006',100,25,50,'cal virgem');
insert into produtos values('0007',796,30,8,'vergalhao');
insert into produtos values('0008',506,100,2,'pincel');
insert into produtos values('0009',497,100,3,'rolo');
insert into produtos values('0010',8678,1000,1,'parafuso');

insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('12/01/18','dd/mm/yy'),'0001','S',3); 
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('15/01/18','dd/mm/yy'),'0002','E',1);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('20/02/18','dd/mm/yy'),'0004','E',10);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('28/02/18','dd/mm/yy'),'0006','S',1);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('01/03/18','dd/mm/yy'),'0005','S',65);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('18/04/18','dd/mm/yy'),'0004','E',18);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('19/05/18','dd/mm/yy'),'0001','S',45);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('12/05/18','dd/mm/yy'),'0002','S',12);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('10/06/18','dd/mm/yy'),'0008','S',32);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('13/06/18','dd/mm/yy'),'0009','S',52);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('11/07/18','dd/mm/yy'),'0009','E',96);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('18/08/18','dd/mm/yy'),'0010','E',63);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('25/09/18','dd/mm/yy'),'0002','S',15);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('26/09/18','dd/mm/yy'),'0003','E',34);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('24/10/18','dd/mm/yy'),'0006','S',56);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('23/11/18','dd/mm/yy'),'0007','S',23);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('27/12/18','dd/mm/yy'),'0008','E',54);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('23/12/18','dd/mm/yy'),'0003','E',73);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('28/1/19','dd/mm/yy'),'0002','E',34);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('21/2/19','dd/mm/yy'),'0001','S',74);



-- cria trigger que atualiza qtd em estoque automaticamente
create or replace trigger att_qtd_estoque
after insert on movimentacao
for each row
begin
	
		if :new.tipo_mov = 'E' then
			update produtos set qtde_estocada = qtde_estocada + :new.qtde_mov 
			where cod_prod = :new.cod_produ;
		else 
			update produtos set qtde_estocada = qtde_estocada - :new.qtde_mov
			where cod_prod = :new.cod_produ;
		end if;
	
end; 

--plano de teste para a trigger
--insiro novamente os valores iniciais
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('12/01/18','dd/mm/yy'),'0001','S',3); 
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('15/01/18','dd/mm/yy'),'0002','E',1);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('20/02/18','dd/mm/yy'),'0004','E',10);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('28/02/18','dd/mm/yy'),'0006','S',1);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('01/03/18','dd/mm/yy'),'0005','S',65);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('18/04/18','dd/mm/yy'),'0004','E',18);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('19/05/18','dd/mm/yy'),'0001','S',45);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('12/05/18','dd/mm/yy'),'0002','S',12);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('10/06/18','dd/mm/yy'),'0008','S',32);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('13/06/18','dd/mm/yy'),'0009','S',52);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('11/07/18','dd/mm/yy'),'0009','E',96);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('18/08/18','dd/mm/yy'),'0010','E',63);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('25/09/18','dd/mm/yy'),'0002','S',15);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('26/09/18','dd/mm/yy'),'0003','E',34);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('24/10/18','dd/mm/yy'),'0006','S',56);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('23/11/18','dd/mm/yy'),'0007','S',23);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('27/12/18','dd/mm/yy'),'0008','E',54);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('23/12/18','dd/mm/yy'),'0003','E',73);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('28/1/19','dd/mm/yy'),'0002','E',34);
insert into movimentacao(dataM,cod_produ,tipo_mov,qtde_mov) values(to_date('21/2/19','dd/mm/yy'),'0001','S',74);


--cria procedure de extrato de movimentacoes

create or replace procedure extrato20dias_movimentacao(p_cod_produto varchar2) as
begin
	
	for rMov in(select cod_produ as COD,dataM,tipo_mov,qtde_mov
				from movimentacao where (trunc(sysdate)-dataM) <= 20 and p_cod_produto = cod_produ)
		loop
			dbms_output.put_line(chr(13)||chr(10)||'Codigo '||rMov.COD||chr(13)||chr(10)||'Data '|| rMov.dataM ||chr(13)||chr(10)||'Tipo '
			||rMov.tipo_mov||chr(13)||chr(10)||'Quantidade '||rMov.qtde_mov||chr(13)||chr(10)||chr(13)||chr(10));
		end loop;

end;

--executa a procedure
exec extrato20dias_movimentacao('0001')







