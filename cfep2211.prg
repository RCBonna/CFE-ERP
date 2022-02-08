*----------------------------------------------------------------------------*
 static aVariav := {'',0,0,0,.F.,'','',.T.,0, 0,.F.,{}}
 //..................1.2,3,4..5..6..7...8..9 10.11..12
*-----------------------------------------------------------------------------*
#xtranslate cCLIFOR	=> aVariav\[  1 \]
#xtranslate nP5		=> aVariav\[  2 \]
#xtranslate nP6		=> aVariav\[  3 \]
#xtranslate nP7		=> aVariav\[  4 \]
#xtranslate LCLIEN	=> aVariav\[  5 \]
#xtranslate TXTDOCTO	=> aVariav\[  6 \]
#xtranslate nDOCCTB	=> aVariav\[  7 \]
#xtranslate lRT		=> aVariav\[  8 \]
#xtranslate nValor	=> aVariav\[  9 \]
#xtranslate nVJurMin	=> aVariav\[ 10 \]
#xtranslate LCLIEN	=> aVariav\[ 11 \]
#xtranslate aLog		=> aVariav\[ 12 \]

static 	VM_CXACG
static 	VM_DET  :={}
static 	VM_DATA
static 	PGTOS   :={}
static 	VM_DTCALC
static 	ENTRANDO:=0
static 	PREF10
static   MORAJUROS
static   VM_PGT
static   VM_JUR
static   VM_DES

#include 'RCB.CH'
*----------------------------------------------------------------------------*
 function CFEP2211(VM_CODIG,CLIFOR)  // Rotina PGTO=RECEB Dpls 'FOR/CLI'
*----------------------------------------------------------------------------*
local VM_FECHA
local X
local VM_VALOR
local VM_VLR_BCO
local RECIBO:='N'

aLog		:={}
VM_OPC   :=0
VM_DTCALC:=PARAMETRO->PA_DATA
MORAJUROS:=PARAMETRO->PA_PJUROS // Juros de atraso
PREF10   :=.F.
salvabd(SALVA)
LCLIEN   :=(CLIFOR=='CLI') // São Clientes
salvabd(RESTAURA)
VM_DET   :=fn_rtdpls(VM_CODIG)

if len(VM_DET)==0
	pb_msg(if(alias()='DPFOR','Fornecedor','Cliente')+' n„o tem duplicatas pendentes.',5,.T.)
end

