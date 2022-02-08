*-----------------------------------------------------------------------------*
function CFEPFAR2(VM_FAT)	//	Impressao/Atualizacao da NF							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local RT :=.F.
local X  :=1
VM_BCO   :=0
VM_AVAL  :={0,space(45),space(45),space(18)}
I_TRANS  :={}
pb_box(19,,,,,'Informacoes Finais')

// VM_SERIE :='CF ' // padrao
private VM_ULTNF :=VM_ULTPD
private VM_NSU   :=0
private VM_BCO   :=1

while !pb_ifcod2(str(VM_ULTNF,6)+VM_SERIE,'PEDCAB',.F.,5)
	VM_ULTNF :=fn_psnf(VM_SERIE)
end

@20,01 say 'S‚rie da Nota Fiscal.................:' get VM_SERIE pict masc(01) valid VM_SERIE+'ú'$'   ú'+SCOLD+'ú'.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}}) when .F.
@21,01 say 'N£mero da Nota Fiscal a ser Impressa.:' get VM_ULTNF pict masc(19) ;
																		valid VM_ULTNF==0.or.pb_ifcod2(str(VM_ULTNF,6)+VM_SERIE,'PEDCAB',.F.,5);
																		when VM_SERIE#SCOLD.and..F.
read
setcolor(VM_CORPAD)
aeval(VM_FAT,{|DET|DET[1]:=VM_ULTNF*100+X++})
if IMPRCUPOM(VM_FAT) // rotina de impressao
	pb_msg('Atualizando Base de dados. Aguarde...',NIL,.F.)
	aeval(VM_DET,{|DET|DET[6]:=0.00}) // limpar desconto por item
	FATPGRPE('Novo','Produto') // Atualizar Pedidos
	CFEP520G() // Atualiza
	RT :=.T.
end
select('PEDCAB')
dbunlockall()
DbGoTop()
setcolor(VM_CORPAD)
keyboard 'S'
return NIL

*-----------------------------------------------------------------------------*
function IMPRCUPOM(VM_FAT)	//	Impressao/Atualizacao da NF							*
*-----------------------------------------------------------------------------*
local RT :=.F.
local LAR:=40
if pb_ligaimp(I15CPP+CHR(27)+CHR(67)+CHR(2))
	? padr(VM_EMPR,LAR)
	? padr(PARAMETRO->PA_ENDER,LAR)
	? padr(PARAMETRO->PA_CEP+space(5)+PARAMETRO->PA_CIDAD+space(5)+PARAMETRO->PA_UF,LAR)
	? "Fone : "+PARAMETRO->PA_FONE
	if !empty(PARAMETRO->PA_FAX)
		??space(5)+"Fax : "+PARAMETRO->PA_FAX
	end
	? 'GCG: '+transform(PARAMETRO->PA_CGC,masc(18))+space(3)+'I.E.'+PARAMETRO->PA_INSCR
	? padc('Data :'+dtoc(VM_DTEMI)+' as  '+time()+' Nr: '+pb_zer(VM_ULTPD,6),LAR)
	?
	? padr('******** CUPOM NAO FISCAL **********',LAR)
	?
	?padr('CLIENTE....: '+VM_NOMNF,LAR)
	if !empty(CLIENTE->CL_ENDER)
		?padr('Endereco...: '+CLIENTE->CL_ENDER,LAR)
	end
	if !empty(VM_CODFC)
		?padr('FUNCIONARIO: '+trim(CLICONV->FC_NOME),LAR)
		?padr('     CODIGO: '+VM_CODFC,LAR)
	end
	?
	?"Produtos/Qtdade/Vlr Unitario/Valor Total"
	?replicate('-',LAR)
	for X:=1 to len(VM_DET)
		if VM_DET[X,2]>0
			? padr(pb_zer(VM_DET[X,2],L_P)+'-'+VM_DET[X,3],LAR)
			? " |"+str(VM_DET[X,4],8,if(VM_DET[X,4]%100>0,2,0))
			??" |"+str(VM_DET[X,5],11,2)
			??" |"+transform(VM_DET[X,6],masc(2))
		end
	next
	?replicate('-',LAR)
	if VM_DESCG>0
		?padc('Total das Mercadorias',25)+transform(VM_TOT,masc(2))
		?padc('Desconto Especial',25)    +transform(VM_DESCG,masc(2))
		?replicate('-',LAR)
	end
	?padc('T  O  T  A  L ',25)+transform(VM_TOT-VM_DESCG,masc(2))
	?replicate('-',LAR)
	?left(PARAMETRO->PA_OBSCUP,40)
	?right(PARAMETRO->PA_OBSCUP,40)
	for X:=1 to PARAMETRO->PA_NRLCUP
		?
	end
	eject
	pb_deslimp(CHR(27)+CHR(67)+CHR(66)+C15CPP)
	RT:=.T.
end
return RT
//-------------------------------------EOF------------------------------------------
