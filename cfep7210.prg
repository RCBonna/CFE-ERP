*-----------------------------------------------------------------------------*
function CFEP7210()	//	Atualiza Parametros Gerais do Sistema						*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
local VM_P1
pb_lin4('Altera dados b sicos',ProcName())

if !abre({'E->PARAMETRO'})
	return NIL
end
for X:=1 to fcount()
	VM_P1 :="VM"+substr(fieldname(X),3)
	&VM_P1:=&(fieldname(X))
next

VM_MODNFE:=if(empty(VM_MODNFE),'55',VM_MODNFE)
VM_NFEAMB:=if(empty(VM_NFEAMB), '2',VM_NFEAMB)


pb_box(,,22,79,,'Altera dados B sicos')
@06,01 say 'Empresa........: '+VM_EMPR
@07,01 say 'Fone...........:'					get VM_FONE    pict mXXX
@07,58 say            'Fax:'					get VM_FAX     pict mXXX
@08,01 say 'Endere‡o.......:'					get VM_ENDER   pict mXXX       valid !empty(VM_ENDER)
@08,64 say 'Nr:'									get VM_ENDNRO  pict mXXX       valid !empty(VM_ENDNRO)
@09,01 say 'Bairro.........:'					get VM_BAIRRO  pict mXXX       valid !empty(VM_BAIRRO)

@10,01 say 'Complemento....:'					get VM_ENDCOMP pict mUUU       when pb_msg('Dados Complemetares do Endereco')
@10,39 say 'e-Mail:'								get VM_EMAIL   pict mXXX+"S34" valid !empty(VM_EMAIL)

@11,01 say 'C.E.P..........:'					get VM_CEP     pict masc(10)   valid !empty(VM_CEP).and.len(VM_CEP)=8
@11,28 say          'Cidade:'					get VM_CIDAD   pict mXXX       valid !empty(VM_CIDAD)
@11,64 say             'UF.:'					get VM_UF      pict mUUU       valid pb_uf(@VM_UF)

@13,01 say 'C.N.P.J........:'					get VM_CGC     pict masc(18)   valid pb_chkdgt(VM_CGC,1)

@14,01 say 'Inscri‡Æo......:'					get VM_INSCR   pict mXXX       when pb_msg('Informe a Inscricao Estadual')
@13,40 say 'Nro Junta Com..:'					get VM_NRJC    pict masc(38)
@14,40 say 'Dt Reg Junt Com:'					get VM_DTJC    pict mDT


@16,01 say 'Codigo IBGE....:'					get VM_CDIBGE  pict mI7        when pb_msg('Consulte tabela IBGE')
@17,01 say 'Codigo SUFRAMA.:'					get VM_CDSUFRA pict mUUU       when pb_msg('Consulte tabela SUFRAMA - http://www.icmsconsultafacil.com.br/icms/codigos/codigodsuframa.htm')
@17,40 say 'Ambiente NFe..:'					get VM_NFEAMB  pict mUUU valid VM_NFEAMB$'12' when pb_msg('Ambiente de trabalho para NFe   1=Producao  2=Homologacao')
@18,01 say 'Codigo Insc Mun:'					get VM_CDMUNIC pict mUUU       when pb_msg('Codigo Inscricao Municipal').and.if(VM_NFEAMB=='1',pb_sn('Tem certeza que Ambiente e ambiente de PRODUCAO para NFE?'),.T.)
@18,50 say 'CNAE:'								get VM_CNAE    pict mUUU valid len(VM_CNAE)==7  when pb_msg('Informe CNAE-Codigo Nacional Atividade Economica - informar todos os digitos')
@16,40 say 'Modelo   NFe..:'					get VM_MODNFE  pict mUUU valid VM_MODNFE=='55' when pb_msg('Modelo Nota Fiscal Eletronica=55 - USAR SOMENTE SE DEVE GERAR NFE')
@19,01 say 'Diretorio Copia:'					get VM_DIRETO  pict mUUU       when pb_msg('Informe o diretoria para copia interna')
@20,01 say 'Variavel CFE....: '+getenv('CFE')     color 'GR+/G'
@21,01 say 'Variavel CLIPPER: '+getenv('CLIPPER') color 'GR+/G'
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	VM_EMAIL:=Lower(VM_EMAIL)
	for X:=1 to fcount()
		VM_P1:="VM"+substr(fieldname(X),3)
		replace &(fieldname(X)) with &VM_P1
	next
end
dbcloseall()
return NIL
*-----------------------------------------------EOF-------*
