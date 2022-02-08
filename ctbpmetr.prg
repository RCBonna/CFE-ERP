//-----------------------------------------------------------------------------*
  static aVariav := {'',0,0,0,0,0,0,0,0, 0, 0, 0}
//....................1.2,3,4,5,6.7.8.9.10.11.12
//-----------------------------------------------------------------------------*
#xtranslate nTipo      => aVariav\[  1 \]
#xtranslate X          => aVariav\[  2 \]
#xtranslate nVlrMed    => aVariav\[  3 \]
#xtranslate aVLRS      => aVariav\[  4 \]
#xtranslate TipoGr     => aVariav\[  5 \]
#xtranslate CtaTraCli  => aVariav\[  6 \]
#xtranslate wConta     => aVariav\[  7 \]
#xtranslate wData      => aVariav\[  8 \]
#xtranslate wValor     => aVariav\[  9 \]
#xtranslate wHist      => aVariav\[ 10 \]
#xtranslate wChave     => aVariav\[ 11 \]
#xtranslate nLinha     => aVariav\[ 12 \]

#include 'RCB.CH'
*--------------------------------------------------------------------------------------*
 function CtbPMeTr(DATA,pNrLinha)	//	Integra Saidas por Transferencias (Estoque e NF)
*--------------------------------------------------------------------------------------*
local TpCli   :=1 // Associado
local ARQ     :=ArqTemp(,,'')
local VConta  :=0
local FRETE   :={}
local VHist   :=''

private VM_CTAS
nLinha:=pNrLinha
if DATA==NIL
	alert('Chamada ao programa incorreto;Atualize Menu;'+ProcName())
	return NIL
end

beepaler()
if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
          	'C->PROD',;
         	'C->CTACTB',;
				'C->PEDCAB',;//....para transferencias
				'C->PEDDET',;//....para transferencias
				'C->NATOP',;
				'C->CLIENTE',;
				'C->MOVEST'})
	return .F.
end

pb_msg(ProcName()+'.Processando Integracao Transferencia Estoque....('+ARQ+')')
dbcreate(ARQ,{ {'WK_CONTA','N',  4,0},;
					{'WK_DATA', 'D',  8,0},;
					{'WK_HIST', 'C', 60,0},;
					{'WK_VALOR','N', 12,2},;
					{'WK_CHAVE','C', 20,0}})
