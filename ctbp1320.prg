//-----------------------------------------------------------------------------*
  static aVariav := {'N',0,0,{},0,0,0}
//....................1..2.3..4.5.6.7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate SubTotLote   => aVariav\[ 1 \]
#xtranslate X            => aVariav\[ 2 \]
#xtranslate nLote        => aVariav\[ 3 \]
#xtranslate VM_TT        => aVariav\[ 4 \]
#xtranslate VM_REL       => aVariav\[ 5 \]
#xtranslate VM_PAG       => aVariav\[ 6 \]
#xtranslate VM_LAR       => aVariav\[ 7 \]

*-----------------------------------------------------------------------------*
 function CTBP1320(P1)	//	Listagem do diario geral									*
*-----------------------------------------------------------------------------*
* P1='D' pedir data
* P1='M' pedir mes

#include 'RCB.CH'

pb_lin4('Impressao do diario geral mensal',ProcName())
if !abre({	'C->PARAMCTB',;
				'R->CTADET',;
				'R->RAZAO',;
				'R->CTATIT'})
	return NIL
end
select('CTADET');dbsetorder(2)
select('RAZAO') ;dbsetorder(2)
set relation to RZ_CONTA into CTADET

private VM_MESL:=month(date())-1
private VM_ATA :='N'
private VM_FORM:=80
private VM_DATA:={bom(date()),eom(date())}
private VM_TIPO:='N'

default P1 to 'M'

X         :=16
SubTotLote:='N'
pb_box(X++,45,,,,'Selecione')
@X,  47 say 'Tam. Formulario..:' get VM_FORM picture mI3       valid str(VM_FORM,3)$' 80|140' when pb_msg('<80> Divide o Lancamento em 2 linhas <140> Lancamento em 1 linha')
@X++,col()+2 say 'Colunas'
@X++,47 say 'Ult.Pag.Impressa.: '+pb_zer(PARAMCTB->PA_PGDIAR,4)
@X++,47 say 'Atualizar Folha  ?' get VM_ATA picture '!'        valid (VM_ATA$'SN') when P1=='M'
if P1=='M'
	@X++,47 say 'Mes de Impressao.:' get VM_MESL pict mI2       valid VM_MESL>0.and.VM_MESL<13 	when pb_msg('Ano Contabil:'+str(PARAMCTB->PA_ANO,4))
	@X++,47 say 'Lista Balancete..:' get VM_TIPO pict mUUU      valid VM_TIPO$'SN'					when pb_msg('Listar balancete no fim do diario ?')
else
	@X  ,47 say 'Periodo ' get VM_DATA[1] valid year(VM_DATA[1])==PARAMCTB->PA_ANO					when pb_msg('Ano Contabil:'+str(PARAMCTB->PA_ANO,4))
	@X++,68                get VM_DATA[2] valid VM_DATA[1]<=VM_DATA[2]
	@X  ,47 Say 'SubTotal por Lote:' get SubTotLote Pict mUUU   valid SubTotLote$'SN' when pb_msg('Sub total por lote ?')
end
read
setcolor(VM_CORPAD)
if lastkey()#27
	if P1=='M'
		VM_DATA[1]:=ctod('01/'+pb_zer(VM_MESL,2)+'/'+str(PARAMCTB->PA_ANO))
		VM_DATA[2]:=eom(VM_DATA[1])
	end
	CTBP1321(P1)
end
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  static function CTBP1321(P1)
//-----------------------------------------------------------------------------*
local VM_CTAFI
local VM_CTAIN
local cImpr:=if(VM_FORM==80,I15CPP,I20CPP)
VM_PAG := PARAMCTB->PA_PGDIAR

