@echo off
chcp 1250
if "%cd:~0,3%" == "C:\" (
	echo Logando como Iago Louren�o
	cd C:\app\client\adm\product\12.2.0\client_1\bin 
	sqlplus.exe bdec1924/Plcnu2@fs8
)else ( 	
	echo.
	echo Mova esse .bat para algum diret�rio dentro do computador,
	echo n�o � possivel executa-lo de dentro de uma unidade removivel
	echo.
	echo Pressione qualquer tecla para fechar
	pause>nul
	
)


