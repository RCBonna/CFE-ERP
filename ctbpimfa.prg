*-----------------------------------------------------------------------------*
 static aVariav := {0}
 //.................1
*---------------------------------------------------------------------------------------*
#xtranslate nCtaBcoCxa  => aVariav\[  1 \]

*-----------------------------------------------------------------------------*
function CTBPIMFA(DATA,nLinha)	//	Integra do Faturamento
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local   TIPO     :=0
private VM_CTAS  :=array(20,13)
private VM_CTACLI:=array(3)
aeval(VM_CTAS,{|DET|DET:=afill(DET,0)})

if DATA==NIL
	alert('Chamada ao programa incorreto;Atualize Menu;'+ProcName())
	return NIL
end

if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
				'C->CTACTB',;
				'C->CTRNF',;
				'C->GRUPOS',;
				'C->PROD',;
				'C->MOVEST',;
				'C->TABICMS',;
				'C->CLIENTE',;
				'C->PEDSVC',;
				'C->DPCLI',;
				'C->HISCLI',;
				'C->BANCO',;
				'C->ATIVIDAD',;
				'C->VENDEDOR',;
				'C->OBS',;
				'C->PEDDET',;
				'C->PEDPARC',;
				'C->PEDCAB',;
				'C->NATOP'})
	return .F.
end

ARQ	:=ArqTemp(,,'')
pb_msg(ProcName()+'.Processando Integracao Faturamento (SVC)....('+ARQ+')')
dbcreate(ARQ,{ {'WK_CONTA','N',  4,0},;
					{'WK_DATA', 'D',  8,0},;
					{'WK_HIST', 'C', 60,0},;
					{'WK_VALOR','N', 12,2},;
					{'WK_CHAVE','C', 20,0}})
