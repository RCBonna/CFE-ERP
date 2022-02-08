*-----------------------------------------------------------------------------*
 static aVariav1:= {'G'}
 //.................1.2..3..4.5..6..7...8...9
*-----------------------------------------------------------------------------*
#xtranslate cOpc     => aVariav1\[  1 \]

*-----------------------------------------------------------------------------*
function CFEP5300(P1)//	Impress„o da Duplicata											*
*						P1=1->Duplicata															*
*						P1=2->Carnes																*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

private VM_NRNF,VM_SERIE
private DPLS:={}
if valtype(P1)#'N'
	alert('Rotina Implantada Incorretamente...')
	return NIL
end
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMCTB',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->BANCO',;
				'R->DPCLI',;
				'R->PEDDET',;
				'R->CTRNF',;
				'C->PEDCAB'})
	return NIL
end

select('DPCLI')
ORDEM NNFSER
select('PEDCAB')
ORDEM DTENNF
DbGoTop()
VM_DATA :={PARAMETRO->PA_DATA-1,PARAMETRO->PA_DATA-1}
VM_NRNF :=0
VM_SERIE:='NFE'
VM_NRVIA:=1
pb_box(16,20,,,,'Selecao '+if(P1==1,'Duplicatas','Carnes'))
@17,22 say 'Dt Emiss Inic.:' get VM_DATA[1] pict masc(08)
@17,50 say 'ate'             get VM_DATA[2] pict masc(08) valid VM_DATA[2]>=VM_DATA[1]
@18,22 say 'Informe Serie :' get VM_SERIE   pict masc(01) valid VM_SERIE==SCOLD.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}}) when pb_msg('Informe a Serie das NF com Faturamento')
@19,30 say         'N. NF :' get VM_NRNF    pict masc(19) valid if(VM_NRNF>0,pb_ifcod2(str(VM_NRNF,6)+VM_SERIE,NIL,.T.,5).and.fn_chkdpls().and.PEDCAB->(reclock()),.T.) when pb_msg('Informe 0 para listar todas as Dpls da data informada')
@19,60 say 'Nr Vias :'       get VM_NRVIA   pict masc(11) valid VM_NRVIA>0
if P1==1
	@20,22 say 'Impr. Grafica.:' get cOpc pict mUUU valid cOpc$"GN" when pb_msg('G=Impressão Grafica ou N=Impressora Normal')
end
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if P1==1
		if cOpc=='G'
			ImpressHtml(VM_DATA,VM_SERIE,VM_NRNF,VM_NRVIA) // impressão Html - CFEP530H.PRG
			dbcloseall()
			return NIL
		end
		if pb_ligaimp(I33LPP)
		else
			dbcloseall()
			return NIL
		end
	end
	dbseek(dtos(VM_DATA[1])+str(VM_NRNF,6),.T.)
	while !eof().and.PC_DTEMI<=VM_DATA[2].and.if(empty(VM_NRNF),.T.,VM_NRNF==PC_NRNF)
		if PC_FLAG.and.VM_SERIE==PC_SERIE
			CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
			@20,22 say 'Nr da Duplicata...: '+transform(PC_NRDPL,masc(16))
			@21,22 say 'Cliente...........: '+transform(PC_CODCL,masc(04))+'-'+left(CLIENTE->CL_RAZAO,20)
			DPLS:={}
			salvabd(SALVA)
			select('DPCLI')
			dbseek(str(PEDCAB->PC_NRNF,9)+PEDCAB->PC_SERIE,.T.)
			while !eof().and.PEDCAB->PC_NRNF==DR_NRNF.and.PEDCAB->PC_SERIE==DR_SERIE
				aadd(DPLS,{DR_DUPLI,DR_DTVEN,DR_VLRDP,DR_VLRPG})
				dbskip()
			end
			salvabd(RESTAURA)
			if P1==1
				CFEP5300D(PC_CODCL,CLIENTE->CL_RAZAO,DPLS,PC_DTEMI) // Impr. Duplicata
				if reclock()
					replace PC_FLDUP with .T.
				end
			else
				fn_impcarne(PEDCAB->PC_CODCL,CLIENTE->CL_RAZAO,DPLS,PEDCAB->PC_DTEMI) //Carnes
			end
		end
		pb_brake()
	end
	if P1==1
		eject
		pb_deslimp(I66LPP)
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEP5300D(P1,P2,P3,P4)
*-----------------------------------------------------------------------------*
local ORD
local X
VM_LAR:=80
MOEDA :=0 // 0=CR$ // 1=URV
for ORD:=1 to len(P3) // Até número de parcelas
	for X:=1 to VM_NRVIA
		CFEP5300I(P1,P2,P3[ORD],P4)
	end
