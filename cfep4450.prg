*-----------------------------------------------------------------------------*
 function CFEP4450()	//	Movimetacoes do estoque - FRETE								*
*-----------------------------------------------------------------------------*
#include 'ACHOICE.CH'
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'E->PARAMETRO',;
				'E->TABICMS',;
				'E->HISPAD',;
				'E->HISFOR',;
				'E->PROD',;
				'E->CLIENTE',;
				'E->DPFOR',;
				'E->CTADET',;
				'E->RAZAO',;
				'E->BANCO',;
				'E->GRUPOS',;
				'E->MOVEST'})
	return NIL
end
pb_dbedit1('CFEP445','Frete ')

select('DPFOR')
set relation to str(DP_CODFO,5) into CLIENTE
select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0
select('PROD')
ORDEM CODIGO
select('MOVEST')
ORDEM DTCOD
DbGoTop()
set relation to str(ME_CODPR,L_P) into PROD

VM_CAMPO:={ fieldname(7),;	// Tipo
				fieldname(2),; // Data
				'str(MOVEST->ME_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,22)',;
				fieldname(3),; // Docto
				fieldname(4),; // Qtde
				fieldname(5);	// Vlr Mov Médio
				}
VM_CABE    :={'T','Dt Movto','Produto','Dcto','Qtde.','Vlr.Est.'}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
// dbcommitall()
set relation to
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function CFEP4451() // Digita Frete
//-----------------------------------------------------------------------------*
VM_DOCFR :=0
VM_EMIFR :=PARAMETRO->PA_DATA
VM_NOPFR :=5102000
VM_FORFR :=0
VM_VLRFR :=0
VM_ICMSF :=0
VM_PARFR :='N'
VM_CXAFR :='N'
VM_BCOFR :=0
VM_VICMSF:=0
pb_box(10,,,,,'Lancamento de Frete')
@15,00 say 'Ã'+replicate('Ä',78)+'´'
@11,01 say 'Documento....:' get VM_DOCFR  pict masc(08) valid VM_DOCFR>0
@11,38 say 'Data.:'         get VM_EMIFR  pict masc(07) valid VM_EMIFR<=PARAMETRO->PA_DATA
@11,60 say 'Nat Op:'        get VM_NOPFR  pict mNAT     valid VM_NOPFR>=0
@12,01 say 'Emitente.....:' get VM_FORFR  pict masc(04) valid fn_codigo(@VM_FORFR,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_FORFR,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.fn_icms(@VM_ICMSF,'E')
@13,01 say 'Valor Frete..:' get VM_VLRFR  pict masc(05) valid VM_VLRFR>0
@13,31 say 'Parcelado?:'    get VM_PARFR  pict masc(01) valid VM_PARFR$'SN'
@12,60 say '% I.C.M.S..:'   get VM_ICMSF  pict masc(14) valid VM_VICMSF>=0 when eval({|X,Y|VM_VICMSF:=round(X*Y/100,2)},VM_ICMSF,VM_VLRFR)>=0
@13,55 say 'Vlr ICMS:'      get VM_VICMSF pict masc(05) valid VM_VICMSF>=0
@14,01 say 'Pagto Caixa ?:' get VM_CXAFR  pict masc(01) valid VM_CXAFR$'SN'          when VM_PARFR='N'
@14,20 say 'C¢d.Banco..:'   get VM_BCOFR  pict masc(11) valid fn_codigo(@VM_BCOFR,{'BANCO',{||BANCO->(dbseek(str(VM_BCOFR,2)))},{||CFEP1500T(.T.)},{2,1}}) when VM_PARFR='S'.or.VM_CXAFR='N'
read
if lastkey()==K_ESC
	return NIL
end

VM_NOMFR :=trim(CLIENTE->CL_RAZAO)
VM_VLRFRL:=VM_VLRFR-round(VM_VICMSF,2)
if VM_PARFR=='S'	// Frete Parcelado
	salvacor()
	setcolor('R/W')
	@15,01 say '[FRETE parcelado]'
	@16,01 say 'Duplicata'+space(4)+'Dt.Venc.'+space(11)+'VALOR'
	salvacor(.F.)
	VM_FRETE :={space(3)+'F I M'}
	VM_FECHA :=0
	VM_VLRFAT:={VM_VLRFR}
	VM_OPC   :=0
	keyboard chr(K_INS)
	while .T.
		VM_OPC:=achoice(17,01,21,37,VM_FRETE,.T.,'CFEP4411A')
		if len(VM_FRETE)==VM_OPC // tenta finalizar
			if str(VM_FECHA,15,2) # str(VM_VLRFR,15,2)
				if pb_sn('Valores n„o fechados ! ABANDONAR')
					return NIL
				end
			else
				exit
			end
		end
		if lastkey()#K_ESC
			keyboard replicate(chr(K_DOWN),VM_OPC++)+chr(K_INS)
		end
	end
end
*-------------------------------------------------------LANCTOS REF. FORNECEDOR
pb_box(15,00)
tone(600,2)	
salvacor()
setcolor('R/W')
@15,1 say '[LANCAMENTO Frete no Estoque]'
@16,1 say 'Produto'+space(44)+'Total-FRETE'
salvacor(.F.)
VM_MATER={space(2)+'F I M'}
VM_FECHA=0
VM_OPC=0
keyboard chr(K_INS)
while .T.
	VM_OPC:=achoice(17,02,21,77,VM_MATER,.T.,'CFEP4451A')
	if len(VM_MATER) == VM_OPC
		if round(VM_FECHA,2) # round(VM_VLRFRL,2)
			if pb_sn('Valores n„o fechados ! ABANDONAR')
				return NIL
			end
		else
			exit
		end
	end
	if lastkey()#K_ESC
		keyboard replicate(chr(K_DOWN),VM_OPC++)+chr(K_INS)
	end
end
if !pb_sn()
	return NIL
end
*------------------------------->  G  R  A  V  A  C  A  O

	pb_msg('Gravando... Aguarde...',nil,.F.)

*------------------------------------------------------------ESTOQUE
	VM_ICMSV=0
	VM_VLEST={{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}
	for VM_X=1 to len(VM_MATER)-1
		select('PROD');dbseek(left(VM_MATER[VM_X],L_P))	// Produto
		if PR_CTB=0;replace PR_CTB with 4;end // grava cod contabil 4=prod rev
		VM_VLRPR =val(substr(VM_MATER[VM_X],50,12))
		VM_VLEST[PR_CTB,1]+=VM_VLRPR // ACM FRETE tipo de estoque
			
		replace	PR_VLATU with PR_VLATU+VM_VLRPR,;
					PR_DTMOV with VM_EMIFR
		*-----------------------------------Movimentacao

		select('MOVEST')
		GrMovEst({	val(substr(VM_MATER[VM_X],01,L_P)),;		//	1 Cod Produto
						VM_EMIFR,;//		2 Data Movto
						VM_DOCFR,;//		3 Nr Docto
						0,;//					4 Qtde
						VM_VLRPR,;		//	5 Vlr Medio (Total)
						PROD->PR_VLVEN*abs(VM_QTDE),;		//	6 Vlr Venda
						'F',;				//	7 Tipo Transferencia
						PROD->PR_CTB,;	//	8 Tipo Produto
						'',;				// 9 Serie - despesas
						0,;				//10 Cod Fornec
						0,;				//11 D-Conta contábil Despesa
						0,;				//12 D-Conta contábil Icms
						0,;				//13 Vlr Icms
						.F.,;				//14 Contabilizado ?
						'N'})				//15 P=Producao  //  D=Despesas // N=Normal
	next
*----------------------------------------------------LCTOS.FINANCEIRO REF.FRETE
//	fn_atconta(PARAMETRO->PA_ESTO1,DEB*VM_VLEST[1,1],'Frete Doc.'+alltrim(str(VM_DOCFR))+' de '+VM_NOMFR,VM_EMIFR,0)
//	fn_atconta(PARAMETRO->PA_ESTO2,DEB*VM_VLEST[2,1],'Frete Doc.'+alltrim(str(VM_DOCFR))+' de '+VM_NOMFR,VM_EMIFR,0)
//	fn_atconta(PARAMETRO->PA_ESTO3,DEB*VM_VLEST[3,1],'Frete Doc.'+alltrim(str(VM_DOCFR))+' de '+VM_NOMFR,VM_EMIFR,0)
//	fn_atconta(PARAMETRO->PA_ESTO4,DEB*VM_VLEST[4,1],'Frete Doc.'+alltrim(str(VM_DOCFR))+' de '+VM_NOMFR,VM_EMIFR,0)
//	fn_atconta(PARAMETRO->PA_ESTO5,DEB*VM_VLEST[5,1],'Frete Doc.'+alltrim(str(VM_DOCFR))+' de '+VM_NOMFR,VM_EMIFR,0)
//	fn_atconta(PARAMETRO->PA_ESTO6,DEB*VM_VLEST[6,1],'Frete Doc.'+alltrim(str(VM_DOCFR))+' de '+VM_NOMFR,VM_EMIFR,0)
//	fn_atconta(PARAMETRO->PA_ICMSA,DEB*VM_VICMSF,'Recuperado doc.'+alltrim(str(VM_DOCFR)),VM_EMIFR,0)

//	VM_CONTA=PARAMETRO->PA_CTCXA

	if VM_PARFR=='N'	// FRETE A VISTA
//		if VM_BCOFR#0.and.VM_CXAFR='N'
//			if (BANCOS->(dbseek(str(VM_BCOFR,2))))
//				VM_CONTA=BANCOS->BC_CTB
//			end
//		end
//		fn_atconta(VM_CONTA,CRE*VM_VLRFR,'Pago doc.'+alltrim(str(VM_DOCFR))+' de '+VM_NOMFR,VM_EMIFR,0)
		if (CLIENTE->(dbseek(str(VM_FORFR,5))))
			salvabd()
			select('HISFOR')
			dbappend(.T.)
			replace 	HF_CODFO with VM_FORFR,;
						HF_DUPLI with VM_DOCFR,;
						HF_DTEMI with VM_EMIFR,;
						HF_DTVEN with VM_EMIFR,;
						HF_DTPGT with VM_EMIFR,;
						HF_VLRDP with VM_VLRFR,;
						HF_VLRPG with VM_VLRFR,;
						HF_VLRMO with pb_divzero(VM_VLRFR,PARAMETRO->PA_VALOR)
			salvabd(.F.)
		end
				
	else // FRETE a prazo
		salvabd()
		select('DPFOR')
		VM_TOTPG=0
		for VM_X=1 to len(VM_FRETE)-1
			dbappend(.T.)
			replace 	DP_DUPLI with val (substr(VM_FRETE[VM_X],01,08)),;
						DP_CODFO with VM_FORFR,;
						DP_DTEMI with VM_EMIFR,;
						DP_CODBC with VM_BCOFR,;
						DP_DTVEN with ctod(substr(VM_FRETE[VM_X],14,08)),;
						DP_VLRDP with val(substr(VM_FRETE[VM_X],26,12)),;
						DP_ALFA  with VM_NOMFR
				VM_TOTPG+=val(substr(VM_FRETE[VM_X],26,12))
		next
		salvabd(.F.)
	end
// dbcommitall()
return NIL

//-----------------------------------------------------------ACHOICE REF.ESTOQUE
 function CFEP4451A(VM_MODO,VM_ELEM,VM_POS)
//-----------------------------------------------------------ACHOICE REF.ESTOQUE
local VM_RT   :=AC_CONT // Resposta default do include achoice
local VM_TECLA:=lastkey()
local VM_TF

if VM_MODO==AC_HITTOP        // Tentativa de subir alem do top
	tone(600,3)
elseif VM_MODO==AC_HITBOTTOM // Tentativa de decer alem do fim
	tone(800,3)
elseif VM_MODO==AC_EXCEPT    // Teclado algo

	if VM_TECLA==K_ENTER.and.VM_ELEM=len(VM_MATER)
		VM_RT:=AC_SELECT

	elseif VM_TECLA==K_ENTER.and.VM_ELEM<len(VM_MATER)
		VM_CODPR:= val(substr(VM_MATER[VM_ELEM],01,L_P))
		VM_VLCOM:= val(substr(VM_MATER[VM_ELEM],50,12))

		@row(),02 get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,50)
		@row(),51 get VM_VLCOM picture masc(05) valid VM_VLCOM>0
		read
		if lastkey()#K_ESC
			VM_FECHA-=val(substr(VM_MATER[VM_ELEM],50,12))
			VM_FECHA+=VM_VLCOM
			VM_MATER[VM_ELEM]=padr(str(VM_CODPR,L_P)+'-'+PROD->PR_DESCR,49)+str(VM_VLCOM,12,2)
		end

	elseif VM_TECLA==K_INS
		VM_TF:=savescreen()
		scroll(row(),02,21,77,-1)
		VM_CODPR := 0
		VM_VLCOM := 0
		@row(),02 get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,50)
		@row(),51 get VM_VLCOM picture masc(05) valid VM_VLCOM>0
		read
		if lastkey()#K_ESC		
			asize(VM_MATER,len(VM_MATER)+1)
			ains(VM_MATER,VM_ELEM)
			VM_MATER[VM_ELEM]:=padr(str(VM_CODPR,L_P)+'-'+PROD->PR_DESCR,49)+str(VM_VLCOM,12,2)
			VM_FECHA+=VM_VLCOM
			VM_RT:=AC_SELECT
		else
			restscreen(,,,,VM_TF)
		end
		
	elseif VM_TECLA==K_DEL
		VM_FECHA-=val(substr(VM_MATER[VM_ELEM],50,12))
		adel(VM_MATER,VM_ELEM)
		asize(VM_MATER,len(VM_MATER)-1)
		VM_RT:=AC_SELECT
	end
end
@15,43 say 'Saldo : '+transform(VM_VLRFRL-VM_FECHA,masc(5))
return VM_RT
//-----------------------------------------------------------------------/
