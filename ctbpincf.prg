*-----------------------------------------------------------------------------*
 static aVariav := {'S',0, '', 0, '',0,{}}
 //..................1..2...3..4...5.6..7
*-----------------------------------------------------------------------------*
#xtranslate nTpCTB   => aVariav\[  1 \]
#xtranslate aPis     => aVariav\[  2 \]
#xtranslate aCofins  => aVariav\[  3 \]
#xtranslate nX       => aVariav\[  4 \]
#xtranslate lFlag    => aVariav\[  5 \]
#xtranslate FRETE    => aVariav\[  6 \]
#xtranslate aContas  => aVariav\[  7 \]

static VM_CTAS :={}
*-----------------------------------------------------------------------------> Integra Conhecimentos de Frete
*-----------------------------------------------------------------------------*
function CtbPInCF(DATA,nLinha)	//	Integra do Conhecimento de Frete
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local TpFor   :=0
local ARQ     :=ArqTemp(,,'')
local VConta  :=0
local VHist   :=''
local TIPO    :=0
      FRETE   :={}

if DATA==NIL
	alert('Chamada ao programa incorreto;Atualize Menu;'+ProcName())
	return NIL
end
pb_msg(ProcName()+'.Processando Integracao das Conhecimento de Fretes....('+ARQ+')')
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
Index on str(WK_CONTA,4)+dtos(WK_DATA)+WK_HIST tag CODIGO_CTB to (ARQ) eval {||ODOMETRO('CODIGO_CTB')}
ordsetfocus('CODIGO_CTB')
beepaler()
if !abre({	'C->PARAMETRO',;
				'C->TABICMS',;
				'R->CODTR',;
				'C->DIARIO',;
				'C->ENTCAB',;
				'C->ENTDET',;
				'C->HISFOR',;
				'C->CTRNF',;
				'C->OBS',;
				'C->CLIENTE',;
				'C->CAIXACG',;
          	'C->PROD',;
          	'R->FISACOF',;
          	'C->PROFOR',;
          	'C->DPFOR',;
				'C->BANCO',;
				'C->GRUPOS',;
				'R->CTACTB',;
				'C->MOVEST',;
				'C->ALIQUOTAS',;
				'C->PARALINH',;
				'C->CFEACFC',;
				'C->CFEACFD',;
				'C->NATOP'})
