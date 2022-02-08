*-----------------------------------------------------------------------------*
function GDFPPR60()	// GERAR DADOS PARA SECRET FAZENDA
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
*-------------------------------------------------------------------- Movimento
pb_lin4(_MSG_,ProcName())
if !abre({'R->PARAMETRO'})
	return NIL
end
CGC:=pb_zer(val(SONUMEROS(PARAMETRO->PA_CGC)),15)
if file('GDF60S.DBF')
	if !abre({'E->GDF60S'})
		return NIL
	end
	pb_dbedit1("GDFPPR60")
	VM_CAMPO := array(fcount())
	afields(VM_CAMPO)
	dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",,;
			{"Empr","Reg","Tp", "Data","NrCx","NrSerie","Modelo","Cupom In","Cupom Final","Contar=Z","TotINI","TotalFIM","TotACM","Trib"})
else
	Alert('Falta arquivo de parametros para GDF->60')
end
dbcloseall()
return NIL

function GDFPPR601()	// inclui
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	GDFPPR60T(.T.)
end
return NIL

function GDFPPR602() // altera
GDFPPR60T(.F.)
return NIL

function GDFPPR603() // pesquisa
local VM_DATA:=G6_DATA
pb_box(20,20,,,,'Pesquisar')
@21,22 say 'Data:' get VM_DATA pict mDT
read
dbseek(str(1,3)+str(60,2)+descend('M')+str(1,3)+dtos(VM_DATA),.T.)
return NIL

function GDFPPR604() // exclui
if pb_sn('Eliminar ( Cx: '+str(G6_NRCXA,3)+' Data: '+dtoc(G6_DATA)+' ) ?')
	fn_elimi()
end
dbrunlock()
return NIL

function GDFPPR605() // imprime
return NIL

function GDFPPR60T(FL) // imprime
local GETLIST := {},VM_CTCPL,X,X1,LCONT:=.T.
for X :=1 to fcount()
	X1 :="VM"+substr(fieldname(X),3)
	&X1:=FieldGet(X)
next
if FL
	VM_EMPRESA:=1
	VM_TIPO   :=60
	VM_TIPOAM :='A'
	VM_DATA   :=date()-1
	VM_MODELO :='2D'
end
pb_box(07,10,,,,'Registro Tipo=60/Informacoes CF')
@08,12 say 'Empresa....:' get VM_EMPRESA  pict mI3   when .F.
@09,12 say 'Tipo Reg...:' get VM_TIPO     pict mI2   when .F.
@10,12 say 'Sub-Tipo...:' get VM_TIPOAM   pict mUUU  valid VM_TIPOAM$'AM'     when pb_msg('Sub-Tipo de Registro M=Mestre A=Analitico')
@11,12 say 'Data.......:' get VM_DATA     pict mDT                            when pb_msg('')
@12,12 say 'Nr.Caixa...:' get VM_NRCXA    pict mI3   valid VM_NRCXA>0         when pb_msg('Informe o Numero do Caixa : 1,2,3,..N')
@13,12 say 'Nr.Serie...:' get VM_NRSERIE  pict mXXX  valid !empty(VM_NRSERIE) when pb_msg("Informe o Nr.Serie da Caixa Registradora").and.VM_TIPOAM=='M' 
@14,12 say 'Modelo NF..:' get VM_MODELO   pict mUUU                           when pb_msg("").and..F.
@15,12 say 'Nr.Cupom In:' get VM_NRCUPIN  pict mI6   valid VM_NRCUPIN> 0      when pb_msg("").and.VM_TIPOAM=='M'
@16,12 say 'Nr.CupomFim:' get VM_NRCUPFI  pict mI6   valid VM_NRCUPFI> 0      when pb_msg("").and.VM_TIPOAM=='M'
@17,12 say 'Nr.Contad Z:' get VM_CONTZ    pict mI6   valid VM_CONTZ  > 0      when pb_msg("").and.VM_TIPOAM=='M'
@18,12 say 'Vlr Tot.Ini:' get VM_VLRTOTI  pict mI122 valid VM_VLRTOTI>=0      when pb_msg("").and.VM_TIPOAM=='M'
@19,12 say 'Vlr Tot.Fim:' get VM_VLRTOTF  pict mI122 valid VM_VLRTOTF>=0      when pb_msg("").and.VM_TIPOAM=='M'
@20,12 say 'Sit.Tribut.:' get VM_SITRIB   pict mUUU                           when pb_msg("Situacao Tributaria 1700,2500,CANC,DESC,ISS,F/I/N").and.VM_TIPOAM=='A'
@21,12 say 'Vlr Acm.Tot:' get VM_VLRACMT  pict mI122 valid VM_VLRACMT>=0      when pb_msg("").and.VM_TIPOAM=='A'
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if FL	
		AddRec()
	end
	for X:=1 to fcount()
		X1:="VM"+substr(fieldname(X),3)
		replace &(fieldname(X)) with &X1
	next
end
return NIL

