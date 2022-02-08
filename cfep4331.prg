*-----------------------------------------------------------------------------*
         static QETIQ:=0
function CFEP4331(VM_P1)	//	Emissao Etiquetas
*						VM_P1=1=Grupo ALFA
*						VM_P1=2=Produto
*						VM_P1=3=Entradas
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_LIN,OPC,X1,X:=Y:=1
local VM_CAMPO:=''
default VM_P1 to 0
QETIQ:=0
pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({	'R->GRUPOS',;
				'R->PARAMETRO',;
				'R->MOVEST',;
				'R->PROD'})
	return NIL
end
if VM_P1<1.or.VM_P1>3
	alert('Programa implantado incorretamente')
	dbcloseall()
	return NIL
end
select('PROD')
if VM_P1==1
	ordem GRUALF
	VM_CAMPO:='PROD->PR_CODGR'
elseif VM_P1==2
	ordem CODIGO
	VM_CAMPO:='PROD->PR_CODPR'
elseif VM_P1==3
	ordem CODIGO
	VM_CAMPO:='MOVEST->ME_DATA'
end
DbGoTop()
	XENT:=' '
	XSAI:='X'

scroll(6,1,21,78,0)

VM_VETOR:={{;
				'',;//..........................1,1=Nome
				padr('Etiqueta Padrao',20),;//..1,2=Descricao
				02,;//..........................1,3=Num Fileiras
				05,;//..........................1,4=Num Linhas
				01,;//..........................1,5=Dist Horizontal
				01,;//..........................1,6=Dist Vertical
				50,;//..........................1,7=Tamanho
				'N ';//.........................1,8=Normal/Comprimido
			 },;
			 {};//..................<<<<Lay-Out>>>>
		  }
				
ARQUIVOS:={}
OPC     :=fn_arqs('ETI') // Seleciona e Inclui boletos
if OPC=0
	dbcloseall()
	return NIL
end

pb_tela()
if VM_P1 # 3
	dbgobottom();VM_FIM=&(fieldname(VM_P1))
	DbGoTop();   VM_INI=&(fieldname(VM_P1))
else
	VM_INI:=date()
	VM_FIM:=date()
end
VM_DOCTO:={0,999999}
VM_NRE  :={1,   999}
VM_OBS  :=space(132)
VM_FLAG :='S'
VM_NRLIT:=3
pb_box(10,0,18,79,,'Op‡äes de Etiqueta-Comun')
if VM_P1=1 // por grupo
	@11,02 say padr('Informe Grupo Inicial',27) get VM_INI picture masc(13) valid VM_INI%10000#0.and.fn_codigo(@VM_INI,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_INI,6)))},,{2,1}})
	@12,02 say padr('Final',27)                 get VM_FIM picture masc(13) valid VM_INI%10000#0.and.fn_codigo(@VM_FIM,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_FIM,6)))},,{2,1}}).and.VM_FIM>=VM_INI
elseif VM_P1==2
	@11,02 say 'Informe Produto Inicial..:' get VM_INI picture masc(21) valid fn_codpr(@VM_INI,77).and.fn_rtunid(VM_INI)
	@12,18 say 'Final....:'                 get VM_FIM picture masc(21) valid fn_codpr(@VM_FIM,77).and.fn_rtunid(VM_FIM).and.VM_FIM>=VM_INI
elseif VM_P1==3
	@11,02 say 'Movimento de Data inicial:' get VM_INI pict mDT when pb_msg('Informe data de entrada de produtos do mes')
	@12,18 say 'Final....:'                 get VM_FIM pict mDT valid VM_INI<=VM_FIM
	@11,50 say 'Docto Ini:' get VM_DOCTO[1] valid VM_DOCTO[1]>=0 pict mI6
	@12,50 say 'Docto.Fin:' get VM_DOCTO[2] valid VM_DOCTO[2]>=VM_DOCTO[1] pict mI6