while len(VM_DET)>0 // loop
	VM_FECHA:=0
	aeval(VM_DET,{|DET|VM_FECHA+=DET[5]})
	pb_msg('Selecione uma DPL ou press <ESC> para sair',NIL,.F.)
	@10,50 say 'Vlr Lan‡ado :'+transform(VM_FECHA,masc(2)) color 'GR+/B'
	VM_OPC:=fn_msdpl(VM_DET) // 
	if VM_OPC>0
		set key K_F10 to EDITAPGT()	//	F5-Consulta PRODUTOS
		VM_PGT:=VM_DET[VM_OPC,05]
		VM_JUR:=VM_DET[VM_OPC,06]
		VM_DES:=VM_DET[VM_OPC,07]
		VM_RET:=VM_DET[VM_OPC,14]
		VM_BON:=VM_DET[VM_OPC,15]
		salvacor(SALVA)
		pb_box(16,20)
		@17,52 say padc('Duplicata '+transform(VM_DET[VM_OPC,1],mDPLN),26) color ('W*/R')
		@17,22 say 'Data Calc'										get VM_DTCALC         pict mDT     when .F.
		@18,52 say padr('(+)Vlr Dpl',    13,'.')				get VM_DET[VM_OPC,04] pict masc(5) when .F.
		if PARAMETRO->PA_CONTAB==USOMODULO.and.PARAMETRO->PA_CTBBON > 0
			@19,22 say padr('(+/-)Equiv.Produto', 13,'.')	get VM_BON pict masc(5) when pb_msg('Equivalencia em Produto / Ajustes de Valor')
		end
		@19,52 say padr('(+)Juros',    13,'.')					get VM_JUR pict masc(5) valid VM_JUR >= 0 when pb_msg('Valor dos Juros - F10-Mudar parametros de CALCULO').and.(VM_JUR:=CalcJur(VM_DET[VM_OPC,4],VM_DET[VM_OPC,2],MORAJUROS,VM_DTCALC,LCLIEN))>=0.and.(VM_DES:=0)>=0.and.(ENTRANDO:=2)>0
		@20,52 say padr('(-)Descontos',13,'.')					get VM_DES pict masc(5) valid VM_DES >= 0.and.VM_DES+VM_RET<=VM_DET[VM_OPC,4] when pb_msg('Valor de Desconto (Taxa:'+transform(VM_DET[VM_OPC,13],mI62)+'%)  F10->Mudar parametros de calculo').and.VM_JUR=0.00.AND.(ENTRANDO:=4)>0 // .and.(VM_DES:=calcfin(VM_DET[VM_OPC,4],VM_DET[VM_OPC,2],VM_DET[VM_OPC,13],VM_DTCALC))>=0
		if LCLIEN
			@21,52 say padr('(=)Vlr Recebido', 13,'.')
		else
			@21,52 say padr('(=)Vlr Pago',     13,'.')
		end
		@21,66                                      			get 	VM_PGT pict masc(5);
																			valid VM_PGT>=0.and.;
																			STR(VM_PGT,15,2)<=STR(round(VM_DET[VM_OPC,4]+VM_JUR+VM_BON-VM_DES-VM_RET,2),15,2).and.;
																			ValidaJurosMinimos();
																			when pb_msg('Informe o valor Pago/Recebido').and.(VM_PGT:=VM_DET[VM_OPC,4]+VM_JUR+VM_BON-VM_DES-VM_RET)>=0.AND.(ENTRANDO:=5)>0
		read
		set key K_F10 to	//	F5-Consulta PRODUTOS
		if if(lastkey()#K_ESC,pb_sn(),.F.)
			VM_DET[VM_OPC,05]:=VM_PGT
			VM_DET[VM_OPC,06]:=VM_JUR
			VM_DET[VM_OPC,07]:=VM_DES
			VM_DET[VM_OPC,15]:=VM_BON
			//...........................................................................................................
			if str(VM_PGT,15,2)<str(VM_DET[VM_OPC,4]+VM_JUR+VM_BON-VM_DES-VM_RET,15,2).and.str(VM_JUR,15,2)>str(0,15,2)
				
				//	VM_DET[VM_OPC,06]:=CalcJur(VM_PGT-VM_JUR,VM_DET[VM_OPC,2],MORAJUROS,VM_DTCALC) // Novo Valor Juros
				VM_DET[VM_OPC,06]:=CalcFin(VM_PGT,VM_DTCALC,MORAJUROS,VM_DET[VM_OPC,2]) // Recalcular Vlr Juros 
				
				if str(VM_JUR,15,2)#str(VM_DET[VM_OPC,06],15,2)
					alert('Pagamento Parcial;Vlr Juros Alterado de:;'+str(VM_JUR,7,2)+';para:'+str(VM_DET[VM_OPC,06],7,2))
					
				else
					VM_DET[VM_OPC,06]:=VM_JUR
				end
				VM_DET[VM_OPC,07]:=VM_DES
				VM_DET[VM_OPC,15]:=VM_BON
			else
			//	alert('==>'+str(VM_PGT,15,2)+";==>"+str(VM_DET[VM_OPC,4]+VM_JUR+VM_BON-VM_DES-VM_RET,15,2))
			end
		end
		salvacor(RESTAURA)
		keyboard replicate(chr(K_DOWN),VM_OPC++)
		loop
	else//...................forma de pagamento
		*-----------------------------------------------------------------------*
		if LCLIEN
			VM_CXACG:=BuscTipoCx('R') // Codigo Conta de Caixa
		else
			VM_CXACG:=BuscTipoCx('D') // Codigo Conta de Caixa		
		end
		VM_VALOR:=0.00
		aeval(VM_DET,{|DET|VM_VALOR+=DET[5]})
		if VM_VALOR>0.00 // Tem DPL  - Valor para baixar
			PGTOS  := fn_PagBco(VM_VALOR,LCLIEN) // Selecionar Banco para Pagamento
			VM_VLR_BCO := 0.00
			aeval(PGTOS,{|DET|VM_VLR_BCO+=DET[5]}) // Somar baixas no banco/caixa
			VM_DATA:=PARAMETRO->PA_DATA
			if VM_VLR_BCO > 0.00
				keyboard chr(13)
				@07,02 say 'Data........:'  get VM_DATA  pict mDT  valid ValidaDataRec( VM_DATA,PARAMETRO->PA_DATA) color 'GR+/B'
				@08,02 say 'Impr. Recibo? ' get RECIBO   pict mUUU valid RECIBO$'SN' 																													when if(LCLIEN,PARAMETRO->PA_RECICR$'S123',PARAMETRO->PA_RECICP$'S123').and.pb_msg('Imprimir recibo para este pagamento?')
				@09,02 say 'Codigo Caixa:'  get VM_CXACG pict mI2  valid fn_codigo(@VM_CXACG,{'CAIXACG',{||CAIXACG->(dbseek(str(VM_CXACG,3)))},{||CXAPCDGRT(.T.)},{2,1}})	when USACAIXA.and.pb_msg('Codigo de lancamento no Caixa')
				read
			end
			if if(VM_VLR_BCO > 0.00 .and. lastkey()#K_ESC,pb_sn(),.F.)
				ATUALDPL(VM_DET,VM_DATA)
				dbcommitall()
				if USACAIXA
					if LCLIEN
						for X:=1 to len(PGTOS)
							Grav_Bco(PGTOS[X,2],VM_DATA,PGTOS[X,4],'REC '+CLIENTE->CL_RAZAO,+PGTOS[X,5],'CR')
						next
					else
						for X:=1 to len(PGTOS)
							Grav_Bco(PGTOS[X,2],VM_DATA,PGTOS[X,4],'PAGO '+CLIENTE->CL_RAZAO,-PGTOS[X,5],'CP')
						next
					end
				end
				if PARAMETRO->PA_RECICR$'S123'.or.PARAMETRO->PA_RECICP$'S123'
					if LCLIEN
//						LISTADPL:={' Duplicata Dt Vencto    Valor Dupl  Juros   Ajust   Desc  Tot Receb'}
						LISTADPL:={' Duplicata DtVencto  Valor Dupl  Juros   Desc  Vlr Receb'}
					else
						LISTADPL:={' Duplicata DtVencto  Valor Dupl  Juros   Desc   Vlr Pago'}
					end
					VM_PGT:=0
					SET CENTURY			OFF // Data com 2 digitos par Ano
					for X:=1 to len(VM_DET)
						if VM_DET[X,5]>0 // DPL COM VLR PAGO.
							if LCLIEN
								aadd(LISTADPL, transform(VM_DET[X,01],mDPL)+' '+;	// Duplicata
													dtoc(VM_DET[X,2])+;						// Data Venc
													transform(VM_DET[X,04],mD82)+;		// Vlr Dupl
													transform(VM_DET[X,06],mD42 )+;		// Vlr Juros
													transform(VM_DET[X,07],mD42 )+;		// Vlr Desconto
													transform(VM_DET[X,05],mD72))			// Vlr Pago
//													transform(VM_DET[X,15],mD52 )+;		// Vlr Ajuste
							else
								aadd(LISTADPL, transform(VM_DET[X,01],mDPL)+' '+;	// Duplicata
													dtoc(VM_DET[X,2])+;						// Data Venc
													transform(VM_DET[X,04],mD82)+;		// Vlr Dupl
													transform(VM_DET[X,06],mD42 )+;		// Vlr Juros
													transform(VM_DET[X,07],mD42 )+;		// Vlr Desconto
													transform(VM_DET[X,05],mD72))			// Vlr Pago
//													transform(VM_DET[X,15],mD52 )+;		// Vlr Desconto
							end
							VM_PGT+=VM_DET[X,5]
						end
					next
					SET CENTURY			ON // Data com 2 digitos par Ano
				end
				dbcommitall()
				if LCLIEN //.............................Cliente
					if RECIBO=='S'
						RECIBO('C',CLIENTE->CL_RAZAO+'('+pb_zer(VM_CODIG,5)+')',LISTADPL,VM_DATA,VM_PGT)
					end
				else //..................................Fornecedor 
					if RECIBO=='S'
						RECIBO('F',CLIENTE->CL_RAZAO+'('+pb_zer(VM_CODIG,5)+')',LISTADPL,VM_DATA,VM_PGT)
					end
					for X:=1 to len(PGTOS)
						if PGTOS[X,2]>0.and.PGTOS[X,6]=='S'.and.PGTOS[X,7] // imprimir cheques
							BANCO->(dbseek(str(PGTOS[X,2],2)))
							if BANCO->BC_IMPCHE
								CHEQUE(PGTOS[X,2],PGTOS[X,5],CLIENTE->CL_RAZAO,VM_DATA)
								if BANCO->(reclock())
									replace BANCO->BC_ULTCHE with PGTOS[X,4]
									dbrunlock(recno())
								end
							end
						end
					next
				end
			elseif len(PGTOS)>0
				Alert('Saindo sem atualizar.')
			end
		end
		exit
	end
end
return NIL

*--------------------------------------------------------------------------*
	function FN_RTDPLS(pCli)
*--------------------------------------------------------------------------*
local VM_DET:={}
dbseek(str(pCli,5),.T.) // PROCURA 1.DPL
dbeval({||if(reclock(),;
				aadd(VM_DET,{	&(fieldname(01)),;//...................1-Nr Dpl
									&(fieldname(04)),;//...................2-Data Venc
									&(fieldname(11)),;//...................3-serie
									&(fieldname(06))-&(fieldname(7)),;//...4-Vlr atual Liq R$,
									0,;//..................................5-Vlr pago
									0,;//..................................6-Juros
									0,;//..................................7-Desc
									&(fieldname(06)),;//...................8-Vlr Original
									recno(),;//............................9-Registro
									&(fieldname(10)),;//..................10-Nr NF
									&(fieldname(11)),;//..................11-Serie
									&(fieldname(03)),;//..................12-Data Emis
									&(fieldname(15)),;//..................13-Juros finaceiros
									0,;//.................................14-RETENCAO
									0;//..................................15-EQUIV PRODUTO
									}),;
					pb_msg('Duplicata '+transform(&(fieldname(1)),masc(16))+' em uso.',0,.T.))},,{||&(fieldname(2))==pCli})
//if len(VM_DET)=0
//	pb_msg(if(alias()='DPFOR','Fornecedor','Cliente')+' n„o tem duplicatas pendentes.',2,.T.)
//end
return(VM_DET)

*-----------------------------------------------------------------------------*
 static function ATUALDPL(VM_DET,VM_DATA)
*-----------------------------------------------------------------------------*
local VM_TOT  :={0,0,0,0,0}
local VM_DTEMI:=0
local VM_VLRDP:=0
local X

TXTDOCTO:=''
nDOCCTB :=dtos(date())+'-'+SONUMEROS(time())

pb_msg('Atualizando base de dados...',NIL,.F.)

aeval(VM_DET,{|VM_DET1|VM_TOT[1]+=VM_DET1[05]}) // Valor pago efetivo
aeval(VM_DET,{|VM_DET1|VM_TOT[2]+=VM_DET1[06]}) // Valor juros
aeval(VM_DET,{|VM_DET1|VM_TOT[3]+=VM_DET1[07]}) // Valor descontos
aeval(VM_DET,{|VM_DET1|VM_TOT[4]+=VM_DET1[14]}) // Valor retencao
aeval(VM_DET,{|VM_DET1|VM_TOT[5]+=VM_DET1[15]}) // Valor bonificacao
for X:=1 to len(VM_DET)
	if VM_DET[X,5]>0 // DPL COM VLR PAGO/RECEBIDO
		DbGoTo(VM_DET[X,09]) // Registro a Atualizar
		VM_DTEMI:=&(fieldname(3))
		VM_VLRDP:=VM_DET[X,05]+VM_DET[X,07]+VM_DET[X,14]-VM_DET[X,6]-VM_DET[X,15]  // em R$
		replace	&(fieldname(5)) with VM_DATA
		replace 	&(fieldname(7)) with &(fieldname(7))+VM_VLRDP,;
					&(fieldname(15)) with VM_DET[X,13]

		if Trunca(VM_DET[X,8],2)==Trunca(&(fieldname(7)),2)
			fn_elimi()
		end
		*---------------------------------------------------- ATUALIZA HISTORICOS
		salvabd(SALVA)
		if alias()='DPFOR'
			select ('HISFOR')
		else
			select('HISCLI')
		end
		while !AddRec();end
		replace 	&(fieldname( 1)) with VM_CODIG,;				// Coid DPL
					&(fieldname( 2)) with VM_DET[X,01],;		// DT DPLS
					&(fieldname( 3)) with VM_DTEMI,;
					&(fieldname( 4)) with VM_DET[X,02],;		// DT VENC
					&(fieldname( 5)) with VM_DATA,;
					&(fieldname( 6)) with VM_DET[X,04],;		// VLR DPLS
					&(fieldname( 7)) with VM_DET[X,05]+VM_DET[X,7]+VM_DET[X,14]-VM_DET[X,6]-VM_DET[X,15],;// valor pago
					&(fieldname( 8)) with VM_DET[X,06],;		// JUROS
					&(fieldname( 9)) with VM_DET[X,07],;		// DESCONTOS
					&(fieldname(11)) with VM_DET[X,10],;		// Nr NF
					&(fieldname(12)) with VM_DET[X,11],;		// Serie NF
					&(fieldname(13)) with VM_CXACG,;
					&(fieldname(15)) with .T.,;					// Já lancado
					&(fieldname(16)) with VM_DET[X,14],;		// RETENCAO
					&(fieldname(17)) with VM_DET[X,15],;		// EQUIV PRODUTO
					&(fieldname(18)) with NUM_CXA					// Codigo Caixa

		replace  &(fieldname(10)) with pb_divzero(&(fieldname(7)),PARAMETRO->PA_VALOR) // Dólar
		salvabd(RESTAURA)
		TXTDOCTO+=ltrim(transform(VM_DET[X,1],masc(16)))+'/'
		FN_ATCTB(X,VM_TOT)
	end
next

if PARAMETRO->PA_CONTAB==USOMODULO.and.VM_IND<21
	TXTDOCTO:='Ref Dpl.'+TXTDOCTO
	if alias()=='DPFOR'
		for X:=1 to len(PGTOS)
			BANCO->(dbseek(str(PGTOS[X,2],2)))
			fn_atdiario(VM_DATA,;
							BANCO->BC_CONTA,;//---------------------------------CAIXA/BCO
							CRE*PGTOS[X,5],;
							if(PGTOS[X,4]>0,'Ch/Doct '+ltrim(str(PGTOS[X,4]))+' ','')+TXTDOCTO+' de '+CLIENTE->CL_RAZAO,;
							'PAG:'+nDOCCTB)
		next
	else
		for X:=1 to len(PGTOS)
			BANCO->(dbseek(str(PGTOS[X,2],2)))
			fn_atdiario(VM_DATA,;
							BANCO->BC_CONTA,;//--------------------------------CAIXA/BCO
							DEB*PGTOS[X,5],;
							'Rec.'+TXTDOCTO+' de '+CLIENTE->CL_RAZAO,;
							'REC:'+nDOCCTB)
		next
	end
end

//............Gerar Log
EXCESSAO_Grava(aLog)

return NIL

*--------------------------------------------------------------------------*
 static function FN_ATCTB(VM_X,VM_TOT)
*--------------------------------------------------------------------------*
if PARAMETRO->PA_CONTAB==USOMODULO.and.VM_IND<21
	if alias()=='DPFOR'//...........................DUPLICATAS A PAGAR
		if 		VM_DET[VM_X,11]=='SOB'//.......................................Contabilização pagamento TIPO SOB (Sobras)
			fn_atdiario(VM_DATA,;
							VM_CTAS[1,6],;//-----------------------------------CONTA PARAMENTO DISTRIB SOBRAS
							DEB*(VM_DET[VM_X,5]-VM_DET[VM_X,6]+VM_DET[VM_X,7]+VM_DET[VM_X,14]-VM_DET[VM_X,15]),;
							'Pgto Distr.Sobras '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'PAG:'+nDOCCTB)

		elseif 	VM_DET[VM_X,11]=='QUO' //..................................Contabilização pagamento TIPO QUO (saída de sócios)
			fn_atdiario(VM_DATA,;
							VM_CTAS[1,7],;//-----------------------------------CONTA PAGAMENTO SAIDA SOCIO
							DEB*(VM_DET[VM_X,5]-VM_DET[VM_X,6]+VM_DET[VM_X,7]+VM_DET[VM_X,14]-VM_DET[VM_X,15]),;
							'Pgto Parc.Quota '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'PAG:'+nDOCCTB)

		else
			fn_atdiario(VM_DATA,;
							VM_CTAS[VM_IND,1],;//-----------------------------------CONTA
							DEB*(VM_DET[VM_X,5]-VM_DET[VM_X,6]+VM_DET[VM_X,7]+VM_DET[VM_X,14]-VM_DET[VM_X,15]),;
							'Pgto dpl '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'PAG:'+nDOCCTB)

			fn_atdiario(VM_DATA,;
							VM_CTAS[VM_IND,2],;//-----------------------------------JUROS
							DEB*VM_DET[VM_X,6],;
							'Cfe dpl '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'PAG:'+nDOCCTB)

			fn_atdiario(VM_DATA,;
							VM_CTAS[VM_IND,3],;//-------------------------------DESCONTOS
							CRE*VM_DET[VM_X,7],;
							'Cfe dpl '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'PAG:'+nDOCCTB)
							
			fn_atdiario(VM_DATA,;
							PARAMETRO->PA_CTBRET,; //----------------------------RETENCAO
							CRE*VM_DET[VM_X,14],;
							'Ret.Tipif.Carcaca ref dupl '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'PAG:'+nDOCCTB)

			if VM_DET[VM_X,15] > 0
				fn_atdiario(VM_DATA,;
								PARAMETRO->PA_CTBBON,; //-------------------------EQUIV PRODUTO
								DEB*VM_DET[VM_X,15],;
								'Ajuste a preco de mercado ref.'+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
								'PAG:'+nDOCCTB)
			else
				fn_atdiario(VM_DATA,;
								PARAMETRO->PA_CTBRET,; //-------------------------EQUIV PRODUTO
								CRE*abs(VM_DET[VM_X,15]),;
								'Ajuste a preco de mercado ref.'+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
								'PAG:'+nDOCCTB)
			end
		end
	else//..........................................RECEBIMENTOS
		if VM_DET[VM_X,11]=='INT'//.......................................Contabilização RECEBIMENTO PAGAMENTO SOCIO (INTEGRALIZAR CAPITAL)
			fn_atdiario(VM_DATA,;
							VM_CTAS[1,6],;//-----------------------------------CONTA PARAMENTO DISTRIB SOBRAS
							CRE*(VM_DET[VM_X,5]-VM_DET[VM_X,6]+VM_DET[VM_X,7]+VM_DET[VM_X,14]-VM_DET[VM_X,15]),;
							'Rec. Socio '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'REC:'+nDOCCTB)
		else
			fn_atdiario(VM_DATA,;
							VM_CTAS[VM_IND,1],;//----------------------------------CONTA
							CRE*(VM_DET[VM_X,5]-VM_DET[VM_X,6]+VM_DET[VM_X,7]-VM_DET[VM_X,15]),;
							'S/Liquid dpl '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'REC:'+nDOCCTB)

			fn_atdiario(VM_DATA,;
							VM_CTAS[VM_IND,2],;//----------------------------------JUROS
							CRE*VM_DET[VM_X,6],;
							'Cfe dpl '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'REC:'+nDOCCTB)

			fn_atdiario(VM_DATA,;
							VM_CTAS[VM_IND,3],;//-------------------------------DESCONTOS
							DEB*VM_DET[VM_X,7],;
							'Cfe dpl '+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
							'REC:'+nDOCCTB)

			if VM_DET[VM_X,15] > 0
				fn_atdiario(VM_DATA,;
								PARAMETRO->PA_CTBRET,; //-------------------------EQUIV PRODUTO
								CRE*VM_DET[VM_X,15],;
								'Ajuste a preco de mercado ref.'+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
								'REC:'+nDOCCTB)
			else
				fn_atdiario(VM_DATA,;
								PARAMETRO->PA_CTBBON,; //-------------------------EQUIV PRODUTO
								DEB*abs(VM_DET[VM_X,15]),;
								'Ajuste a preco de mercado ref.'+ltrim(transform(VM_DET[VM_X,1],masc(16)))+' de '+CLIENTE->CL_RAZAO,;
								'REC:'+nDOCCTB)
			end
		end
	end
end
return NIL

*----------------------------------------------------------------------------
 static function FN_PAGBCO(P1,P2)
*----------------------------------------------------------------------------
local DADOPC:=	{	{1,0,'',0,0,'S',.F.},;
						{2,0,'',0,0,'S',.F.},;
						{3,0,'',0,0,'S',.F.},;
						{4,0,'',0,0,'S',.F.},;
						{5,0,'',0,0,'S',.F.},;
						{6,0,'',0,0,'S',.F.},;
						{7,0,'',0,0,'S',.F.},;
						{8,0,'',0,0,'S',.F.} }
					//seq,b,bc,d,v,rec,che
					//..1.2..3.4.5..6...7
local X
local BCO
local DOC
local VLR
local REC
local CHE
local TOTAL
salvacor(.T.)
setcolor('W+/W,W+/R')
keyboard chr(K_ENTER)
while .T.
	TOTAL:=0
	aeval(DADOPC,{|DET|TOTAL+=DET[5]})
	pb_msg('Selecione uma linha para fazer pagamento',NIL,.F.)
	//-------------------------------1-----2-----------3-------4-------5-----------------6
	X:=ABrowse(11,00,22,79,DADOPC,{'Sq','Bco','Descricao','Docto','Valor','Imprime Cheque?'},;
											{  2 ,   3 ,         35,     6 ,    12 ,              14 },;
											{ mI2,  mI3,       mXXX,   mI6 ,  mD112,            mXXX },,;
											'Forma de Pagamento/Recebimentos')
	if X>0
		BCO:=DADOPC[X,2]
		DOC:=DADOPC[X,4]
		VLR:=P1-TOTAL+DADOPC[X,5]
		VLR:=if(VLR<0,0,VLR)
		CHE:=DADOPC[X,6]
		@row(),04 get BCO pict mI3   valid fn_codigo(@BCO,{'BANCO',{||BANCO->(dbseek(str(BCO,2)))},{||CFEP1500T(.T.)},{2,1}})
		@row(),44 get DOC pict mI6   valid DOC>=0                                   when pb_msg('Nr Documento').and.(DOC:=BANCO->BC_ULTCHE+1)>=0 
		@row(),51 get VLR pict mI122 valid VLR>=0.and.str(VLR,15,2)<=str(P1,15,2)   when pb_msg('Valor a ser baixado total ('+str(P1,15,3)+') Vlr Dig.('+str(VLR,15,3))
		@row(),64 get CHE pict mUUU  valid CHE$'SN'                                 when !P2.and.BANCO->BC_IMPCHE
		read
		if lastkey()#K_ESC
			DADOPC[X,2]:=BCO
			DADOPC[X,3]:=BANCO->BC_DESCR
			DADOPC[X,4]:=DOC
			DADOPC[X,5]:=VLR
			DADOPC[X,6]:=CHE
			DADOPC[X,7]:=BANCO->BC_IMPCHE
			keyboard replicate(chr(K_DOWN),X)+chr(K_ENTER)
		end
	else
		TOTAL:=0
		aeval(DADOPC,{|DET|TOTAL+=DET[5]})
		if str(TOTAL,15,2)#str(P1,15,2)
			if pb_sn('Valores n„o fechados. Abandonar ?')
				DADOPC:={}
				exit
			end
		else
			exit
		end
	end
end
salvacor(.F.)
return DADOPC

*----------------------------------------------------------------
 static function EDITAPGT()
*----------------------------------------------------------------
local GetList:={}
local VALOR  := 0
local XJUROS :=VM_DET[VM_OPC,13]
if ! PREF10
	PREF10:=.T.
	if ENTRANDO==2 //JUROS
		@17,22 say 'Data Fim:' get VM_DTCALC pict mDT  when pb_msg('Informe data final para calculo dos juros') color 'GR/W'
		@17,43                 get MORAJUROS pict mI62 when pb_msg('Informe o % de juros por atraso')           color 'GR/W'
		READ
		if str(MORAJUROS,15,2)==str(0,15,2)
			MORAJUROS:=0.000000001 // só para não cobrar juros 
		end
		VALOR:=CalcJur(VM_DET[VM_OPC,4],VM_DET[VM_OPC,2],MORAJUROS,VM_DTCALC,LCLIEN)
		GETACTIVE():VARPUT(VALOR) // coloca o valor na tela no campo juros
	elseif ENTRANDO==4 //....................Desconto
		@17,22 say 'Data Fim:' get VM_DTCALC pict mDT  color 'GR/W' when pb_msg('Informe data final para calculo do Desconto')
		@17,43                 get XJUROS    pict mI62 color 'GR/W'
		READ
		if str(XJUROS,15,2)==str(0,15,2)
			XJUROS:=0.000000001 // só para dar desconto
		end
		VALOR:=calcfin(VM_DET[VM_OPC,4],VM_DET[VM_OPC,2],XJUROS,VM_DTCALC)
		VM_DET[VM_OPC,13]:=XJUROS
		GETACTIVE():VARPUT(VALOR)
	end
	PREF10:=.F.
end
set cursor on
return NIL

*----------------------------------------------------------------
 function CALCFIN(P1,P2,P3,P4)
*----------------------------------------------------------------
//.........................P4 = data atual
//.....................P3 = % Juros original
//..................P2 = Dt Vencimento
//...............P1 = Total dpl com juros
default P4 to  PARAMETRO->PA_DATA
P3:=if(P3>0,P3,PARAMETRO->PA_PJUROS)
nP5:=0.000000001
nP6:=max(P2-P4,0)				// Nr de Dias de Antecipacao
nP5:=((1+P3/100)^(1/30))	// Taxa por dia
nP5:=(nP5^nP6)					//	% a ser descontado 
nP7:=P1/nP5						// Valor sem juros financeiros
// Alert('Tot Pago=>'+str(P1)+';Vlr Sem Juros=>'+str(nP7)+';% Desc==>'+str(nP5))
return(trunca(P1-nP7,2))	// Juros

*----------------------------------------------------------------------------
 function CalcJur(P1,pDtVenc,pPJuros,pDtJur,pCliente)
*----------------------------------------------------------------------------
//.........................P4 = DT ATUAL
//......................P3 = JUROS
//...................P2 = DT VENCIMENTO
//................P1 = VLR DPL A SER PAGA
default pDtJur to  PARAMETRO->PA_DATA
pPJuros:=if(pPJuros>0,pPJuros,PARAMETRO->PA_PJUROS)
nP5:=0.000000001
nP5:=(1+pPJuros/100)
nP5:=nP5^(1/30) // Taxa por dia de atraso
nP6:=max(pDtJur-pDtVenc,0) // NR DE DIAS DE ATRASO
nP5:=nP5^nP6
nP5:=nP5-1
if pCliente // É Cliente
	if nP6<=PARAMETRO->PA_CARENCR
		nP5:=0 // sem % de Juros por causa da carência
	end
end
return(trunca(P1*nP5,2))

*----------------------------------------------------------------------------
 static function ValidaJurosMinimos()
*----------------------------------------------------------------------------
lRt:=.T.
//Calcular Vlr Jur Minimo
nVJurMin:=CalcJur(VM_PGT-VM_JUR,VM_DET[VM_OPC,2],PARAMETRO->PA_PJUROSM+.000001,VM_DTCALC,LCLIEN)
if VM_JUR<nVJurMin
	lRT:=.F.
	if Alert('Calculo de Juros.:'+Str(VM_JUR,7,2)+';Menor que Minimo:'+Str(nVJurMin,7,2),{'Voltar','Liberar'})==2
		if xxsenha(ProcName(),'Liberacao pagar Juros Abaixo Minimo')
			Alert('Cliente Liberado dos Juros Abaixo do Minimo')
			if str(VM_JUR,10,2)==str(0,10,2)
				aadd(aLog,{Date(),Time(),'Juros Zerado','Cliente '+trim(Left(CLIENTE->CL_RAZAO,30))+ ' Vlr Juros Min:'+Str(nVJurMin,7,2),RT_NOMEUSU()})
			end
			lRT:=.T. // Liberado
		else
		end
	end
else
	// Alert('Calculo de Juros:'+Str(VM_JUR,7,2)+' MAIOR que Vlr Min:'+Str(nVJurMin,7,2))
end
return(lRt)

*----------------------------------------------------------------------------
 static function ValidaDataRec(pDTEntrada,pDTParametro)
*----------------------------------------------------------------------------
lRT:=.F.
if pDTEntrada==pDTParametro
	lRT:=.T.
elseif pDTEntrada<=pDTParametro
	if xxsenha(ProcName(),'Data de Baixa/Receb das Duplicatas')
		lRT:=.T.
	else
		lRT:=.F.
	end
end
return lRT
*------------------------------------------------EOF----------------------------
