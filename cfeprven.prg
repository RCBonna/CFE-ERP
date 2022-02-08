*-----------------------------------------------------------------------------*
 static aVariav := {0,{}}
 //.................1..2...3...4...5..6...7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate aOPC       => aVariav\[  2 \]

*-----------------------------------------------------------------------------*
	function CFEPRVEN(P1) // Listagem de Vendas												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={0,'dt1','dt2', , ,0, ,'T',0,3,2}
//       1   2      3  4  56  7 8  9 0,1

VM_REL:='Vendas por Produto/Periodo'

pb_lin4(VM_REL,ProcName())

if !abre({	'R->PROD',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->HISCLI',;
				'R->NATOP',;
				'R->DPCLI',;
				'R->GRUPOS'})
	return NIL
end
select('PROD')
dbsetorder(2)	// Cadastro de Produtos

select('PEDCAB')
ordsetfocus('DTEPED')
DbGoTop()

ARQ:=ArqTemp(,,'')
dbcreate(ARQ,{ {'RV_CODPR','N',L_P,0},;
					{'RV_CODGE','N',  6,0},;
					{'RV_DESCR','C', 30,0},;
					{'RV_QTVEN','N', 12,2},;
					{'RV_VLVEN','N', 15,2},;
					{'RV_VLCUS','N', 15,2}})
if !net_use(ARQ, .T. , ,'RELVENDAS', ,.F.,RDDSETDEFAULT())
	dbcloseall()
	return NIL
end
select('RELVENDAS')
Index on str(RV_CODPR,L_P)  tag CODIGO_PROD to (ARQ)	//....1

aOPC:={	'CODIGO_PROD',;
			'GRUPO_PROD',;
			'GRUPO_ALFA',;
			'ALFABETICA',;
			'VLR_DECRES',;
			'QTD_DECRES'}

//Index on str(RV_CODGE,6)+str(RV_CODPR,L_P) tag GRUPO_PROD  to (ARQ)	//...2
//Index on str(RV_CODGE,6)+upper(RV_DESCR)   tag GRUPO_ALFA  to (ARQ)	//...3
//Index on upper(RV_DESCR)                   tag ALFABETICA  to (ARQ)	//...4
//Index on descend(str(RV_VLVEN,15,2))       tag VLR_DECRES  to (ARQ)	//...5
//Index on descend(str(RV_QTVEN,15,2))       tag QTD_DECRES  to (ARQ)	//...6
//Index on substr(str(RV_CODGE,6),3,2)+upper(RV_DESCR)  tag SUB_GRUPO_ALFA  to (ARQ)	//...7

VM_TIPO  :=restarray('ESTOQUE.ARR')
VM_CPO[2]:=bom(PARAMETRO->PA_DATA)
VM_CPO[3]:=PARAMETRO->PA_DATA
VM_COMPAR:='C'
VM_CTB  :=0
pb_box(12,20,,,,'Selecione')
@16,53 say '<0> para todos'
@15,53 say 'C=custo M=medio'
@13,53 say 'T=Total V=Vista P=Prazo'
@13,22 say 'Faturamento............:' get VM_CPO[8] pict masc(01) valid VM_CPO[8]$'TVP'
@14,22 say 'Ordem de Impressao.....:' get VM_CPO[1] pict masc(11) valid fn_selord() when pb_msg('Ordem de Impressao do Relatorio')
@15,22 say 'Comparar Venda com.....:' get VM_COMPAR pict masc(01) valid VM_COMPAR$'CM' when pb_msg('Comprar preco de venda com <C>usto <M>edio')
@16,22 say 'Tipo Estoque...........:' get VM_CTB    pict masc(11) valid if(VM_CTB>0,fn_codar(@VM_CTB,'ESTOQUE.ARR'),.T.) when pb_msg('Informe Tipo estoque ou Zero para Todos')
@17,22 say 'Data Emissao Incial....:' get VM_CPO[2] pict masc(07)
@18,22 say 'Data Emissao Final.....:' get VM_CPO[3] pict masc(07) valid VM_CPO[3]>=VM_CPO[2]

read
if lastkey()#K_ESC
	if VM_CTB>0
		VM_TIPO:=VM_TIPO[ascan(VM_TIPO,{|DET|DET[1]==VM_CTB}),2]
	end
	nX:=0
	if VM_CPO[1]==1
		VM_CPO[4]:='Codigo'
		VM_CPO[5]:=masc(21)
		VM_CPO[6]:=0
		VM_CPO[7]:=9999999
		
	elseif VM_CPO[1]==2
		VM_CPO[4]:='Grupo'
		VM_CPO[5]:=masc(19)
		VM_CPO[6]:=0
		VM_CPO[7]:=999999