end
@14,50 say '<999=Qtdade de Produtos>' color 'W/R'
@14,02 say 'N§ Etiquetas por Produto.:' get VM_NRE[1] pict masc(12) valid VM_NRE[1]>0
@15,02 say 'Limite Etiq  por Produto.:' get VM_NRE[2] pict masc(12) valid VM_NRE[2]>0 when VM_NRE[1]==999
@16,02 say 'Lista s¢ Produtos com Qtd:' get VM_FLAG   pict masc(01) valid VM_FLAG$'SN'
@17,02 say 'Nr Linha no Topo Folha...:' get VM_NRLIT  pict masc(12) valid VM_NRLIT>=0
read
setcolor(VM_CORPAD)
if lastkey()#K_ESC
	VM_FLAG :=(VM_FLAG=='S')
	VM_FLAGX:=.F.
	if pb_ligaimp(C15CPP)
		if left(VM_VETOR[1,8],1)=='N'
			??C15CPP
		elseif left(VM_VETOR[1,8],1)=='C'
			??I15CPP
		elseif left(VM_VETOR[1,8],1)=='S'
			??I20CPP
		end
		if right(VM_VETOR[1,8],1)=='6'
			??I6LPP
		elseif right(VM_VETOR[1,8],1)=='8'
			??I8LPP
		elseif right(VM_VETOR[1,8],1)=='?'
			??chr(27)+'8' // DISAB FIM DE PAPEL
			??chr(27)+'A'+chr(5) // TAMANHO
//			??chr(27)+'C0'+chr(12)
			VM_FLAGX:=.T.
		end
		while VM_NRLIT>0
			VM_NRLIT--
			?
		end
		VM_LINHA:=array(VM_VETOR[1,4],VM_VETOR[1,3])
		aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate('*',VM_VETOR[1,7]))})
		while pb_sn('Fazer Testes ?')
			FN_IMPETI(VM_LINHA,VM_VETOR[1,5],VM_VETOR[1,6]) // testes
			pagina()
		end
		
		aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate(' ',VM_VETOR[1,7]))})
		//---------------------------INICIALIZACAO
		Y:=1
		if VM_P1==1
			dbseek(str(VM_INI,6),.T.)
		elseif VM_P1==2
			dbseek(str(VM_INI,L_P),.T.)
		elseif VM_P1==3
			select('MOVEST')
			ORDEM DTPROE // entrada por data e produto
			set filter to  MOVEST->ME_DCTO>=VM_DOCTO[1].and.;
								MOVEST->ME_DCTO<=VM_DOCTO[2].and.FilMovEst()
			SET OPTIMIZE   	ON		// otimização de filtros (SET FILTER TO)
			dbseek(dtos(VM_INI),.T.)
		end
		while !eof().and.&(VM_CAMPO)<=VM_FIM
			GRUPOS->(dbseek(str(PROD->PR_CODGR,6)))
			if VM_P1==3
				PROD->(dbseek(str(MOVEST->ME_CODPR,L_P)))
				VM_QTD:=ME_QTD
			else
				VM_QTD:=PROD->PR_QTATU
			end
			if if(VM_FLAG,VM_QTD>0,.T.).and.PROD->PR_IMPET$' S'
				VM_NRE1:=if(VM_NRE[1]==999,min(VM_QTD,VM_NRE[2]),VM_NRE[1])
				for X1:=1 to VM_NRE1
					for X:=1 to VM_VETOR[1,4]
						alert(VM_VETOR[2,X,1])
						VM_LINHA[X,Y]:=padr(CFEPCODI(VM_VETOR[2,X,1]),VM_VETOR[1,7])
					next
					if Y==VM_VETOR[1,3]
						FN_IMPETI(VM_LINHA,VM_VETOR[1,5],VM_VETOR[1,6]) // testes
						pagina()
						aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate(' ',VM_VETOR[1,7]))})
						Y:=0
					end
					Y++
				next
			end
			pb_brake()
		end
		pagina()
		FN_IMPETI(VM_LINHA,VM_VETOR[1,5],VM_VETOR[1,6]) // testes
		pb_deslimp(RST)
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 static function PAGINA()
*-----------------------------------------------------------------------------*
local x
if VM_FLAGX
	QETIQ++
	if QETIQ>10
		QETIQ:=0
		EJECT
		for X:=1 to 3
			?
		next
	end
end
return NIL
//---------------------------------------------------EOF-----------------------