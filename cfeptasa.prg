//-----------------------------------------------------------------------------*
  static aVariav := {0,0}
//...................1
//-----------------------------------------------------------------------------*
#xtranslate DATA    => aVariav\[  1 \]
#xtranslate nX      => aVariav\[  2 \]
*-----------------------------------------------------------------------------**-----------------------------------------------------------------------------*
#include 'RCB.CH'

 function CFEPTASA()	// - TERMO DE ABERTURA E ENCERRAMENTO							*
*-----------------------------------------------------------------------------*
local X
pb_lin4(_MSG_,ProcName())
if !abre({	'C->PARAMETRO',;
				'R->PARAMCTB'})
	return NIL
end

private ASSINATURA:=restarray('ASSINATU.ARR')
private PAG       :=PARAMETRO->PA_PAGSA
private LIV       :=PARAMETRO->PA_LIVSA
private VM_EMPR1  :=trim(ASSINATURA[4])
DATA              :={boy(date()),eoy(date())}

nX:=15
pb_box(nX++,25,,,,'Livro Reg.Entrada')
@nX++,27 say 'Empresa: '+VM_EMPR1
@nX++,27 say 'Data Inicial....:' get DATA[1]    pict mDT
@nX++,27 say 'Data Final......:' get DATA[2]    pict mDT valid DATA[2]>=DATA[1]
@nX++,27 say 'N£mero Livro....:' get LIV valid LIV>0
@nX++,27 say 'P gina Final....:' get PAG valid PAG>1
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_ligaimp(I15CPP),.F.)
	VM_NRDIA:=pb_zer(LIV,3)
	VM_NRPAG:=pb_zer(PAG,4)
	VM_DEPAG:=alltrim(pb_extenso(PAG,{'folha','folhas'}))
	VM_ENDER:=alltrim(PARAMETRO->PA_ENDER)
	VM_CIDA :=alltrim(PARAMETRO->PA_CIDAD)
	VM_UF   :=alltrim(PARAMETRO->PA_UF)
	VM_CGC  :=alltrim(transform(PARAMETRO->PA_CGC,masc(18)))
	VM_INSCR:=alltrim(PARAMETRO->PA_INSCR)
	VM_NRJC :=alltrim(PARAMETRO->PA_NRJC)
	VM_DTJC :=if(val(VM_NRJC)>0,'em '+  str(day(PARAMETRO->PA_DTJC),2)+' de '+;
										 pb_mesext(month(PARAMETRO->PA_DTJC))+' de '+;
										        str(year(PARAMETRO->PA_DTJC),4),'')

	*------------------------------------------------------------------*
	VM_TEXTO:=space(83)+'Folha: 001'
	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=padc('T  E  R  M  O     D  E     A  B  E  R  T  U  R  A',100)
	VM_TEXTO+=CRLF+CRLF+CRLF+CRLF
	VM_TEXTO+=padc('L i v r o   R e g i s t r o   d e   S a i d a s     N . '+VM_NRDIA,100)
	VM_TEXTO+=CRLF+CRLF
	VM_TEXTO+='Contem o presente livro &VM_NRPAG ( &VM_DEPAG ) numeradas '
	VM_TEXTO+='via computador de nro 0001 a &VM_NRPAG que servira de livro '
	VM_TEXTO+='"REGISTRO DE SAIDAS" n. &VM_NRDIA para a empresa &VM_EMPR1 , '
	VM_TEXTO+='estabelecida &VM_ENDER municipio de &VM_CIDA - Estado '
	VM_TEXTO+='&VM_UF , inscrita no CNPJ/MF sob o nro &VM_CGC e inscricao '
	VM_TEXTO+='estadual nro &VM_INSCR registrada na Junta Comercial do '
	VM_TEXTO+='estado &VM_UF nro &VM_NRJC &VM_DTJC .'
	VM_TEXTO+=CRLF+CRLF
	VM_TEXTO+=space(60)+VM_CIDA+', '+pb_zer(day(DATA[1]),2) + ' de '+ pb_mesext(DATA[1],'C')+' de '+str(year(DATA[1]),4)
	VM_TEXTO+=CRLF+CRLF
	VM_NRLIN=mlcount(VM_TEXTO,100)
	set margin to 15
	for X:=1 to VM_NRLIN
		?memoline(VM_TEXTO,100,X)
		?
	next
	?ASSINATURA[1]
	?ASSINATURA[2]
	?ASSINATURA[3]
	set margin to
	eject
	*------------------------------------------------------------------*
	VM_TEXTO=space(83)+'Folha: '+VM_NRPAG
	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=padc('T  E  R  M  O     D  E     E  N  C  E  R  R  A  M  E  N  T  O',100)
	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=padc('L i v r o   R e g i s t r o   d e   S a i d a s     N . '+VM_NRDIA,100)
	VM_TEXTO+=CRLF+CRLF
	VM_TEXTO+='Contem o presente livro &VM_NRPAG ( &VM_DEPAG ) numeradas '
	VM_TEXTO+='via computador de nro 0001 a &VM_NRPAG que serviu de livro '
	VM_TEXTO+='"REGISTRO DE SAIDAS" n. &VM_NRDIA '
	VM_TEXTO+=', para o lancamento das operacaoes proprias, no periodo '
	VM_TEXTO+=pb_zer(day(DATA[1]),2) + ' de '+ pb_mesext(DATA[1],'C')+' de '+str(year(DATA[1]),4)+' a '
	VM_TEXTO+=pb_zer(day(DATA[2]),2) + ' de '+ pb_mesext(DATA[2],'C')+' de '+str(year(DATA[2]),4)
	VM_TEXTO+=' da empresa &VM_EMPR1 , '
	VM_TEXTO+='estabelecida &VM_ENDER municipio de &VM_CIDA - Estado '
	VM_TEXTO+='&VM_UF , inscrita no CNPJ/MF sob o nro &VM_CGC e inscricao '
	VM_TEXTO+='estadual nro &VM_INSCR registrada na Junta Comercial do '
	VM_TEXTO+='estado &VM_UF nro &VM_NRJC &VM_DTJC .'
	VM_TEXTO+=CRLF+CRLF
	VM_TEXTO+=space(60)+VM_CIDA+', '+pb_zer(day(DATA[2]),2) + ' de '+ pb_mesext(DATA[2],'C')+' de '+str(year(DATA[2]),4)
	VM_TEXTO+=CRLF+CRLF

	VM_NRLIN:=mlcount(VM_TEXTO,100)
	set margin to 15
	for X:=1 to VM_NRLIN
		?memoline(VM_TEXTO,100,X)
		?
	next
	?ASSINATURA[1]
	?ASSINATURA[2]
	?ASSINATURA[3]
	set margin to
	eject
	pb_deslimp(C15CPP)

	select('PARAMETRO')
	if reclock()
		replace PA_LIVSA with LIV
		dbrunlock()
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEPASSI()	// - ASSINATURA EM 
*-----------------------------------------------------------------------------*
local ASSINATURA:={space(78),space(78),space(78),padr(VM_EMPR,60)}
pb_lin4(_MSG_,ProcName())
if file('ASSINATU.ARR')
	ASSINATURA:=restarray('ASSINATU.ARR')
	if len(ASSINATURA)==3
		aadd(ASSINATURA,padr(VM_EMPR,60))
	end
end
pb_box(14,0,,,,'Linhas de Assinatura/Empresa')
@16,01                     get ASSINATURA[1] pict mXXX
@17,01                     get ASSINATURA[2] pict mXXX
@18,01                     get ASSINATURA[3] pict mXXX
@20,01 say 'Nome Empresa:' get ASSINATURA[4] pict mUUU valid !empty(ASSINATURA[4])
read
if pb_sn()
	savearray(ASSINATURA,'ASSINATU.ARR')
end
return NIL
//------------------------ EOF --------------------------------//