//		Index on str(RV_CODGE,6)+str(RV_CODPR,L_P) tag GRUPO_PROD  to (ARQ)
		
	elseif VM_CPO[1]==3
		VM_CPO[4]:='Grupo'
		VM_CPO[5]:=masc(19)
		VM_CPO[6]:=0
		VM_CPO[7]:=999999
//		Index on str(RV_CODGE,6)+upper(RV_DESCR)   tag GRUPO_ALFA  to (ARQ)
		
	elseif VM_CPO[1]==4
		VM_CPO[4]:='Alfabetico'
		VM_CPO[5]:=masc(01)
		VM_CPO[6]:='          '
		VM_CPO[7]:='ZZZZZZZZZZ'
//		Index on upper(RV_DESCR)                   tag ALFABETICA  to (ARQ)
		
	elseif VM_CPO[1]==5
		VM_CPO[4]:='Valor Tot.'
		VM_CPO[5]:=masc(02)
		VM_CPO[6]:=0
		VM_CPO[7]:=9999999999.99
		Index on descend(str(RV_VLVEN,15,2))       tag VLR_DECRES  to (ARQ)

	elseif VM_CPO[1]==6
		VM_CPO[4]:='Qtde Tot.'
		VM_CPO[5]:=masc(02)
		VM_CPO[6]:=0
		VM_CPO[7]:=9999999999.99
