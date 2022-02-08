//-----------------------------------------------------------------------------*
  static aVariav := {0,{}}
//...................1, 2
//-----------------------------------------------------------------------------*
#xtranslate X    => aVariav\[  1 \]
#xtranslate DATA => aVariav\[  2 \]

*-----------------------------------------------------------------------------*
#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function CTBP1340()	// - TERMO DE ABERTURA E ENCERRAMENTO							*
*-----------------------------------------------------------------------------*

pb_lin4('Impress„o dos termos Abertura/Encerramento',ProcName())
if !abre({	'R->PARAMETRO',;
				'R->PARAMCTB'})
	return NIL
end
ASSINATURA:=restarray('ASSINATU.ARR')
DATA   :={bom(date()),eom(date())}

private  VM_PAGI :=PARAMCTB->PA_PGDIAR
private  VM_PAGF :=PARAMCTB->PA_LMDIAR
private  VM_NRDI :=PARAMCTB->PA_NRDIAR
private  VM_FORM :=80
private  TIPO    :='T'
private  VM_EMPR1:=trim(ASSINATURA[4])
X:=15
pb_box(X++,25,,,,'Selecao')
@X++,27 say VM_EMPR1
@X++,27 say 'Formul rio....:'  get VM_FORM  pict mI3   valid VM_FORM==132.or.VM_FORM==80 when pb_msg('Informe numero de Colunas - 80 ou 132')
@X  ,27 say 'Data Inicial..:'  get DATA[1]    pict mDT
@X++,57 say 'Final....:'       get DATA[2]    pict mDT valid DATA[2]>=DATA[1]

@X++,27 say 'Nro Di rio ....:' get VM_NRDI   pict mI4 valid VM_NRDI>=0
@X  ,27 say 'P gina Inicial.:' get VM_PAGI   pict mI4 valid VM_PAGI>=0
@X++,57 say 'Final....:'       get VM_PAGF pict mI4   valid VM_PAGF>VM_PAGI
@X++,27 say 'Tipo Imprimir..:' get TIPO     pict mUUU  valid TIPO$'TAE' when pb_msg('T=Todas   A=Abertura   E=Encerramento')
read
setcolor(VM_CORPAD)

if if(lastkey()#27,pb_ligaimp(if(VM_FORM==132,C15CPP,I15CPP)),.F.)
	VM_NRDIA:=pb_zer(VM_NRDI,4)
	VM_NRPAG:=pb_zer(VM_PAGF,4)
	VM_DEPAG:=alltrim(pb_extenso(VM_PAGF,{'folha','folhas'}))
	VM_ENDER:=alltrim(PARAMETRO->PA_ENDER)
	VM_CIDA :=alltrim(PARAMETRO->PA_CIDAD)
	VM_UF   :=alltrim(PARAMETRO->PA_UF)
	VM_CGC  :=alltrim(PARAMETRO->PA_CGC)
	VM_INSCR:=alltrim(PARAMETRO->PA_INSCR)
	VM_NRJC :=alltrim(PARAMETRO->PA_NRJC)

	VM_DTJC :=if(val(VM_NRJC)>0,'em '+  str(day(PARAMETRO->PA_DTJC),2)+' de '+;
										 pb_mesext(month(PARAMETRO->PA_DTJC))+' de '+;
										        str(year(PARAMETRO->PA_DTJC),4),'')

	*------------------------------------------------------------------*
	VM_TEXTO:=space(82)+'Folha : 001'
	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=padc('T  E  R  M  O     D  E     A  B  E  R  T  U  R  A',100)
	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=padc('L i v r o   D i a r i o   G e r a l     N . '+VM_NRDIA,100)
	VM_TEXTO+=CRLF+CRLF
	VM_TEXTO+='Contem o presente livro &VM_NRPAG ( &VM_DEPAG ) numeradas '
	VM_TEXTO+='via computador de nro 0001 a &VM_NRPAG que servira de livro '
	VM_TEXTO+='"DIARIO GERAL" n. &VM_NRDIA para a empresa &VM_EMPR1 , '
	VM_TEXTO+='estabelecida &VM_ENDER municipio de &VM_CIDA - Estado '
	VM_TEXTO+='&VM_UF , inscrita no CNPJ/MF sob o nro &VM_CGC e inscricao '
	VM_TEXTO+='estadual nro &VM_INSCR registrada na Junta Comercial do '
	VM_TEXTO+='estado &VM_UF nro &VM_NRJC &VM_DTJC .'
	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=space(60)+VM_CIDA+', '
	VM_TEXTO+=pb_zer(day(DATA[1]),2) + ' de '+ pb_mesext(DATA[1],'C')+' de '+str(year(DATA[1]),4)
	VM_TEXTO+=CRLF+CRLF
	VM_NRLIN:=mlcount(VM_TEXTO,100)
	if TIPO$'TA'
		set margin to 15
		for VM_X:=1 to VM_NRLIN
			?memoline(VM_TEXTO,100,VM_X)
			?
		next
		?ASSINATURA[1]
		?ASSINATURA[2]
		?ASSINATURA[3]
		set margin to
		eject
	end
	*------------------------------------------------------------------*
	VM_TEXTO:=space(82)+'Folha : '+VM_NRPAG
	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=padc('T  E  R  M  O     D  E     E  N  C  E  R  R  A  M  E  N  T  O',115)
	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=padc('L i v r o   D i a r i o   G e r a l     N . '+VM_NRDIA,115)
	VM_TEXTO+=CRLF+CRLF
	VM_TEXTO+='Contem o presente livro &VM_NRPAG ( &VM_DEPAG ) numeradas '
	VM_TEXTO+='via computador de nro 0001 a &VM_NRPAG que serviu de livro '
	VM_TEXTO+='"DIARIO GERAL" n. &VM_NRDIA '
	VM_TEXTO+=', para o lancamento das operacaoes proprias, no periodo '
	VM_TEXTO+=pb_zer(day(DATA[1]),2) + ' de '+ pb_mesext(DATA[1],'C')+' de '+str(year(DATA[1]),4)+' a '
	VM_TEXTO+=pb_zer(day(DATA[2]),2) + ' de '+ pb_mesext(DATA[2],'C')+' de '+str(year(DATA[2]),4)
	VM_TEXTO+=' da empresa &VM_EMPR1 , '
	VM_TEXTO+='estabelecida &VM_ENDER municipio de &VM_CIDA - Estado '
	VM_TEXTO+='&VM_UF , inscrita no CNPJ/MF sob o nro &VM_CGC e inscricao '
	VM_TEXTO+='estadual nro &VM_INSCR registrada na Junta Comercial do '
	VM_TEXTO+='estado &VM_UF nro &VM_NRJC &VM_DTJC .'
	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=space(60)+VM_CIDA+', '
	VM_TEXTO+=pb_zer(day(DATA[2]),2) + ' de '+ pb_mesext(DATA[2],'C')+' de '+str(year(DATA[2]),4)
	VM_TEXTO+=CRLF+CRLF
	VM_NRLIN:=mlcount(VM_TEXTO,100)
	if TIPO$'TE'
		set margin to 15
		for VM_X:=1 to VM_NRLIN
			?memoline(VM_TEXTO,100,VM_X)
			?
		next
		?ASSINATURA[1]
		?ASSINATURA[2]
		?ASSINATURA[3]
		set margin to
		eject
	end
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

// -------------EOF------------ //
