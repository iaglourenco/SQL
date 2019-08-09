
--media salarial por departamento
select cod_depto,departamentos.nome,avg(salario) from funcionarios,departamentos where cod=cod_depto group by cod_depto,departamentos.nome;

-- nome e salario do funcionario que ganha mais que o funcionario '00060'
select nome,salario from funcionarios where salario > (select salario from funcionarios where num = '00060');

-- mesma funcionalidade do anterior usando variaveis
select t.nome,s.nome from funcionarios.t,funcionarios.s where t.num='00060' and s.salario > t.salario;

--num e nome do funcionario que ganha o maior salario
select num,nome from funcionarios where salario = (select max(salario) from funcionarios);

-- num e nome do funcionario que ganha o SEGUNDO maior salario
select num,nome from funcionarios where salario =(select max(salario) from funcionarios where num != (select num from funcionarios where salario = (select max(salario) from funcionarios)));

--codigo do departamento com maior media salarial
select cod_depto from funcionarios group by cod_depto having avg(salario) = (select max(avg(salario)) from funcionarios group by cod_depto);

--solucao alternativa do anterior
select cod_depto from (select cod_depto from funcionarios group by cod_depto order by avg(salario) desc) where rownum=1;