//		Index on descend(str(RV_QTVEN,15,2))       tag QTD_DECRES  to (ARQ)	//...6

	elseif VM_CPO[1]==7
		VM_CPO[4]:='Sub-Grupo'
		VM_CPO[5]:=mI2
		VM_CPO[6]:=0
		VM_CPO[7]:=99
		Index on substr(str(RV_CODGE,6),3,2)+upper(RV_DESCR)  tag SUB_GRUPO_ALFA  to (ARQ)	//...7

	end
	@20,22 say 'Selecao '+padr(VM_CPO[4]+' Inicial',15,'.') get VM_CPO[6] pict VM_CPO[5]
	@21,22 say 'Selecao '+padr(VM_CPO[4]+' Final',  15,'.') get VM_CPO[7] pict VM_CPO[5] valid VM_CPO[7]>=VM_CPO[6]
	read
	if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
		pb_msg('Calculando valores... Aguarde...')
		TOTAL:={0,0,0,0,0,0,0} // 
		ordsetfocus('CODIGO_PROD')
		CFEPRVEN0()
		pb_msg('Imprimindo ESC cancela...')
		select('RELVENDAS')
		ordsetfocus(VM_CPO[1])
		DbGoTop()
		VM_LAR:=80
		VM_PAG:=0

		if VM_CPO[1]==1 // PRODUTO
			dbseek(str(VM_CPO[6],L_P),.T.)
			while !eof().and.RV_CODPR<=VM_CPO[7]
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVENC',VM_LAR)
				CFEPRVEN1()
				dbskip()
			end
			TOTAL[1]:=TOTAL[3]
			TOTAL[2]:=TOTAL[4]
		elseif VM_CPO[1]==2 .or. VM_CPO[1]==3 // GRUPO NR . GRUPO ALFA
			if VM_CPO[1]==2
				Index on str(RV_CODGE,6)+str(RV_CODPR,L_P) tag GRUPO_PROD  to (ARQ)
			else
				Index on str(RV_CODGE,6)+upper(RV_DESCR)   tag GRUPO_ALFA  to (ARQ)
			end
			dbseek(str(VM_CPO[6],6),.T.)
			while !eof().and.RV_CODGE<=VM_CPO[7]
				VM_CPO[6]:=RV_CODGE
				GRUPOS->(dbseek(str(VM_CPO[6],6)))
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVENC',VM_LAR)
				TOTAL[3]:=0
				TOTAL[4]:=0
				?
				?transform(VM_CPO[6],masc(13))+'-'+GRUPOS->GE_DESCR
				?
				while !eof().and.RV_CODGE<=VM_CPO[7].and.VM_CPO[6]==RV_CODGE
					CFEPRVEN1()
					VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVENC',VM_LAR)
					dbskip()
				end
				? space(10)+padr('Total do Grupo Estoque',40,'.')
				??transform(TOTAL[3],masc(2))
				??transform(TOTAL[4],masc(2))
				
				TOTAL[1]+=TOTAL[3]
				TOTAL[2]+=TOTAL[4]
			end
		elseif VM_CPO[1]==4 // ALFABETICO
			Index on upper(RV_DESCR)                   tag ALFABETICA  to (ARQ)
			dbseek(VM_CPO[6],.T.)
			while !eof().and.left(RV_DESCR,10)<=VM_CPO[7]
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVENC',VM_LAR)
				CFEPRVEN1()
				dbskip()
			end
			TOTAL[1]:=TOTAL[3]
			TOTAL[2]:=TOTAL[4]
		elseif VM_CPO[1]==5 // VALOR
			Index on descend(str(RV_VLVEN,15,2))       tag VLR_DECRES  to (ARQ)
			while !eof()  // .and.str(RV_VLVEN,15,2)<=str(VM_CPO[7],15,2)
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVENC',VM_LAR)
				CFEPRVEN1()
				dbskip()
			end
			TOTAL[1]:=TOTAL[3]
			TOTAL[2]:=TOTAL[4]
		elseif VM_CPO[1]==6 // QUANTIDADE
			Index on descend(str(RV_QTVEN,15,2))       tag QTD_DECRES  to (ARQ)	//...6
			// dbseek(descend(str(VM_CPO[6],15,2)),.T.)
			while !eof()  // .and.str(RV_VLVEN,15,2)<=str(VM_CPO[7],15,2)
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVENC',VM_LAR)
				CFEPRVEN1()
				dbskip()
			end
			TOTAL[1]:=TOTAL[3]
			TOTAL[2]:=TOTAL[4]
		elseif VM_CPO[1]==7 // SUB-GRUPO
			Index on substr(str(RV_CODGE,6),3,2)+upper(RV_DESCR)  tag SUB_GRUPO_ALFA  to (ARQ)	//...7
			dbseek(pb_zer(VM_CPO[6],2),.T.)
			while !eof().and.val(substr(str(RV_CODGE,6),3,2))<=VM_CPO[7]
				VM_CPO[6]:=val(substr(str(RV_CODGE,6),3,2))
				VM_PAG   :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVENC',VM_LAR)
				TOTAL[3] :=0
				TOTAL[4] :=0
				?
				?'Sub-Grupo:'+pb_zer(VM_CPO[6],2)
				?
				while !eof().and.val(substr(str(RV_CODGE,6),3,2))<=VM_CPO[7].and.val(substr(str(RV_CODGE,6),3,2))==VM_CPO[6]
					CFEPRVEN1()
					VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVENC',VM_LAR)
					dbskip()
				end
				? space(10)+padr('Total do Sub-Grupo Estoque',40,'.')
				??transform(TOTAL[3],masc(2))
				??transform(TOTAL[4],masc(2))
				
				TOTAL[1]+=TOTAL[3]
				TOTAL[2]+=TOTAL[4]
			end
		end
		?replicate('-',VM_LAR)
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVENC',VM_LAR)
		if nX < 1
			?"Nenhum item a ser listado para esta selecao..."
			?replicate('-',VM_LAR)
		end
		if TOTAL[5]>0
			? space(8)+padr('Total Geral a Vista',42,'.')
			??transform(TOTAL[5],masc(2))
		end
		if TOTAL[6]>0
			? space(8)+padr('Total Geral a Prazo',42,'.')
			??transform(TOTAL[6],masc(2))
		end
		if TOTAL[1]+TOTAL[2]>0
			? space(8)+padr('Total do Geral Vendido',42,'.')
			??transform(TOTAL[1],masc(2))
			??transform(TOTAL[2],masc(2))
		end
		if TOTAL[7]>0.and.VM_CTB==0
			? space(8)+padr('Total de Descontos',42,'.')
			??transform(TOTAL[7],masc(2))
		end
		?replicate('-',VM_LAR)
		eject
		pb_deslimp(C15CPP)
	end
end
dbcloseall()
FileDelete (Arq + '.*')
return NIL

*----------------------------------------------------------------------------*
function FN_SELORD()
*----------------------------------------------------------------------------*
local ORD:={}
local X,TF,I:={row(),col()}
//for X:=1 to 20
//	if !empty(ordname(X))
//		aadd(ORD,ordname(X))
//	end
//next

