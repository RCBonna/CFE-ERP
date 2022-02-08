*-----------------------------------------------------------------------------*
* Inicializacao dos sistema CFE														      *
*-----------------------------------------------------------------------------*
static _aInit := {{},"", {}}
 //.............. 1..2...3
*-----------------------------------------------------------------------------*
#xtranslate P1     => _aInit\[  1 \]
#xtranslate P2     => _aInit\[  2 \]
#xtranslate P3     => _aInit\[  3 \]

#include 'RCB.CH'

INIT PROCEDURE CFEINIT()
pb_msg('Inicializacao...',NIL,.F.)
*-------------------------------------------------------VERIFICACOES NO SISTEMA

*if numfiles()<DOSFILES
*	alert('Modifique arquivo CONFIG.SYS colocando FILES='+trim(str(DOSFILES,3))+'. E reiniceia o Computador.;No Windows ME/2000 e diferente')
*	quit
*end

// if diskfree()<KB_LIVRE+KB_LIVRE
	// alert('Espa‡o em disco insuficiente para processar programa adequadamente.')
	// if diskfree()<KB_LIVRE
		// alert('Disco com capacidade inferior a '+alltrim(str(KB_LIVRE))+';SISTEMA NAO PODE SER EXECUTADO.','W*/R')
		// quit
	// end
// end

*------------------[TIPO]----------------------------------------------------
P2:='ESTOQUE.ARR'
if !file(P2)
	P1:= {{01,'Materia Prima      ',1},;
			{02,'Material Secundario',1},;
			{03,'Material de Consumo',1},;
			{04,'Produtos p/ Revenda',1},;
			{05,'                   ',1},;
			{06,'                   ',1},;
			{07,'                   ',1},;
			{08,'                   ',1},;
			{09,'                   ',1},;
			{10,'                   ',1},;
			{11,'                   ',1},;
			{12,'                   ',1},;
			{13,'                   ',1},;
			{14,'                   ',1},;
			{15,'                   ',1},;
			{16,'                   ',1},;
			{17,'                   ',1},;
			{18,'                   ',1},;
			{19,'                   ',1},;
			{20,'Outros Tipos       ',1},;
			{21,'                   ',1},;
			{22,'                   ',1},;
			{23,'                   ',1},;
			{24,'                   ',1},;
			{25,'                   ',1},;
			{26,'                   ',1},;
			{27,'                   ',1},;
			{28,'                   ',1},;
			{29,'                   ',1},;
			{30,'                   ',1},;
			{31,'                   ',1},;
			{32,'                   ',1},;
			{33,'                   ',1},;
			{34,'                   ',1},;
			{35,'                   ',1},;
			{36,'                   ',1},;
			{37,'                   ',1},;
			{38,'                   ',1},;
			{39,'                   ',1},;
			{40,'                   ',1},;
			{99,'Sem Controle Estoqu',1} }
	savearray(P1,P2)
end

*---------------------------------TIPOS DE CLIENTES
P2:='TIPOCLI.ARR'
P1:= {;
		{ 1 ,'Consumidor      '},;
		{ 2 ,'Comercio        '},;
		{ 3 ,'Industria       '},;
		{ 4 ,'Atacado         '},;
		{ 5 ,'                '},;
		{ 6 ,'                '},;
		{ 7 ,'                '},;
		{ 8 ,'                '},;
		{ 9 ,'Outros          '};
		}

if !file(P2)
	savearray(P1,P2)
end

*---------------------------------TIPOS DE FORNECEDORES
P2:='TIPOFOR.ARR'
P1:={;
		{ 1 ,'Fabricante      '},;
		{ 2 ,'Atacadista      '},;
		{ 3 ,'Varejista       '},;
		{ 4 ,'Ambulante       '},;
		{ 5 ,'                '},;
		{ 6 ,'                '},;
		{ 7 ,'                '},;
		{ 8 ,'                '},;
		{ 9 ,'Outros          '};
		}

if !file(P2)
	savearray(P1,P2)
end

*---------------------------------TIPOS DE DOCUMENTOS
P2:='TP_DOCTO.ARR'
P1:={;
		{ 'NF ','Nota Fiscal           '},;
		{ 'NFF','Nota Fiscal Fatura    '},;
		{ 'CEE','Conta Energia Eletrica'},;
		{ 'CT ','Conhecimento de Frete '},;
		{ 'NFS','Nota Fiscal Servico   '},;
		{ 'FS ','Fatura Servico        '};
		}

if !file(P2)
	savearray(P1,P2)
end

*---------------------------------COD VLR FISCAIS
P2:='CODVLRFI.ARR'
P1:={;
		{ 1,'Operacoes com credito de impostos     '},;
		{ 2,'Oper. sem cred impostos-isent/nao trib'},;
		{ 3,'Oper. sem cred impostos-Outros        '},;
		{ 4,'Oper. especial com Credito de Icms    '};
		}

if !file(P2)
	savearray(P1,P2)
else
	P3:=restarray(P2)
	if len(P3)#len(P1)
		savearray(P1,P2)
	end
end

*--------------------------------Tipo de Registro
P2:='TIPOREGI.ARR'
P3:=restarray(P2)
P1:={;
		{ 'E','Entradas  '},;
		{ 'S','Saidas    '},;
		{ 'O','Outros    '};
		}
if len(P3)#len(P1)
	savearray(P1,P2)
end
return NIL
