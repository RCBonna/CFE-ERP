//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.,'',1,30910, 0,{},0, 0,'', 0,'',{},{}, 0}
//....................1.2..3...4.5.....6..7..8..9.10,11,12.13.14.15.16
//-----------------------------------------------------------------------------*
// Fazer impressão da quantidade base para calculo do valor.

#xtranslate cArq		=> aVariav\[  1 \]
#xtranslate nX			=> aVariav\[  2 \]
#xtranslate LCONT		=> aVariav\[  3 \]
#xtranslate dLctos	=> aVariav\[  4 \]
#xtranslate nDia		=> aVariav\[  5 \]
#xtranslate CODPR		=> aVariav\[  6 \]
#xtranslate nQtTot	=> aVariav\[  7 \]
#xtranslate aQtTot	=> aVariav\[  8 \]
#xtranslate nVlr		=> aVariav\[  9 \]
#xtranslate nPAG		=> aVariav\[ 10 \]
#xtranslate cRel		=> aVariav\[ 11 \]
#xtranslate nLar		=> aVariav\[ 12 \]
#xtranslate nPer		=> aVariav\[ 13 \]
#xtranslate aProd		=> aVariav\[ 14 \]
#xtranslate aQtDia	=> aVariav\[ 15 \]
#xtranslate nQCli		=> aVariav\[ 16 \]

#include 'RCB.CH'

//-----------------------------------------------------------------------------*
  function LeiteP20()	//	Relatório de valor x calculos
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO'		,;
				'R->CLIENTE'		,;		//	'R->LEICCSOM',;'R->LEITEMP',;
				'R->LEIGORD'		,;		// Gordura
				'R->PROD'			,;
				'R->LEIPARAM'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEITRANS'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIMOTIV'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIVEIC'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIROTA'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIDADOS'		,;		// Criado arquivo no LEITEP00.PRG
				'R->MOVEST'})
	return NIL
end

select LEIPARAM
DbGoTop()

dLctos	:={Bom(PARAMETRO->PA_DATA),Eom(PARAMETRO->PA_DATA)}
nPer  	:=left(dtos(PARAMETRO->PA_DATA),6)
nProIni	:=1
nProFim	:=99999
nX     	:=16
pb_box(nX++,30,,,,'Selecao-Relatorio')
 nX++
@nX++,32 say 'Periodo.....:'		get nPer pict mPER
@nX++,32 say 'Produtor Inic.:' 	get nProIni   pict mI5	valid fn_codigo(@nProIni,{'CLIENTE',{||CLIENTE->(dbseek(str(nProIni,5)))},NIL,{2,1}})
@nX++,32 say 'Produtor Final:' 	get nProFim   pict mI5	valid nProFim==99999.or.fn_codigo(@nProFim,{'CLIENTE',{||CLIENTE->(dbseek(str(nProFim,5)))},NIL,{2,1}})
read
if if(LastKey()#K_ESC,pb_sn(),.F.)	
	dLctos[1]:=CtoD('01/'+right(nPer,2)+'/'+left(nPer,4)) // Data Inicial Mes
	dLctos[2]:=eom(dLctos[1])		// Data Fim do mes
	dLctos[1]-- 						// Inicio do mes MENOS 1 DIA
	dLctos[2]--							// Fim do mes MENOS 1 DIA
	aProd    :={nProIni,nProFim}	// Produtor Inicial / Final
	if CriaTmpLeite() 				// Criar tabela interna de Leite
		AcumularLeiteN()				// Acumular Quantidades de leite por Produtor/Produto
	end
	aQtDia	:=Array(32)
	aQtTot	:=Array(32)
	cRel		:='Relatorio Acompanhamento - '+dtoc(dLctos[1])+' a '+dtoc(dLctos[2])
	nLar		:=160
	nPAG		:=  0
	AFill(aQtTot,0) // Total da Linha Final
	select WORK
	DbGoTop()
	pb_msg('Imprimindo...')
	if pb_ligaimp(I20CPP)
		nPAG := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPAG,'LEITEP20C',nLar)
		while !eof()
			AFill(aQtDia,0)
			nQtTot:=0
			nQCli	:=WORK->WK_CDCLI
			while !eof().and.WORK->WK_CDCLI==nQCli
				@24,68 say str(nQCli,10)
				nDia:=if(WORK->WK_DIA==0,32,WORK->WK_DIA) // se for dia Zero (32)
				aQtDia[nDia]	+=WORK->WK_QTDE
				nQtTot			+=WORK->WK_QTDE // Total do Produtor
				pb_brake()
			end
			nPAG := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPAG,'LEITEP20C',nLar)
			//--------------------------------IMPRESSÃO DADOS DO CLIENTE---------------
			CLIENTE->(dbseek(str(nQCli,5)))
			? pb_zer(nQCli,5)
			??'-'+left(CLIENTE->CL_RAZAO,20)
			??str(aQtDia[32],4) 				// Dia Mes Anterior
			aQtTot[32]+=aQtDia[32]			// Acumula Dia Mes Anterior - Linha Final
			for nX:=1 to day(dLctos[2])	// Até ultimo dia menos 1
				??str(aQtDia[nX],4)
				aQtTot[nX]	+=aQtDia[nX]
			next
			??space(2)+str(nQtTot,7)
			//---------------------------------------------------------------------------
		end
		?replicate('-',nLar)
		nQtTot:=aQtTot[32] // Total do Gera do Ultimo Dia

		?padr('Totais Dias Impares',28,'.')
		for nX:=1 to day(dLctos[2]) step 2	// pular um dia para evitar estouro de valor
			??str(	aQtTot[nX],6)+space(2)
			nQtTot+=	aQtTot[nX] // Total do Gera dos Dias
		next

		? padr('Totais Dias Pares',24,'.')
		??str(aQtTot[32],6)+space(2)
		for nX:=2 to day(dLctos[2]) step 2	// pular um dia para evitar estouro de valor
			??str(	aQtTot[nX],6)+space(2)
			nQtTot+=	aQtTot[nX] // Total do Gera dos Dias
		next
		if (day(dLctos[2])%2)>0 // último dia é par - espaço
			??space(4)
		end
		??str(nQtTot,7)
		?replicate('-',nLar)
		?time()
		pb_deslimp(C20CPP,.T.)
	end