if !net_use(ARQ,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
	dbcloseall()
	FileDelete (ARQ + '.*')
	return .F.
end
Index on str(WK_CONTA,4) tag CODIGO_CTB to (ARQ) eval {||ODOMETRO('CODIGO_CTB')}
ordsetfocus('CODIGO_CTB')

nCtaBcoCxa:=BuscBcoCx()

//select('BANCO')
//dbeval({||TIPO:=BANCO->(RECNO())},{||BANCO->BC_CAIXA})
//BANCO->(DbGoTo(TIPO))

select('PROD')
	ordem CODIGO
select('PEDCAB')
	ordem DTENNF
DbGoTop()
dbseek(dtos(DATA[1]),.T.)
while !eof().and.PEDCAB->PC_DTEMI<=DATA[2]
	@nLinha,40 say 'Notas de Servico:'+pb_zer(PEDCAB->PC_PEDID,6)
	if  PEDCAB->PC_FLAG.and.;	// so notas impressas
		!PEDCAB->PC_FLCAN.and.;	// Não Cancelado
		!PEDCAB->PC_FLCTB.and.;	// Não Contabilizadas
		 PEDCAB->(reclock())		//TRAVAR REGISTRO
		CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
		TIPO:=max(CLIENTE->CL_ATIVID,1)
		SALVABANCO
		select('CTACTB')
		DbGoTop()
		VM_CTACLI:={;
						fn_lecc('S',TIPO,0, 0),;	// 1-CTA Cliente
						fn_lecc('S',TIPO,0, 1),;	// 2-Juros Receb
						fn_lecc('S',TIPO,0, 2);		// 3-Desconto
						}
		RESTAURABANCO
		if PEDCAB->PC_FLSVC //.............................Notas Servico
			CTB_SERVICO(PEDCAB->PC_PEDID)
			replace PEDCAB->PC_FLCTB with .T.
		else
			//	ALERT('TIPO :' + str(TIPO,2))
			//	
			//	aeval(VM_CTAS,{|DET|afill(DET,0)})
			//	dbseek('S'+str(TIPO,2)+str(0,2)+str(10,2),.T.)
			//	dbeval({||VM_CTAS[CC_TPEST,CC_SEQUE-10]:=CC_CONTA},,{||CC_TPMOV='S'.and.CC_TPCFO==TIPO})
			//......................... CTA ESTOQUE, ICMS, IPI
			//	CTB_FATUR(PEDCAB->PC_PEDID)
		end
	end
	dbunlockall()
	dbskip()
end
dbcloseall()
FileDelete (Arq + '.*')
return .T.

*----------------------------------------------------CONTABILIZACAO DE SERVICOS
  function CTB_SERVICO(P1)
*----------------------------------------------------
local TIPO
local VM_ULTNF:=PC_NRNF
local VM_VLRS:=array(21,13)
aeval(VM_VLRS,{|DET|DET:=afill(DET,0)})

SALVABANCO
select('PEDSVC')
dbseek(str(P1,6),.T.)
while !eof().and.PEDSVC->PS_PEDID==P1
	//-------------------------------------------credito
//	alert('SCV:'+str(P1)+';Valor:'+str(PEDSVC->PS_VALOR))
	ATIVIDAD->(dbseek(str(PEDSVC->PS_CODSVC,2)))
//	alert('CC-SCV:'+str(ATIVIDAD->AT_CTAC))
	
	Grava_Work({ATIVIDAD->AT_CTAC,;
					PEDCAB->PC_DTEMI,;
					'Prest.Svc Cfe NF:'+str(VM_ULTNF,6)+' a '+trim(CLIENTE->CL_RAZAO)+' '+trim(ATIVIDAD->AT_DESCR),;
					CRE * PEDSVC->PS_VALOR * PEDSVC->PS_QTDE,;
					'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE+' SVC';
					})
	dbskip()
end
//-------------------------------------------------------------------------debito
if PEDCAB->PC_FATUR==0 //------------------------------------< A VISTA >
	Grava_Work({nCtaBcoCxa,;
					PEDCAB->PC_DTEMI,;
					'Prest.Svc Cfe NF:'+str(VM_ULTNF,6)+' a '+trim(CLIENTE->CL_RAZAO)+' '+trim(ATIVIDAD->AT_DESCR),;
					DEB*(PEDCAB->PC_TOTAL-PEDCAB->PC_DESC),;
					'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE+' SVC';
					})
else	//....................................................< Prazo >
	Grava_Work({VM_CTACLI[1],;//........................... CONTA DE CLIENTE
					PEDCAB->PC_DTEMI,;
					'Prest.Svc Cfe NF:'+str(VM_ULTNF,6)+' a '+trim(CLIENTE->CL_RAZAO)+' '+trim(ATIVIDAD->AT_DESCR),;
					DEB*(PEDCAB->PC_TOTAL-PEDCAB->PC_DESC),;
					'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE+' SVC';
					})
	Grava_Work({VM_CTACLI[3],;//........................... CONTA DESCONTOS
				PEDCAB->PC_DTEMI,;
				'Prest.Svc Cfe NF:'+str(VM_ULTNF,6)+' a '+trim(CLIENTE->CL_RAZAO)+' '+trim(ATIVIDAD->AT_DESCR),;
				DEB*PEDCAB->PC_DESC,;
				'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE+' SVC';
				})
end
//-------------------------------------CONTABILIZAR
select WORK
DbGoTop()
while !eof()
	fn_atdiario(WK_DATA,;
					WK_CONTA,;	//.............Conta Contabil
					WK_VALOR,;
					WK_HIST,;
					WK_CHAVE)
	dbskip()
end
zap
//--------------------------------------------------
RESTAURABANCO
return NIL

*------------------------------------------------------------------FATURAMENTO-----------*
	function CTB_FATUR(P1)
*------------------------------------------------------------------FATURAMENTO-----------*
local TIPO
local VM_ULTNF	:=PC_NRNF
local VM_VLRS	:=array(21,13)
aeval(VM_VLRS,{|DET|DET:=afill(DET,0)})

salvabd(SALVA)
select('PEDDET')
dbseek(str(P1,6),.T.)
while !eof().and.PEDDET->PD_PEDID==P1
	PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
	TIPO:=PROD->PR_CTB
	if PROD->PR_CTB>0.and.PROD->PR_CTB<21	// Estoque COM controle de saldo
		VM_VLRS[TIPO,01]+=PEDDET->PD_VLRMD	// VLR MEDIO
		VM_VLRS[TIPO,02]+=PEDDET->PD_VLICM	// ICMS
		VM_VLRS[TIPO,03]+=PEDDET->PD_VLICM	// ICMS
		VM_VLRS[TIPO,10]+=if(PEDCAB->PC_FATUR>0,0,((PEDDET->PD_VALOR*PEDDET->PD_QTDE-PEDDET->PD_DESCV-PEDDET->PD_ENCFI)))
		VM_VLRS[TIPO,11]+=if(PEDCAB->PC_FATUR=0,0,((PEDDET->PD_VALOR*PEDDET->PD_QTDE-PEDDET->PD_DESCV-PEDDET->PD_ENCFI)))
		VM_VLRS[TIPO,12]+=PEDDET->PD_VLRMD	// VLR MEDIO
//		VM_VLRS[TIPO,21]+=PEDDET->PD_DESCG	// ICMS
	end
	dbskip()
end
salvabd(RESTAURA)
	for X:=1 to 20
		VM_VLRS[21,01]:=VM_VLRS[X,01]
		VM_VLRS[21,02]:=VM_VLRS[X,02]
		VM_VLRS[21,03]:=VM_VLRS[X,03]
		VM_VLRS[21,10]:=VM_VLRS[X,10]
		VM_VLRS[21,11]:=VM_VLRS[X,11]
		VM_VLRS[21,12]:=VM_VLRS[X,12]
		for Y:=X+1 to 20
			for Z:=1 to 13
				if VM_CTAS[ X,Z]==VM_CTAS[Y,Z]
					VM_VLRS[21,Z]+=VM_VLRS[Y,Z]
					VM_VLRS[Y,Z]:=0
				end
			next
		next
		fn_atdiario(PEDCAB->PC_DTEMI,;
						VM_CTAS[X,1],;	// CTA Estoque
						CRE*VM_VLRS[X,1],;
						'NNF '+alltrim(str(VM_ULTNF))+' a '+CLIENTE->CL_RAZAO,;
						'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)

		fn_atdiario(PEDCAB->PC_DTEMI,;
						VM_CTAS[X,2],;	// CTA ICMS RECUP
						CRE*VM_VLRS[X,2],;
						'Recuperado de NNF '+alltrim(str(VM_ULTNF))+' a '+CLIENTE->CL_RAZAO,;
						'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)

		fn_atdiario(PEDCAB->PC_DTEMI,;
						VM_CTAS[X,3],;	// CTA ICMS DESP
						DEB*VM_VLRS[X,3],;
						'NNF '+alltrim(str(VM_ULTNF))+' a '+CLIENTE->CL_RAZAO,;
						'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)

		fn_atdiario(PEDCAB->PC_DTEMI,;
						VM_CTAS[X,10],;	// CTA VENDA A VISTA
						CRE*VM_VLRS[X,10],;
						'NNF '+alltrim(str(VM_ULTNF))+' a '+CLIENTE->CL_RAZAO,;
						'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)

		fn_atdiario(PEDCAB->PC_DTEMI,;
						VM_CTAS[X,11],;	// CTA VENDA A Prazo
						CRE*VM_VLRS[X,11],;
						'NNF '+alltrim(str(VM_ULTNF))+' a '+CLIENTE->CL_RAZAO,;
						'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)

		fn_atdiario(PEDCAB->PC_DTEMI,;
						VM_CTAS[X,12],;	// CTA CUSTO MERC VENDIDA
						DEB*VM_VLRS[X,12],;
						'NNF '+alltrim(str(VM_ULTNF))+' a '+CLIENTE->CL_RAZAO,;
						'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)
	next

	if PEDCAB->PC_FATUR=0 //------------------------------------< A VISTA >
		fn_atdiario(PEDCAB->PC_DTEMI,;
						nCtaBcoCxa,;	// CTA CXA
						DEB*(PEDCAB->PC_TOTAL-PEDCAB->PC_DESC),;
						'Recebido NNF '+alltrim(str(VM_ULTNF))+' de '+CLIENTE->CL_RAZAO,;
						'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)
	else	//.................................................... Prazo
		fn_atdiario(PEDCAB->PC_DTEMI,;
						VM_CTAS[21,1],;	// CTA CLIENTE
						DEB*(PEDCAB->PC_TOTAL-PEDCAB->PC_DESC),;
						'Venda NNF '+alltrim(str(VM_ULTNF))+' de '+CLIENTE->CL_RAZAO,;
						'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)
	end
	fn_atdiario(PEDCAB->PC_DTEMI,;
					VM_CTAS[21,3],;	// CTA Desconto
					DEB*PEDCAB->PC_DESC,;
					'Concedido NNF '+alltrim(str(VM_ULTNF))+' de '+CLIENTE->CL_RAZAO,;
					'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)
return NIL
*------------------------------------------------------------------EOF---------------------------