if pb_ligaimp(cImpr)
	dbseek(dtos(VM_DATA[1]),.T.)
	nLote  := RZ_NRLOTE
	VM_TT  := {0,0,0,0} // 2-Total D/C do relatório e 2-Total DC Lote
	VM_REL := 'D i a r i o   G e r a l      '
	if P1=='M'
		VM_REL+='Mes : '+pb_mesext(VM_MESL)+'/'+str(PARAMCTB->PA_ANO,4)
	else
		VM_REL+='Ref : '+dtoc(VM_DATA[1])+' a  '+dtoc(VM_DATA[2])
	end
	VM_LAR:=132+if(VM_FORM==140,60,0)
	FLAG  :=.T.
	while !eof().and.RZ_DATA>=VM_DATA[1].and.RZ_DATA<=VM_DATA[2]
		if prow()==58
			CTBP132R()// Rodapé
		end
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CTBP1320A',VM_LAR,,FLAG)
		FLAG  :=.F.
		? DtoC(RZ_DATA)      +space(1)
		??pb_zer(RZ_NRLOTE,8)+space(1)
		??transform(RZ_CONTA,MASC_CTB)+'-'
		??		pb_zer(CTADET->CD_CTA,4)+'-'
		??				 CTADET->CD_DESCR	+space(1)
		??space(19+if(RZ_VALOR<0,20,0))
		??transform(abs(RZ_VALOR),masc(22))
		if VM_FORM==80
			? space(len(trim(MASC_CTB))+21)
		elseif RZ_VALOR>0
			??space(20)
		end
		??space(2)+RZ_HISTOR
		VM_TT[if(RZ_VALOR<0,1,2)]=VM_TT[if(RZ_VALOR<0,1,2)]+abs(RZ_VALOR)
		VM_TT[if(RZ_VALOR<0,3,4)]=VM_TT[if(RZ_VALOR<0,3,4)]+abs(RZ_VALOR) // Total por lote
		pb_brake()
		QuebraLote()
	end
	?
	? space(len(trim(MASC_CTB))+18)+if(P1='M','TOTAL DO MES ','TOTAL PERIODO')
	??space(42)
	??transform(VM_TT[1],masc(22))+space(2)
	??transform(VM_TT[2],masc(22))
	?replicate('-',VM_LAR)
	select CTADET
	dbsetorder(2)
	dbgobottom();VM_CTAFI:=CD_CONTA
	DbGoTop();   VM_CTAIN:=CD_CONTA
	if VM_TIPO=='S'
		private 	VM_PQB:={},;
					VM_CQB:={},;
					VM_TOT:={},;
					VM_CT :=0
					VM_PAG++
//.................MES...SÓ SLD..INICIO...FIM..NIV..DIARIO......................
		set margin to 15
		VM_PAG:=CTBPBALM(VM_MESL,'S',VM_CTAIN,VM_CTAFI,9,   'D', VM_PAG)	// montar balancete
		set margin to 
//..............................................................................
	end
	eject
	pb_deslimp(C15CPP)
	set relation to
	if VM_ATA=='S'.and.PARAMCTB->(reclock())
		replace PARAMCTB->PA_PGDIAR with VM_PAG
	end
	dbcloseall()
end
return NIL

//---------------------------------------------------------------------------*
  function CTBP1320A()
//---------------------------------------------------------------------------*
? padl('D a t a',10)+space(1)
??'Nro.Lote '
??padc('Conta',len(MASC_CTB)-3)+'-Redz-'
??space(00)+'Descricao da Conta'+space(08)
??space(28)+'Debitos do Mes'
??space(05)+'Creditos do Mes'
if VM_FORM==80
	?space(len(trim(MASC_CTB))+21) // quebra a linha para histórico
end
??'  Historico'
?replicate('-',VM_LAR)

? space(len(trim(MASC_CTB))+23)+'De transporte'
??space(37)+transform(VM_TT[1],masc(22))
??space(02)+transform(VM_TT[2],masc(22))
?
return NIL

//---------------------------------------------------------------------------*
  static function CTBP132R()
//---------------------------------------------------------------------------*
?
? space(len(trim(MASC_CTB))+18)+'A transportar'
??space(42)
??transform(VM_TT[1],masc(22))+space(2)
??transform(VM_TT[2],masc(22))
?
return NIL

//---------------------------------------------------------------------------*
  static function QuebraLote()
//---------------------------------------------------------------------------*
if nLote # RZ_NRLOTE.and.SubTotLote=='S'
	?
	? space(len(trim(MASC_CTB))+18)
	??padr('Total do Lote',55,'.')
	??transform(VM_TT[3],masc(22))+space(2)
	??transform(VM_TT[4],masc(22))
	if str(VM_TT[3],15,2)#str(VM_TT[4],15,2)
		?padc('LOTE COM DIFERENCA '+transform(VM_TT[3]-VM_TT[4],masc(22)),VM_LAR,'>')
	end
	VM_TT[3]:=0		
	VM_TT[4]:=0		
	nLote  := RZ_NRLOTE
end
return NIL
//----------------------------------------------EOF--------------------------