end
dbcloseall()
if len(cArq)>0 // Precisa ter conteúdo para deletar os arquivos temporários
	fileDelete (cArq + '.*')
end
return NIL

*-----------------------------------------------------------------------------*
 function LEITEP20C()
*-----------------------------------------------------------------------------*
?  padr('Produtor',27)+'Ant|'
for nX:=1 to day(dLctos[2])
	??padl(pb_zer(nX,2),3,'.')+'|'
next
??'   Total'
?replicate('-',nLar)
return NIL

*-----------------------------------------------------------------------------*
*------------------------NOVO SISTEMA DE LEITE--------------------------------*
*-----------------------------------------------------------------------------*
 static function AcumularLeiteN() // Novo arquivo de dados de LEITE     *
*-----------------------------------------------------------------------------*
pb_msg('Acumulando Qtd.Leite')
select LEIDADOS
ORDEM DTCLI // Data + Cliente
DbGoTop()
dbseek(dtos(dLctos[1]),.T.)
while !eof().and.LEIDADOS->LD_DTCOLET<=(dLctos[2]) // validar período
	@24,68 say dtoc(LEIDADOS->LD_DTCOLET)
	if LEIDADOS->LD_CDCLI>=aProd[1]	.and.; 	// Produtor Inicial
		LEIDADOS->LD_CDCLI<=aProd[2]				// Produtor Final
		nDia:=Day(LEIDADOS->LD_DTCOLET)			// Dia (validar mes anterior)
		if nPer#left(DtoS(LEIDADOS->LD_DTCOLET),6)
			nDia:=0 // MUDAR->Ultimo dia do Mes Anterior
		end
		select WORK
		if !WORK->(dbseek(str(LEIDADOS->LD_CDCLI,5)+str(nDia,2)))
			AddRec(,{	LEIDADOS->LD_CDCLI,;
							nDia,;
							LEIDADOS->LD_VOLTANT;
						})
		else
			replace 	WORK->WK_QTDE with WORK->WK_QTDE + abs(LEIDADOS->LD_VOLTANT)
		end
		select LEIDADOS
	end
	dbskip()
end
return NIL

*-----------------------------------------------------------------------------*
 static function CriaTmpLeite()
*-----------------------------------------------------------------------------*
LCont:=.T.
cArq :=ArqTemp(,,'')
SALVABANCO
dbcreate(cArq,{{'WK_CDCLI',	'N',  5,0},;	//-01-Cod Cliente / Produtor
					{'WK_DIA',		'N',  2,0},;	//-02-Dia
					{'WK_QTDE',		'N',  6,0};		//-05-Quantidade Dia
					})
if !net_use(cArq,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
	LCont:=.F.
	pb_msg('Erro na criacao da tabela temporaria de leite')
else
	Index on str(WK_CDCLI,5)+str(WK_DIA,2)				tag CODIGO_CLI to (cArq)
	OrdSetFocus('CODIGO_CLI')
end
RESTAURABANCO
return LCont

//-------------------------------------------EOF--------------------------------------