else
	aContas:={	Plinha('ContaReceitaFrete'   ,16,'N'),;	// 01
					Plinha('ContaICMSFrete'      ,16,'N'),;	//	02
					Plinha('ContaICMSRecuperar'  ,16,'N'),;	//	03
					Plinha('ContaPISFrete'       ,16,'N'),;	//	04
					Plinha('ContaPISRecuperar'   ,16,'N'),;	//	05
					Plinha('ContaCOFINSFrete'    ,16,'N'),;	//	06
					Plinha('ContaCOFINSRecuperar',16,'N'),;	//	07
					Plinha('ContaDespesaFrete'   ,16,'N'),;	//	08
					Plinha('ContaDespesaICMS'    ,16,'N'),;	//	09
					Plinha('ContaDespesaPIS'     ,16,'N'),;	//	10
					Plinha('ContaDespesaCOFINS'  ,16,'N')}		//	11

	select CFEACFC
	ORDEM DTCFRE // ORDEM DATA + NR Conhecimento de Frete
	DbGoTop()
	dbseek(dtos(DATA[1]),.T.) // data inicial
	while !eof().and.CFEACFC->CFC_DTEMI<=DATA[2] // até data final
		@nLinha,40 say 'Conh.Frete:'+dtoc(CFEACFC->CFC_DTEMI)
		NATOP->(dbseek(str(CFEACFC->CFC_CODOP,7)))
		if !CFEACFC->CFC_CONTAB.and.NATOP->NO_FLCTB#'N' 	// Nao contabilizado ?
			FRETE   :={	CFEACFC->CFC_TARIFA+;
							CFEACFC->CFC_VLFRET+;
							CFEACFC->CFC_VLSEC+;
							CFEACFC->CFC_VLDESP+;
							CFEACFC->CFC_VLITR+;
							CFEACFC->CFC_VLOUTR+;
							CFEACFC->CFC_VLSEG+;
							CFEACFC->CFC_VLPED,;	// 1-Vlr FRETE
							CFEACFC->CFC_VLICMS,;// 2-Vlr ICMS
							0,0,0,0}
			FRETE[3]:=trunca(FRETE[1]*0.0165,2) // 3-Vlr PIS
			FRETE[4]:=trunca(FRETE[1]*0.0760,2) // 4-Vlr COFINS
			
			CLIENTE->(dbseek(str(CFEACFC->CFC_CODDE,5)))
			TpFor   :=max(CLIENTE->CL_ATIVID,1)
			TpEmpr  :=CLIENTE->CL_TPEMPR

			select('CTACTB')
			DbGoTop()
			if CFEACFC->CFC_TPFRE1=='1' // 1=PAGO (Entrada)
				nTpCTB:='E'
			else // 2=A PAGAR (Saida)
				nTpCTB:='S'
			end
			VConta:=fn_lecc(nTpCTB,TpFor,0, 0)	//..................CTA Fornec/Cliente (Prazo)
			VHist :="Ref.Conh.Frete "

			if str(CFEACFC->CFC_PARCE,3)==str(0,3) // A vista
				BANCO->(dbseek(STR(CFEACFC->CFC_BCO,2)))
				VConta:=BANCO->BC_CONTA // Pagamento a Vista
				if VConta==0
					VConta:=BuscBcoCx() //........Pagamento a vista
				end
				VHist :="Rec.Conh.Frete "
				if CFEACFC->CFC_TPFRE1#'1'
					VHist :="Pago Conh.Frete "
				end
			end
			//.........................................................Contabilizar
			if CFEACFC->CFC_TPFRE1=='1' // 1=PAGO (Entrada)
				//.DESPESA+RECEITA
				Grava_Work({aContas[08],;
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							DEB * (FRETE[1]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				Grava_Work({VConta,;
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							CRE * (FRETE[1]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				//ICMS
				VHist :="Ref.Conh.Frete "
				Grava_Work({aContas[09],; // ICMS Despesa
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							DEB * (FRETE[2]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				Grava_Work({aContas[03],; // ICMS Recuperar
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							CRE * (FRETE[2]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				//PIS
				VHist :="Ref.Conh.Frete "
				Grava_Work({aContas[10],; // PIS Despesa
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							DEB * (FRETE[3]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				Grava_Work({aContas[05],; // PIS Recuperar
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							CRE * (FRETE[3]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				//COFINS
				VHist :="Ref.Conh.Frete "
				Grava_Work({aContas[11],; // COFINS Despesa
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							DEB * (FRETE[4]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				Grava_Work({aContas[07],; // COFINS Recuperar
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							CRE * (FRETE[4]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
			else	//................................2=A PAGAR (SAIDA)
				//.DESPESA+RECEITA
				Grava_Work({VConta,;
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							DEB * (FRETE[1]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				Grava_Work({aContas[01],;
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							CRE * (FRETE[1]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				//ICMS
				VHist :="Ref.Conh.Frete "
				Grava_Work({aContas[02],; // ICMS Despesa
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							DEB * (FRETE[2]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				Grava_Work({aContas[03],; // ICMS Recuperar
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							CRE * (FRETE[2]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				//PIS
				VHist :="Ref.Conh.Frete "
				Grava_Work({aContas[04],; // PIS SOBRE FRETE
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							DEB * (FRETE[3]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				Grava_Work({aContas[05],; // PIS Recuperar
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							CRE * (FRETE[3]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				//COFINS
				VHist :="Ref.Conh.Frete "
				Grava_Work({aContas[06],; // COFINS SOBRE FRETE
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							DEB * (FRETE[4]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
				Grava_Work({aContas[07],; // COFINS Recuperar
							CFEACFC->CFC_DTEMI,;
							VHist+alltrim(str(CFEACFC->CFC_NUMCF))+'/'+alltrim(CFEACFC->CFC_SERCF)+' de '+CLIENTE->CL_RAZAO,;
							CRE * (FRETE[4]),;
							'CFR/'+str(CFEACFC->CFC_NUMCF,8)+':'+CFEACFC->CFC_SERCF})
			end
			select CFEACFC
			if CFEACFC->(reclock())
				replace CFEACFC->CFC_CONTAB with .T. 
			end
			wContabilizar()
		end
		dbUnlockAll()
		dbskip()
	end
end
dbcloseall()
FileDelete (ARQ + '.*')
return .T.
*----------------------------------------------------------------EOF------------------------
