*-----------------------------------------------------------------------------*
function CFEP5500(TIPO)	//	 Impressao do BOLETO/DUPLICATA							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_LIN,OPC,X:=Y:=1
private VM_EST

default TIPO to 'BOL'

pb_lin4(_MSG_,ProcName())
VM_VETOR:={{;
				'',;//..........................1,1=Nome
				padr(if(TIPO=='BOL','Boleto','Duplicata')+' Padrao',20),;//....1,2=Descricao
				01,;//..........................1,3=Num Fileiras
				24,;//..........................1,4=Num Linhas
				01,;//..........................1,5=Dist Horizontal
				01,;//..........................1,6=Dist Vertical
				66,;//..........................1,7=Tamanho
				'N ';//.........................1,8=Normal/Comprimido
			 },;
			 {};//..................<<<<Lay-Out>>>>
		  }

ARQUIVOS:={}
OPC     :=fn_arqs(TIPO) // Seleciona e Inclui boletos

if OPC==0.or.!abre({	'R->OBS',;
							'C->BANCO',;
							'R->CLIENTE',;
							'C->DPCLI',;
							'R->PEDCAB'})
	return NIL
end

if pb_ligaimp()
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
	end
	select('DPCLI')
	set relation to str(DR_CODCL,5) into CLIENTE
	select('PEDCAB')
	dbsetorder(5)
	DbGoTop()
	VM_INI:=0
	VM_OBS:=space(len(OBS->OB_DESCR))
	OBS1  :={space(40),space(40)}
	VM_LINHA=array(VM_VETOR[1,4],VM_VETOR[1,3])
	aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate('*',VM_VETOR[1,7]))})
	while pb_sn('Fazer testes ?')
		FN_IMPETI(VM_LINHA,VM_VETOR[1,6],VM_VETOR[1,5]) // testes
	end
	aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate(' ',VM_VETOR[1,7]))})
	VM_BCO  :=0
	VM_NRBOL:=0
	NrDigit :=0
	while .T.
		set function 10 to '+'+chr(13)
		pb_msg('Pressione F10 no campo de Observa‡„o',NIL,.F.)
		pb_box(14)
		VM_SERIE:=space(3)
		VM_NRNF :=0
		@15,01 say 'Informe Serie...:' get VM_SERIE pict mUUU
		@16,09 say         'N§ NF...:' get VM_NRNF  pict masc(19)      valid pb_ifcod2(str(VM_NRNF,6)+VM_SERIE,NIL,.T.,5).and.fn_chkdpls().and.PEDCAB->(reclock())
		if TIPO=='BOL'
			@17,01 say 'Cod.Banco........:' get VM_BCO   pict mI2        valid fn_codigo(@VM_BCO,{'BANCO',{||BANCO->(dbseek(str(VM_BCO,2)))},{||CFEP1500T(.T.)},{2,1}})	when (VM_BCO:=PEDCAB->PC_CODBC)>=0
			@18,01 say 'N§ BOLETO INIC...:' get VM_NRBOL pict mI16       valid ChkDigtBol(VM_BCO,VM_NRBOL,@NrDigit,.T.)																	when (VM_NRBOL:=BANCO->BC_NRBOL)>=0
		end
		@19,01 say 'Observa‡„o Geral:' get VM_OBS   pict masc(1)+'S60' valid fn_obs(@VM_OBS)
		@20,01 say 'Descr Desconto..:' get OBS1[1]  pict masc(1) when pb_msg('Descricao para linha Desconto 1/2')
		@21,01 say 'Comiss Permanen.:' get OBS1[2]  pict masc(1) when pb_msg('Descricao para linha Desconto 2/2')
		read
		set function 10 to
		setcolor(VM_CORPAD)
		if if(lastkey()#K_ESC,pb_sn(),.F.)
			salvabd(SALVA)
			select('DPCLI')
			dbsetorder(6)
			dbseek(str(VM_NRNF,9)+VM_SERIE,.T.)
			Y=1
			while !eof().and.VM_NRNF==DR_NRNF.and.VM_SERIE==DR_SERIE
				@23,01 say 'Cliente :'+left(CLIENTE->CL_RAZAO,20)+;
				           ' Duplicata :'+transform(DR_DUPLI,masc(16))+;
							  ' Valor :'+transform(DR_VLRDP,masc(2))
				VM_EXT:=padr('('+pb_extenso(DR_VLRDP)+')',150,'*')
				VM_ULTNF:=PEDCAB->PC_NRNF
				for X=1 to VM_VETOR[1,4]
					VM_LINHA[X,Y]=padr(CFEPCODI(VM_VETOR[2,X,1]),VM_VETOR[1,7])
				next
				if Y=VM_VETOR[1,3]
					FN_IMPETI(VM_LINHA,VM_VETOR[1,6],VM_VETOR[1,5]) // testes
					aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate(' ',VM_VETOR[1,7]))})
				end
				if TIPO=='BOL'
					if RecLock()
						replace DR_NRBOL with VM_NRBOL
						VM_NRBOL:=VM_NRBOL+10
						// FALTA CALCULAR DIGITO
						dbrunlock(recno())
					end
				end
				pb_brake()
			end
			if TIPO=='BOL'
				select BANCO
				if RecLock()
					replace BC_NRBOL with VM_NRBOL
				end
			end
			salvabd(RESTAURA)
		else
			exit
		end
	end
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function ChkDigtBol(pBCO,pNRBOL,rNrDigit,lTipo)
*............................................T=Verificar
*............................................F=Retornar digito
*-----------------------------------------------------------------------------*



return .T.
*-----------------------------------------------------------------------------*EOF*