if !net_use(ARQ,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
	dbcloseall()
	return .F.
end
Index on str(WK_CONTA,4)+dtos(WK_DATA)+upper(WK_HIST) tag CODIGO_CTB to (ARQ)
OrdSetFocus('CODIGO_CTB')
	select('PROD')
	ordem CODIGO

	VM_CTAS :=array(40,13)
	aeval(VM_CTAS,{|DET|afill(DET,0)})
	select('CTACTB')
	DbGoTop()
	// Tando para Transferencia como para Entrada deve pegar contas contabeis de Saida
	// neste caso de estoque é contabilizado para Cliente Tipo=1
	dbseek('S'+str(TpCli,2)+str(0,2)+str(10,2),.T.)
	dbeval({||VM_CTAS[CC_TPEST,CC_SEQUE-10]:=CC_CONTA},,{||CC_TPMOV=='S'.and.CC_TPCFO==TpCli})
	//.......................................CTA ESTOQUE, ICMS, IPI

	select PROD
	ORDEM CODIGO

	select MOVEST
	ORDEM DTPROT

	dbseek(dtos(DATA[1]),.T.)
	while !eof().and.MOVEST->ME_DATA<=DATA[2]
		@nLinha,35 say 'Transf Estoque: '+dtoc(MOVEST->ME_DATA)
		if !MOVEST->ME_FLCTB.and.MOVEST->ME_DESDB>0.and.MOVEST->(reclock()) 			// Não contabilizado ?
			if MOVEST->ME_FORMA=='D'
				VHist:='Despesas em '+dtoc(DATA[2])+' cfe listagem'
			else
				VHist:='Custo Producao em '+dtoc(DATA[2])+' cfe listagem'
			end
			Grava_Work({MOVEST->ME_DESDB,;
							DATA[2],;
							VHist,;
							DEB * Abs(MOVEST->ME_VLEST)+Abs(MOVEST->ME_VICMS),;
							'TR:'+Alltrim(str(MOVEST->ME_DCTO,11));
							})
			Grava_Work({MOVEST->ME_ICMDB,;
							DATA[2],;
							'Estorno de credito em '+dtoc(DATA[2])+' cfe listagem',;
							CRE * Abs(MOVEST->ME_VICMS),;
							'TR:'+Alltrim(str(MOVEST->ME_DCTO,11));
							})

			PROD->(dbseek(str(MOVEST->ME_CODPR,L_P)))
			TpEst     :=max(PROD->PR_CTB,1)
			if PROD->PR_CTB>0.and.PROD->PR_CTB<41					// Estoq COM controle Saldo
				//..............................contabilizar ESTOQUE
				Grava_Work({VM_CTAS[TpEst,1],;
							DATA[2],;
							'Baixa Estoque em '+dtoc(DATA[2])+' cfe listagem para '+if(MOVEST->ME_FORMA=='P','Producao','Consumo'),;
							CRE * Abs(MOVEST->ME_VLEST),;
							'TR:'+Alltrim(str(MOVEST->ME_DCTO,11));
							})
			end
			replace MOVEST->ME_FLCTB with .T. 
		end
		dbunlockall()
		dbskip()
	end
	*---------------------------------------------------------------------------------------------
	IntCtbSaiTr(DATA,pNrLinha)//..........................Acumula Transferencias (CFEAPC=Saidas)
	*---------------------------------------------------------------------------------------------
dbcloseall()
FileDelete (Arq + '.*')
return .T.

*-----------------------------------------------------------------------------*
 static function IntCtbSaiTr(Data,pNrLinha)
*-----------------------------------------------------------------------------*
select PEDCAB
ORDEM DTEPED
dbseek(dtos(DATA[1]),.T.)
while !eof().and.dtos(PEDCAB->PC_DTEMI)<=dtos(DATA[2])
		@nLinha,35 say 'Transf Saidas : '+dtoc(PEDCAB->PC_DTEMI)
		//	alert(dtos(PC_DTEMI)+";"+;
		//			STR(PC_PEDID)+;
		//			";---> "+if(!PC_FLCTB.and.!PC_FLCAN.and.PC_FLAG,"SIM","nao")+;
		//			";CTB> "+if(!PC_FLCTB,"SIM","nao")+;
		//			";CAN> "+if(!PC_FLCAN,"SIM","nao")+;
		//			";IMP> "+if( PC_FLAG, "SIM","nao") )

	if !PEDCAB->PC_FLCTB.and.;	// Não contabilizado
		!PEDCAB->PC_FLCAN.and.;	// Não Cancelado
		PEDCAB->PC_FLAG			// Foi Impresso
		NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
//		ALERT('Pedido:'+STR(PC_PEDID)+';'+NATOP->NO_FLTRAN+';'+NATOP->NO_FLCTB+';'+str(PEDCAB->PC_CODOP,7))
		if NATOP->NO_FLTRAN=='S'.and.NATOP->NO_FLCTB=='S' // Transferencia & Contabilizar
			PEDCAB->(reclock())//TRAVAR REGISTRO
			CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
			nTipo    :=max(CLIENTE->CL_ATIVID,1)
//			CtaTraCli:=CLIENTE->CL_CCTRA1
			if PEDCAB->PC_TPTRAN==1
				IntCtbTra(1,nTipo)	//......................Detalhes transferencia tipo 1-Custo
			elseif PEDCAB->PC_TPTRAN==2
				IntCtbTra(2,nTipo)	//......................Detalhes transferencia tipo 2-Magem
			end
			replace PEDCAB->PC_FLCTB with .T.
		end
	end
	skip
end
wContabilizar()
return NIL

*-----------------------------------------------------------------------------*
 static function IntCtbTra(pTipoT,pTipoF)
*-----------------------------------------------------------------------------*
aVLRS  :=array(40,13)
aCtaCTB:=array(40,13)
aeval(aVLRS,  {|DET|DET:=afill(DET,0)})
aeval(aCtaCTB,{|DET|DET:=afill(DET,0)})
SALVABANCO
//....................................................Buscar contas contábeis
select('CTACTB')
DbGoTop()
// Tanto para Transferencia como para Entrada deve pegar contas contabeis de Saida
dbseek('T'+str(pTipoF,2)+str(0,2)+str(10,2),.T.) // 1a conta com tipo F
dbeval(	{||aCtaCTB[CC_TPEST,CC_SEQUE-10]:=CC_CONTA},,;
			{||CC_TPMOV=='T'.and.CC_TPCFO==pTipoF})
		//................................................ CTA ESTOQUE, ICMS, IPI
		aadd(aCtaCTB,{;
							fn_lecc('T',pTipoF,0, 0),;	// 1-CTA Cliente
							fn_lecc('T',pTipoF,0, 1),;	// 2-Juros Receb
							fn_lecc('T',pTipoF,0, 2),;	// 3-Desconto
							fn_lecc('T',pTipoF,0, 4);		// 4-Cta Adto Cliente
							})

if NATOP->NO_FLCTB=='S'.and.NATOP->NO_FINANC=='N'.and.NATOP->NO_CTBDB>0
	aCtaCTB[41,1]:=NATOP->NO_CTBDB // usa CC da CFOP caso seja contabil = S e Financ = N
end

select('PEDDET')
dbseek(str(PEDCAB->PC_PEDID,6),.T.)
while !eof().and.PEDDET->PD_PEDID==PEDCAB->PC_PEDID
	PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
	TipoGr:=max(PROD->PR_CTB,1)

	aVLRS[TipoGr][01]+=PEDDET->PD_VLRMD	//...............................VLR MEDIO (Credito)
	if pTipoT==1 //......................................................Custo
		aVLRS[TipoGr][12]+=PEDDET->PD_VLRMD	//............................VLR MEDIO (Debito)
	elseif pTipoT==2 //..................................................Venda
		aVLRS[TipoGr][02]+=(Round(PEDDET->PD_VALOR*PEDDET->PD_QTDE,2)-;//.Margem # Venda-Médio
								  PEDDET->PD_VLRMD)
		aVLRS[TipoGr][03]+=PEDDET->PD_VLICM	// ICMS
		aVLRS[TipoGr][04]+=PEDDET->PD_VLICM	// ICMS
		aVLRS[TipoGr][12]+=round(PEDDET->PD_VALOR*PEDDET->PD_QTDE,2)//....VLR Venda (Debito)
	end
	if PEDDET->PD_DESTRAN>0	//............................................Transferencias tipo conta destino (DEBITO/CREDITO)
		aCtaCTB[TipoGr,12]:=PEDDET->PD_DESTRAN
		aCtaCTB[TipoGr,01]:=PEDDET->PD_DESTRAC
	end
//	alert("NF:"+AllTrim(str(PEDCAB->PC_NRNF))+'/'+PEDCAB->PC_SERIE+;
//			";Valor:"+str(PEDDET->PD_VALOR*PEDDET->PD_QTDE)+;	// Margem # Venda-Médio
//			";Valor:"+str(PEDDET->PD_VLRMD*PEDDET->PD_QTDE)+;
//			";Tipo :"+str(TipoGr,2)+;
//			";CC[2]:"+str(aCTACTB[1][02],4)+;
//			";CC[2]:"+str(aCTACTB[2][02],4))
	skip
end

//if PEDCAB->PC_LOTE>0
//	aeval(aCtaCTB,{|DET|DET[12]:=CtaTraCli}) // Trocar conta contábil para saidas pela conta do cliente
//end

for X:=1 to len(aVLRS)
	Grava_Work({aCTACTB[X][01],;// Conta Contábil
					PEDCAB->PC_DTEMI,;
					'Transf.NF '+AllTrim(str(PEDCAB->PC_NRNF,6))+' Serie:'+AllTrim(PEDCAB->PC_SERIE)+' '+CLIENTE->CL_RAZAO,;
					CRE * Abs(aVLRS[X][01]),;
					'SAIT:'+AllTrim(str(PEDCAB->PC_NRNF))+'/'+PEDCAB->PC_SERIE;
					})
	Grava_Work({aCTACTB[X][02],;// Conta Contábil Margem
					PEDCAB->PC_DTEMI,;
					'Transf.NF '+AllTrim(str(PEDCAB->PC_NRNF,6))+' Serie:'+AllTrim(PEDCAB->PC_SERIE)+' '+CLIENTE->CL_RAZAO,;
					CRE * (aVLRS[X][02]),; // deve trocar D/C se for negativo a margem
					'SAIT:'+AllTrim(str(PEDCAB->PC_NRNF,6))+'/'+PEDCAB->PC_SERIE;
					})
	Grava_Work({aCTACTB[X][03],;// Conta Contábil ICMS
					PEDCAB->PC_DTEMI,;
					'Ref.Transf.NF '+AllTrim(str(PEDCAB->PC_NRNF,6))+' Serie:'+AllTrim(PEDCAB->PC_SERIE)+' '+CLIENTE->CL_RAZAO,;
					DEB * Abs(aVLRS[X][03]),;
					'SAIT:'+AllTrim(str(PEDCAB->PC_NRNF,6))+'/'+PEDCAB->PC_SERIE;
					})
	Grava_Work({aCTACTB[X][04],;// Conta Contábil Margem
					PEDCAB->PC_DTEMI,;
					'Ref.Transf.NF '+AllTrim(str(PEDCAB->PC_NRNF,6))+' Serie:'+AllTrim(PEDCAB->PC_SERIE)+' '+CLIENTE->CL_RAZAO,;
					CRE * Abs(aVLRS[X][04]),;
					'SAIT:'+AllTrim(str(PEDCAB->PC_NRNF,6))+'/'+PEDCAB->PC_SERIE;
					})
	Grava_Work({aCTACTB[X][12],;// Conta Contábil Debito Estoque
					PEDCAB->PC_DTEMI,;
					'Transf.NF '+AllTrim(str(PEDCAB->PC_NRNF,6))+' Serie:'+AllTrim(PEDCAB->PC_SERIE)+' '+CLIENTE->CL_RAZAO,;
					DEB * Abs(aVLRS[X][12]),;
					'SAIT:'+AllTrim(str(PEDCAB->PC_NRNF,6))+'/'+PEDCAB->PC_SERIE;
					})
next
RESTAURABANCO
return nil
//----------------------------------------------------------EOF----------------------