if VM_CPO[1]<1.or.VM_CPO[1]>5
	TF:=savescreen(10,10,20,30)
	pb_box(10,12,20,30,'R/BG','Selecione Ordem')
	VM_CPO[1]:=achoice(11,13,19,29,aOPC)
	VM_CPO[1]=max(VM_CPO[1],1)
		
	restscreen(10,10,20,30,TF)
end
@I[1],I[2] say '-'+aOPC[VM_CPO[1]]
return .T.

*----------------------------------------------------------------------------*
static function CFEPRVEN0()
*----------------------------------------------------------------------------*
local VM_PROD
local VM_PCOMP
salvabd(SALVA)
select('PEDCAB')
ORDEM DTEPED
DbGoTop()
dbseek(dtos(VM_CPO[2]),.T.)
while !eof().and.PC_DTEMI<=VM_CPO[3]
	if if(VM_CPO[8]=='T',.T.,if(VM_CPO[8]=='V',PC_FATUR==0,PC_FATUR>0)).and.!PC_FLCAN.and.PC_FLAG
		@24,69 say dtoc(PC_DTEMI)
		if PC_FLAG.and.!PC_FLCAN.and.!Dev_Saida(PEDCAB->PC_CODOP).and.!Nat_Transf(PEDCAB->PC_CODOP)	// Verificar se NF é devoluçao (Não processar) e pedidos não confirmados e NF transferencias
			VM_PEDID:=PC_PEDID
			TOTAL[7]+=PC_DESC
			select('PEDDET')
			dbseek(str(VM_PEDID,6),.T.)
			while !eof().and.PEDDET->PD_PEDID==VM_PEDID
				PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
				if VM_CTB==0.or.VM_CTB==PROD->PR_CTB
					select('RELVENDAS')
					if !dbseek(str(PEDDET->PD_CODPR,L_P))
						VM_PCOMP:=PROD->PR_VLCOM
						if VM_COMPAR=='M'
							VM_PCOMP:=PEDDET->PD_VLRMD
							if str(VM_PCOMP,15,3)==str(0,15,3)
								VM_PCOMP:=abs(pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU))
								if VM_PCOMP>0
								else
									VM_PCOMP:=PROD->PR_VLCOM
								end
							end
						end
						AddRec()
						replace 	RV_CODPR with PEDDET->PD_CODPR,;
									RV_CODGE with PROD->PR_CODGR,;
									RV_DESCR with PROD->PR_DESCR,;
									RV_QTVEN with 0,;
									RV_VLVEN with 0,;
									RV_VLCUS with VM_PCOMP
					end
					replace  RV_QTVEN with RV_QTVEN+PEDDET->PD_QTDE,;
								RV_VLVEN with RV_VLVEN+;
													round((PEDDET->PD_QTDE*PEDDET->PD_VALOR)-PEDDET->PD_DESCV,2)
					if PEDCAB->PC_FATUR>0
						TOTAL[6]+=round((PEDDET->PD_QTDE*PEDDET->PD_VALOR)-PEDDET->PD_DESCV,2) // a prazo
					else
						TOTAL[5]+=round((PEDDET->PD_QTDE*PEDDET->PD_VALOR)-PEDDET->PD_DESCV,2) // a vista
					end
					select('PEDDET')
				end
				dbskip()
			end
			select('PEDCAB')
		end
	end
	dbskip()
end
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
 function CFEPRVEN1(P1)
*-----------------------------------------------------------------------------*
? padl(transform(RV_CODPR,masc(21))+space(1)+RV_DESCR,38)
??transform(RV_QTVEN,masc(05))
??transform(RV_VLVEN,masc(02))
??transform(RV_VLCUS,masc(02))
TOTAL[3]+=RV_VLVEN
TOTAL[4]+=RV_VLCUS
nX++
return NIL

*-----------------------------------------------------------------------------*
 function CFEPRVENC()
*-----------------------------------------------------------------------------*
?' Ref: '+dtoc(VM_CPO[2])+' ate '+dtoc(VM_CPO[3])
?
if VM_CTB>0
	?INEGR+padc('Tipo de Estoque : '+pb_zer(VM_CTB,2)+'-'+trim(VM_TIPO),VM_LAR,'.')+CNEGR
	?
end
? padr('Produto/Descricao',41)
??"Qtd Venda    Valor Venda    "
if VM_COMPAR=='M'
	??"Valor Medio"
else
	??"Valor Custo"
end
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
