//-----------------------------------------------------------------------------*
  static aVariav := {"","","",  0}
//....................1...2..3...4..5..6...7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate CodDocLan => aVariav\[  1 \]
*-----------------------------------------------------------------------------*
function CTBGERLD()	// ATUALIZACAO DE CADASTROS DE LANCAMENTOS DIRETOS
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())
scroll(6,1,21,78)
if !abre({	'R->CTATIT',;
				'C->CTADET',;
				'E->LCTODIR',;
				'C->PARAMCTB',;
				'R->PARAMETRO',;
				'C->RAZAO',;
				'C->CTRLOTE'})
	return NIL
end
select LCTODIR
PACK
REINDEX
LCTODIR->(DbGoTop())
private VM_GRUPO:=LCTODIR->LD_GRUPO
private VM_DATA :=PARAMETRO->PA_DATA
private VM_MES  :=month(VM_DATA)
private VM_HPADRO:=space(60)
private VM_HPADRD:=space(60)
CodDocLanc:=space(20)
@10,01 to 10,78
@06,02 say 'Grupo Contas :'    get VM_GRUPO   pict mUUU valid fn_LctoDir(@VM_GRUPO)
@06,24 say 'Transf.Saldos:'    get VM_MES     pict mI2  valid fn_mes(VM_MES) when pb_msg('Transferir saldos calculados ate o Mes')
@06,50 say 'Data Lancamentos:' get VM_DATA    pict mDT  valid year(VM_DATA)==PARAMCTB->PA_ANO
@07,02 say 'Hist.Pad-Orig:'    get VM_HPADRO  pict mXXX when pb_msg('Comando #CTA1#->conta origem  #CTA2#->conta destino')
@08,02 say 'Hist.Pad-Dest:'    get VM_HPADRD  pict mXXX
@09,02 say 'Nro Doc Lanc.:'    get CodDocLanc pict mXXX when pb_msg('Se houver, informe o numero do documento/descricao de lancamento')