next
return NIL

*-----------------------------------------------------------------------------*
function CFEP5300I(P1,P2,P3,P4)
*-----------------------------------------------------------------------------*
local VM_VLR:=P3[3]-P3[4] // Valor
local VM_EXT:=pb_extenso(VM_VLR)
VM_EXT:=padr('('+VM_EXT+')',150,'*')

? I15CPP
//...linha 1
??space(5)+padr(VM_EMPR,55)
??space(6)+padr(trim(PARAMETRO->PA_ENDER)+','+trim(PARAMETRO->PA_ENDNRO),55)
//...linha 2
? space(5)+padr('CNPJ: '+transform(PARAMETRO->PA_CGC,masc(18))+space(5)+'Inscr Est.'+PARAMETRO->PA_INSCR,55)
??space(6)+transform(PARAMETRO->PA_CEP,masc(10))+space(5)+PARAMETRO->PA_CIDAD+space(5)+PARAMETRO->PA_UF
//...linha 3
? space(5)+padc('Fone: '+trim(PARAMETRO->PA_FONE)+space(5)+'Fax: '+trim(PARAMETRO->PA_FAX),55)+C15CPP

? replicate('-',VM_LAR)
? padc('FATURA ('+left(pb_zer(P3[1],9),7)+')'+space(5)+'Data de Emissao :'+dtoc(P4),VM_LAR,'.')
? replicate('-',VM_LAR)
? INEGR+padr('Duplicata',12,'.')+':'+transform(P3[1],masc(16))
??space(4)+'Data Vencto :'+dtoc(P3[2])
??space(4)+'Valor: '+transform(P3[3],masc(2))+CNEGR
? 
if P3[4]>0
	?space(5)+padc('Pgtos Parciais.: '+transform(P3[4],masc(2))+space(4)+'Valor Liquido..: '+transform(P3[3]-P3[4],masc(2)),VM_LAR)
	?
end
? padr('Nome Cliente' ,15,'.')+': '+pb_zer(P1,6)+'-'+P2
? padr('Endereco',15,'.')+': '+CLIENTE->CL_ENDER+space(01)+I15CPP+left(CLIENTE->CL_BAIRRO,26)+C15CPP
? padr('Cidade',  15,'.')+': '+CLIENTE->CL_CIDAD+space(13)+'CEP : '+pb_zer(CLIENTE->CL_CEP,8)+'-'+CLIENTE->CL_UF
if len(trim(CLIENTE->CL_CGC))>12 // CNPJ
	? padr('C.N.P.J.',15,'.')+': '+transform(CLIENTE->CL_CGC,masc(18))+space(4)
	??' Inscricao Estadual : '+CLIENTE->CL_INSCR
else
	? padr('C.P.F',   15,'.')+': '+transform(CLIENTE->CL_CGC,masc(17))+space(4)
	??'Carteira Identidade: '+CLIENTE->CL_INSCR
end
?padc('Valor por Extenso',VM_LAR,'.')
?padc(left(VM_EXT,50),VM_LAR)
?padc(substr(VM_EXT,51,50),VM_LAR)
?padc(right(VM_EXT,50),VM_LAR)
?replicate('.',VM_LAR)
VM_EXT ='Reconheco(cemos) a exatidao desta duplicata de venda mercantil '
VM_EXT+='na importancia acima mencionada, que pagarei(emos) a '
VM_EXT+=INEGR+trim(VM_EMPR)+CNEGR+' ou a sua ordem.'
VM_EXT:=padr(VM_EXT,210)
?padc(  left(VM_EXT,70),VM_LAR)
?padc(substr(VM_EXT,71,70),VM_LAR)
?padc( right(VM_EXT,70),VM_LAR)
?
?padc('NA FALTA DE PAGAMENTO SERAO COBRADOS JUROS DE '+transform(PARAMETRO->PA_PJUROS,masc(20))+'% ao Mes, DESPESAS BANCARIAS.',VM_LAR)
?
?
?space(10)+'EM ____/____/____'+space(15)+replicate('_',35)
?space(13)+'Data do aceite'+space(15)+padc('Assinatura do Sacado',35)
eject
return NIL

//----------------------------------------------------------------------------------
	function FN_CHKDPLS()
//----------------------------------------------------------------------------------
local RT:=.T.
if PC_FLDUP
	beeperro()
	RT:=pb_sn('Duplicata j  impressa. Continuar ?')
elseif PC_FATUR==0
	alert('Nota Fiscal ‚ a vista.')
	RT:=.F.
end
return(RT)
//---------------------------------EOF---------------------------------------------
