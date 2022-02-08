*-----------------------------------------------------------------------------*
function CFEPEMIT(P1) // Listagem de NF-E - Emitidas de Entrada					*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

private VM_CPO:={'S','N','N', , ,'N',0,0,0,3,2}
//                1   2   3  4 5  6  7 8 9 0,1

VM_REL:='NF Entradas Emitidas em'

pb_lin4(VM_REL,ProcName())

if !abre({	'R->PROD',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->ENTCAB',;
				'R->ENTDET',;
				'R->NATOP',;
				'R->DPFOR',;
				'R->HISFOR'})
	return NIL
end

select DPFOR
ORDEM FORDTV // Ordem Fornecedor
select PROD
dbsetorder(2)	// Cadastro de Produtos

VM_CPO[4]:=bom(PARAMETRO->PA_DATA)
VM_CPO[5]:=PARAMETRO->PA_DATA
pb_box(17,20,,,,'NF Entradas - Selecione')
@18,22 say '[A]nalitico [S]intetico:' get VM_CPO[1] pict masc(1)  valid VM_CPO[1]$'AS'
@19,22 say 'Totalizar Data Emiss„o ?' get VM_CPO[2] pict masc(1)  valid VM_CPO[2]$'SN'
@20,22 say 'Data Emissao Inicial...:' get VM_CPO[4] pict masc(7)
@21,22 say 'Data Emissao Final.....:' get VM_CPO[5] pict masc(7)  valid VM_CPO[5]>=VM_CPO[4]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_LAR:=132
	VM_PAG:=0
	VM_REL+= ' de '+dtoc(VM_CPO[4])+' ate '+dtoc(VM_CPO[5])
	select ENTCAB
	ORDEM DTEDOC
	dbseek(dtos(VM_CPO[4]),.T.) // Data Inicial
	TOTALG:={0,0,0} // total geral
	while !eof().and.EC_DTEMI<=VM_CPO[5]
		CFEPEMIT1(P1)
	end
	?replicate('-',VM_LAR)
	? space(25)+padr('TOTAL DO GERAL',52,'.')
	??space(01)+ transform(TOTALG[1],masc(2))
	??space(01)+ transform(TOTALG[2],masc(2))
	??space(01)+ transform(TOTALG[3],masc(2))+' '
	??transform(pb_divzero(TOTALG[2],TOTALG[1])*100,masc(20))
	?replicate('-',VM_LAR)
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
function CFEPEMIT1(P1)
*----------------------------------------------------------------------------*
local VM_DTEMI:=EC_DTEMI
local TOTALD  :={0,0,0}	// total dia
local TOTALN  :={0,0,0}	// total nf 
VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,'CFEPEMIT',VM_REL,VM_PAG,'CFEPEMITC',VM_LAR)
while !eof() .and. ENTCAB->EC_DTEMI==VM_DTEMI
	NATOP->(dbseek(str(ENTCAB->EC_CODOP,7)))
	cNFProp:=if(right( pb_zer(ENTCAB->EC_CODOP,7),1)=='9','S','N')
	if !EC_NFCAN .and. cNFProp=='S'
		TOTALN:={0,0,0}	// Total NF
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,'CFEPEMIT',VM_REL,VM_PAG,'CFEPEMITC',VM_LAR)
		TOTALN[1]:=ENTCAB->EC_TOTAL-ENTCAB->EC_DESC						// Liquido da NF
		if ENTCAB->EC_FATUR==0 // a vista
			TOTALN[2]+=TOTALN[1]	// VLRS da Vista
		else
			//------------------------------VERIFICAR EM DUPLICATA PENDENTE
			salvabd(SALVA)
			select DPFOR
			dbseek(str(ENTCAB->EC_CODFO,5),.T.)
			while !eof().and.ENTCAB->EC_CODFO==DPFOR->DP_CODFO
				if DP_SERIE+str(DP_NRNF,9)==ENTCAB->EC_SERIE+str(ENTCAB->EC_DOCTO,9)
					if DP_DTVEN==VM_DTEMI // parte a vista
						TOTALN[2]+=DP_VLRDP
					else
						TOTALN[3]+=DP_VLRDP	// parte a prazo
					end
				end
				dbskip()
			end
			//------------------------------VERIFICAR EM DUPLICATA PAGAS
			select HISFOR
			dbseek(str(ENTCAB->EC_CODFO,5),.T.)
			while !eof().and.ENTCAB->EC_CODFO==HF_CODFO
				if HF_SERIE+str(HF_NRNF,9)==ENTCAB->EC_SERIE+str(ENTCAB->EC_DOCTO,9)
					if HF_DTVEN==VM_DTEMI // parte a vista
						TOTALN[2]+=HF_VLRPG
					else
						TOTALN[3]+=HF_VLRPG	// parte a prazo
					end
				end
				dbskip()
			end
			salvabd(RESTAURA)
		end
		CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
		? space(01)+pb_zer(ENTCAB->EC_DOCTO,8)
		??space(01)+transform(ENTCAB->EC_DOCTO*100,masc(16))
		??space(01)+pb_zer(ENTCAB->EC_CODFO,5)+'-'+left(CLIENTE->CL_RAZAO,38)
		??space(01)+transform(ENTCAB->EC_DTEMI,masc(7))
		??space(01)+str(ENTCAB->EC_FATUR,2)
		??space(01)+transform(TOTALN[1],masc(50))
		??space(01)+transform(TOTALN[2],masc(50))
		??space(01)+transform(TOTALN[3],masc(50))
		??if(ENTCAB->EC_NFCAN,'C',' ')
		??transform(pb_divzero(TOTALN[2],TOTALN[1])*100,masc(20))

		if VM_CPO[1]=='A'
			VM_DOCTO:=ENTCAB->EC_DOCTO
			VM_FATUR:=ENTCAB->EC_FATUR // 0=Vista , 1,2,3...=Prazo
			select('ENTCAB')
			dbseek(str(VM_DOCTO,8),.T.)
			while !eof().and.VM_DOCTO==ENTCAB->EC_DOCTO
				PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,'CFEPEMIT',VM_REL,VM_PAG,'CFEPEMITC',VM_LAR)
				? space(35)+     pb_zer(PEDDET->ED_ORDEM,2)
				??space(01)+padl(pb_zer(PEDDET->ED_CODPR,L_P)+'-'+PROD->PR_DESCR,50)
				??space(02)+  transform(PEDDET->ED_QTDE, masc(6))
				??space(01)+  transform(PEDDET->ED_VALOR,masc(2))
				dbskip()
			end
			select('PEDCAB')
		end
		TOTALD[1]+=TOTALN[1]
		TOTALD[2]+=TOTALN[2]
		TOTALD[3]+=TOTALN[3]
	end
	pb_brake()
end
if VM_CPO[2]=='S'
	? space(25)+padr('Total do Dia',54,'.')
	??space(01)+transform(TOTALD[1],masc(50))
	??space(01)+transform(TOTALD[2],masc(50))
	??space(01)+transform(TOTALD[3],masc(50))+' '
	??transform(pb_divzero(TOTALD[2],TOTALD[1])*100,masc(20))
	?
end
TOTALG[1]+=TOTALD[1]
TOTALG[2]+=TOTALD[2]
TOTALG[3]+=TOTALD[3]
return NIL

*-----------------------------------------------------------------------------*
 function CFEPEMITC()
*-----------------------------------------------------------------------------*
?' N.Fiscal  Nr Duplic '+ padr('Fornecedor',45)+'Dt Emiss   Pc   Vlr Total NF    Pagto Vista    Vlr a Prazo %Vista'
if VM_CPO[1]='A'
	? space(35)+'Item '+padr('Produtos',52)
	??'Qtidade     Valor Total'
end
?replicate('-',VM_LAR)
return NIL
*-----------------------------------------------------------------------------*
