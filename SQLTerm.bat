@echo off
chcp 1250
if "%cd:~0,3%" == "C:\" (
	echo Logando como Iago Lourenço
	cd C:\app\client\adm\product\12.2.0\client_1\bin 
	sqlplus.exe bdec1924/Plcnu2@fs8
)else ( 	
	echo.
	echo Mova esse .bat para algum diretório dentro do computador,
	echo não é possivel executa-lo de dentro de uma unidade removivel
	echo.
	echo Pressione qualquer tecla para fechar
	pause>nul
	
)