read
if lastkey()#K_ESC
	VM_TIPO:=LCTODIR->LD_TIPO
	cArq:=ArqTemp(,,'')
	if dbatual(cArq,;
				{{'LD_CONTO', 'N',  4, 0},;	// 1-Conta origem
				 {'LD_CONTD', 'N',  4, 0},;	// 2-Conta destino
				 {'LD_VALOR', 'N', 15, 2},;	// 3-Valor
				 {'LD_HISTOO','C', 60, 0},;	// 4-Historico
				 {'LD_HISTOD','C', 60, 0}},;	// 5-Historico
				 RDDSETDEFAULT())
	end
	if !net_use(cArq,.T., ,'LCTOTEMP', ,.F.,RDDSETDEFAULT())
		FileDelete(cArq+'.*')
		dbcloseall()
		return NIL
	end
	select LCTODIR
	ordem CODIGO
	dbseek(VM_GRUPO,.T.)
	if LD_TIPO=='C'
		while !eof().and.LD_GRUPO==VM_GRUPO
			HISTO:=if(empty(VM_HPADRO),LCTODIR->LD_HISTOO,VM_HPADRO)
			HISTD:=if(empty(VM_HPADRD),LCTODIR->LD_HISTOD,VM_HPADRD)
			SALVABANCO
			select CTADET
			if CTADET->(dbseek(str(LCTODIR->LD_CONTD,4)))
				HISTO:=strtran(HISTO,'#CTA2#',pb_zer(LCTODIR->LD_CONTD,4)+'-'+CTADET->CD_DESCR)
				HISTD:=strtran(HISTD,'#CTA2#',pb_zer(LCTODIR->LD_CONTD,4)+'-'+CTADET->CD_DESCR)
			end
			if CTADET->(dbseek(str(LCTODIR->LD_CONTO,4)))
				HISTO:=strtran(HISTO,'#CTA1#',pb_zer(LCTODIR->LD_CONTO,4)+'-'+CTADET->CD_DESCR)
				HISTD:=strtran(HISTD,'#CTA1#',pb_zer(LCTODIR->LD_CONTO,4)+'-'+CTADET->CD_DESCR)
			
				select LCTOTEMP
				AddRec(,{LCTODIR->LD_CONTO,;
							LCTODIR->LD_CONTD,;
							fn_SaldoConta(VM_MES),; //		SALDO BUSCAR
							HISTO,;
							HISTD;
							})
			end
			RESTAURABANCO
			dbskip()
		end
	else // Tipo Lançamento Estrutura
		while !eof().and.LD_GRUPO==VM_GRUPO
			// CTA1 = CONTA ORIGEM
			// CTA2 = CONTA DESTINO
			HISTO:=if(empty(VM_HPADRO),LCTODIR->LD_HISTOO,VM_HPADRO)
			HISTD:=if(empty(VM_HPADRD),LCTODIR->LD_HISTOD,VM_HPADRD)
			SALVABANCO
			select CTADET
			ORDEM CONTAR // ORDEM CONTA CONTÁBIL REDUZIDA - para conta Destino
			go top
			if CTADET->(dbseek(str(LCTODIR->LD_CONTD,4)))
				DCHISTD:=pb_zer(LCTODIR->LD_CONTD,4)+'-'+trim(CTADET->CD_DESCR)+" "
			else
				DCHISTD:='ERRO** Nao achei conta destino:'+pb_zer(LCTODIR->LD_CONTD,4)
			end
			ORDEM CONTAN // ORDEM ESTRUTURA - para conta Origem
			go top
			CTADET->(dbseek(str(LCTODIR->LD_CONTO,1),.T.))

			while !eof().and.left(CTADET->CD_CONTA,1) == str(LCTODIR->LD_CONTO,1)
				pb_msg("Gerando lancamentos temporários - tipo Estrutura:"+pb_zer(CTADET->CD_CTA,4))
				HISTO:=if(empty(VM_HPADRO),LCTODIR->LD_HISTOO,VM_HPADRO) // RESETA HISTÓRICO ORIGEM
				HISTD:=if(empty(VM_HPADRD),LCTODIR->LD_HISTOD,VM_HPADRD)	// RESETA HISTÓRIO DESTINO

				DCHISTO:=pb_zer(CTADET->CD_CTA,4)+'-'+trim(CTADET->CD_DESCR)+" "

				HISTO:=strtran(HISTO,'#CTA1#',DCHISTO)
				HISTO:=strtran(HISTO,'#CTA2#',DCHISTD)
				HISTD:=strtran(HISTD,'#CTA1#',DCHISTO)
				HISTD:=strtran(HISTD,'#CTA2#',DCHISTD)
				
				select LCTOTEMP
				AddRec(,{CTADET->CD_CTA,;
							LCTODIR->LD_CONTD,;
							fn_SaldoConta(VM_MES),; //		SALDO BUSCAR
							HISTO,;
							HISTD;
							})
							
				select CTADET
				dbskip()
			end
			RESTAURABANCO
			dbskip()
		end
	end
	select CTADET
	ORDEM CONTAR
	select LCTOTEMP
	DbGoTop()
	pb_lin4('Movimentos de Lancamento Direto :'+VM_GRUPO,ProcName())
	VM_CAMPO    :={'left(DESC_CTAX(LD_CONTO,1),26)','left(DESC_CTAX(LD_CONTD,2),26)','FN_DBCR(LD_VALOR)',   'LD_HISTOO','LD_HISTOD'}
	VM_MASC     :={                         mXXX,                         mXXX,					mXXX,	         mXXX,      mXXX}
	VM_CABE     :={                 'Cta Origem',                'Cta Destino',            'Valor',   'Historico-Origem','Historico-Destino'}
	pb_dbedit1('CTBGERLD','AlteraGeraLt')
	dbedit(10,01,21,78,VM_CAMPO,"PB_DBEDIT2",VM_MASC,VM_CABE)
	dbcloseall()
	FileDelete(cArq+'.*')
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CTBGERLD1()	// Alterar Valor
*-----------------------------------------------------------------------------*
local VM_VALOR :=abs(LCTOTEMP->LD_VALOR)
local VM_DBCR  :=if( LCTOTEMP->LD_VALOR>0,'D','C')
local VM_HISTOO:=    LCTOTEMP->LD_HISTOO
local VM_HISTOD:=    LCTOTEMP->LD_HISTOD

