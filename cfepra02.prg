*-----------------------------------------------------------------------------*
 function CFEPRA02()	// Impressao Receituario Agronomico
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_CLT:={'I  ','II ','III','IV '}
if !abre({	'R->PARAMETRO',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->CLIENTE',;
				'C->PROD',;
				'C->PRODAPL'})
	return NIL
end
select('PROD')
dbsetorder(2)
select('PRODAPL')
set relation to str(P1_CODPR,L_P) into PROD
DbGoTop()
pb_lin4(_MSG_,ProcName())
if file('PARAREC.ARR')
	VM_RECAGR:=restarray('PARAREC.ARR')
else//         1      2          3          4          5          6      7      8   9        10         11 12
	VM_RECAGR:={0,     0,  space(40), space(10), space(11), space(20),0.000,'ha   ', 0,space(120),space(120),3}
	//          NR REC ART  NOME      CREA       CPF        cultura   area   unidade marg, obs
end
if len(VM_RECAGR)==10
	aadd(VM_RECAGR,space(120))
end
if len(VM_RECAGR)==11
	aadd(VM_RECAGR,3)
end

VM_RECAGR[1]++
VM_CODCL:=0
VM_CODPR:=0
VM_UNID :='LT '
VM_DATA :=date()
VM_QTD  :=0.000
pb_box(10,10,,,,'Selecao')
//@11,12 say 'Nr Receit..:'   get VM_RECAGR[01] pict masc(09) valid .T.
@12,12 say 'Cliente....:'   get VM_CODCL      pict masc(04) valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@13,12 say 'Produdo....:'   get VM_CODPR      pict masc(21) valid fn_codpr(@VM_CODPR,77).and.fn_codp1(VM_CODPR)
@14,12 say 'Quantidade.:'   get VM_QTD        pict masc(29) valid VM_QTD>0
@14,40 say 'Unidade:'       get VM_UNID       pict mUUU     valid VM_UNID+'x'$'LT xKG x'  when pb_msg('Transforme tudo para unidades permitidas  LT ou KG')

@15,12 say 'Cultura....:'   get VM_RECAGR[06] pict masc(23)
@15,50 say 'Area:'          get VM_RECAGR[07] pict masc(29) when (VM_RECAGR[07]:=round(pb_divzero(VM_QTD,PRODAPL->P1_DOSAGE),3))>=0
@15,67 say 'Unid:'          get VM_RECAGR[08] pict masc(23)

@16,12 say 'Vinculado ART:' get VM_RECAGR[02] pict masc(08)
@17,12 say 'Profissional :' get VM_RECAGR[03] pict masc(23)
@18,12 say 'CREA.........:' get VM_RECAGR[04] pict masc(23)
@19,12 say 'C.P.F........:' get VM_RECAGR[05] pict masc(17)
@20,12 say 'Data.........:' get VM_DATA       pict masc(07)
@21,12 say 'Margem Impr..:' get VM_RECAGR[09] pict mI2      valid VM_RECAGR[09]>0 when pb_msg('Nr caracteres de margem para impressao do receiturario')
@21,40 say 'Nr.Lin:'        get VM_RECAGR[12] pict mI2      valid VM_RECAGR[12]>0 when pb_msg('Nr Linhas antes de imprimir nome do Profissional')

read
if lastkey()#K_ESC
	savearray(VM_RECAGR,'PARAREC.ARR')
	if pb_ligaimp(C15CPP+CHR(27)+CHR(67)+chr(72))
		set margin to VM_RECAGR[09]
		VM_QTDTOX:={0,0,0,0,0,0,0,0}
	   VM_QTDTOX[P1_CLTOX*2-1+if(VM_UNID=='LT ',0,1)]:=VM_QTD
		?
		? VM_EMPR
		? PARAMETRO->PA_ENDER
		? transform(PARAMETRO->PA_CEP,masc(10))+space(59)//+pb_zer(VM_RECAGR[1],8)
		? PARAMETRO->PA_CIDAD + space(4)+PARAMETRO->PA_UF
		? 
		?
		?
		? space(5)+left(CLIENTE->CL_RAZAO,40)+space(1)+pb_zer(VM_CODCL,5)
		? space(5)
		??padr(transform(CLIENTE->CL_CGC,masc(if(len(trim(CLIENTE->CL_CGC))>11,17,18))),50)
		??I15CPP+padr(VM_RECAGR[06],26)+' '+transform(VM_RECAGR[07],masc(29))
		??' '+VM_RECAGR[08]+C15CPP
		? space(5)+CLIENTE->CL_ENDER
		? space(8)+CLIENTE->CL_CIDAD
		? space(8)+padr(CLIENTE->CL_BAIRRO,30)+space(5)
		??transform(CLIENTE->CL_CEP,masc(10))+space(10)
		??transform(VM_RECAGR[2],masc(8))
		?
		?
		? INEGR
		??padc('Produto :'+trim(PROD->PR_DESCR)+' Unid:'+VM_UNID,80-VM_RECAGR[09])
		??CNEGR
		?
		?'CLASSE TOXICOLOGICA:'+VM_CLT[max(PRODAPL->P1_CLTOX,1)]
		Y:=min(mlcount(PRODAPL->P1_APLICA,70),38)
		for X:=1 to Y
			?memoline(PRODAPL->P1_APLICA,70,X)
		end
		for Z:=X to 36
			?
		next
		for Z:=1 to VM_RECAGR[12]
			?
		end
		? space(28)+VM_RECAGR[03]
		? space(28)+VM_RECAGR[04]                    +space(13)+transform(VM_RECAGR[05],masc(17))
		? space(04)+transform(VM_QTDTOX[01],masc(29))+space(16)+transform(VM_DATA,      masc(07))
		for X:=2 to 8
			?space(04)+transform(VM_QTDTOX[X],masc(29))
		next
		eject
		set margin to
		pb_deslimp(CHR(27)+CHR(67)+chr(66))
	end
end
dbcloseall()
return NIL

*--------------------------------------------------------------------
 static function FN_CODP1(P1)
*--------------------------------------------------------------------
local RT:=.T.
salvabd(SALVA)
select('PRODAPL')
if !dbseek(str(P1,L_P))
	alert('Nao foi implantado a Descricao deste Produto.')
	RT:=.F.
end
salvabd(RESTAURA)
return RT