pb_box(16,20,,,,'Alterar Valor')
@17,22 say 'Conta Origem..: '+DESC_CTAX(LCTOTEMP->LD_CONTO)
@18,22 say 'Conta Destino.: '+DESC_CTAX(LCTOTEMP->LD_CONTD)
@19,22 say 'Valor Lcto....:' get VM_VALOR  pict mD112 valid VM_VALOR>=0
@19,51                       get VM_DBCR   pict mUUU  valid VM_DBCR+'.'$'D.C.' when pb_msg('Informe   D=Debito    C=Credito')
@20,22 say 'Historico-Orig:' get VM_HISTOO pict mXXX  valid !empty(VM_HISTOO)
@21,22 say 'Historico-Dest:' get VM_HISTOD pict mXXX  valid !empty(VM_HISTOD)
read
if lastkey()#K_ESC
	replace 	LCTOTEMP->LD_VALOR  with VM_VALOR * if(VM_DBCR=='D',DEB,CRE),;
				LCTOTEMP->LD_HISTOO with VM_HISTOO,;
				LCTOTEMP->LD_HISTOD with VM_HISTOD
	dbcommit()
end
return NIL

*-----------------------------------------------------------------------------*
function CTBGERLD2()	// Gerar Lote
*-----------------------------------------------------------------------------*
local VM_NRLOTE:=0
local VM_VLRLT :=0
SALVABANCO
select LCTOTEMP
DbGoTop()
while !eof()
	VM_VLRLT+=abs(LCTOTEMP->LD_VALOR)
	dbskip()
end
if pb_sn('Gerar Lote ?')
	select CTRLOTE
	if AddRec()
		VM_NRLOTE:=NovoLote()
		replace  CL_NRLOTE  with VM_NRLOTE,;
					CL_VLRLT   with VM_VLRLT,;
					CL_DEBITO  with VM_VLRLT,;
					CL_CREDITO with VM_VLRLT,;
					CL_FECHAD  with .F.,;
					CL_DATA    with VM_DATA,;
					CL_DIGIT   with 'LCTO DIRETO'
		
		fn_alote(VM_NRLOTE,.T.)
		select LCTOTEMP
		DbGoTop()
		while !eof()
			select('LOTE')
			if AddRec()
				CTADET->(dbseek(str(LCTOTEMP->LD_CONTO,4)))
				replace	LO_CONTA   with CTADET->CD_CONTA
				replace	LO_CTA     with CTADET->CD_CTA
				replace	LO_VALOR   with -LCTOTEMP->LD_VALOR
				replace	LO_HISTOR  with LCTOTEMP->LD_HISTOO
				replace	LO_TPLCTO  with 'E'
				replace  LO_DOCTO   with CodDocLanc
			end	
			if AddRec()
				CTADET->(dbseek(str(LCTOTEMP->LD_CONTD,4)))
				replace	LO_CONTA   with CTADET->CD_CONTA
				replace	LO_CTA     with CTADET->CD_CTA
				replace	LO_VALOR   with LCTOTEMP->LD_VALOR
				replace	LO_HISTOR  with LCTOTEMP->LD_HISTOD
				replace	LO_TPLCTO  with 'E'
				replace  LO_DOCTO   with CodDocLanc
			end
			select LCTOTEMP
			dbskip()
		end
		select('CTRLOTE')
		dbrunlock(recno())
		dbcommitall()
		alert('Lote '+pb_zer(VM_NRLOTE,8)+' gerado com sucesso')
		keyboard chr(27)
	end
end
RESTAURABANCO
return NIL

*-------------------------------------------------------------------* Fim
function DESC_CTAX(P1,P2) // RETORNA DESCRICAO DA CONTA == NAO PODE SER STATIC
*-------------------------------------------------------------------* Fim
local DESCR:=''
CTADET->(dbseek(str(P1,4)))
DESCR:=CTADET->CD_DESCR
return (pb_zer(P1,4)+'-'+DESCR)
//---------------------------------------------------------------------------------------
