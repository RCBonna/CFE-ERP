*-----------------------------------------------------------------------------*
function CFEPCLET()	//	Emissao Etiquetas de Clientes
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_LIN,OPC,X1,X:=Y:=1

pb_lin4(_MSG_,ProcName())
if !abre({'R->PARAMETRO','R->CLIENTE'})
	return NIL
end
scroll(6,1,21,78,0)

VM_VETOR:={{;
				'',;//..........................1,1=Nome
				padr('Etiqueta Cliente Padrao',20),;//..1,2=Descricao
				02,;//..........................1,3=Num Fileiras
				05,;//..........................1,4=Num Linhas
				01,;//..........................1,5=Dist Horizontal
				01,;//..........................1,6=Dist Vertical
				50,;//..........................1,7=Tamanho
				'N6';//.........................1,8=Normal/Comprimido
			 },;
			 {};//..................<<<<Lay-Out>>>>
		  }
				
ARQUIVOS:={}
OPC     :=fn_arqs('CLI') // Seleciona e Inclui Clientes
if OPC=0
	dbcloseall()
	return NIL
end

dbgobottom();VM_FIM:=&(fieldname(1))
DbGoTop();   VM_INI:=&(fieldname(1))
VM_TIPO :={0,99}
VM_PESS :='F'
VM_NRE  :={1,999}
VM_OBS  :=space(132)
VM_DTNAS:={ctod(''),date()}
VM_MES  :=00
pb_box(10,0,20,,,'Selecione')
@12,02 say padr('Cliente Inicial',27,'.')			get VM_INI			pict masc(04) valid VM_INI%10000#0.and.fn_codigo(@VM_INI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_INI,5)))},,{2,1}})
@13,02 say padr('Final',27,'.')						get VM_FIM			pict masc(04) valid VM_INI%10000#0.and.fn_codigo(@VM_FIM,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_FIM,5)))},,{2,1}}).and.VM_FIM>=VM_INI
@14,02 say padr('Tipo Cliente-Inicial',27,'.')	get VM_TIPO[1]		pict masc(11) valid VM_TIPO[1]>=0
@15,02 say padr('Final',27,'.')						get VM_TIPO[2]		pict masc(11) valid VM_TIPO[2]>=VM_TIPO[1]
@16,02 say padr('N§ Etiquetas',27,'.')				get VM_NRE[1]		pict masc(12) valid VM_NRE[1]>0
@17,02 say padr('Tipo Pessoa <TFJ>',27,'.')		get VM_PESS			pict masc(01) valid VM_PESS$'TFJ'	    when pb_msg('Pessoa <T=Todos> <F=Fisica> <J=Juridica>')
@18,02 say padr('Dt.Nasc-Inicial',27,'.')			get VM_DTNAS[1]   pict mDT										    when VM_PESS$'TF'
@19,02 say padr('Dt.Nasc-Final',27,'.')			get VM_DTNAS[2]   pict mDT valid VM_DTNAS[1]<=VM_DTNAS[2] when VM_PESS$'TF'
read
setcolor(VM_CORPAD)
if lastkey()#K_ESC
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
		end
		VM_LINHA=array(VM_VETOR[1,4],VM_VETOR[1,3])
		aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate('*',VM_VETOR[1,7]))})
		while pb_sn('Fazer testes ?')
			FN_IMPETI(VM_LINHA,VM_VETOR[1,5],VM_VETOR[1,6]) // testes
		end
		dbseek(str(VM_INI,5),.T.)
		aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate(' ',VM_VETOR[1,7]))})
		Y:=1
		while !eof().and.&(fieldname(1))<=VM_FIM
			if CL_ATIVID>=VM_TIPO[1].and.;
				CL_ATIVID<=VM_TIPO[2].and.;
				CL_DTNAS>=VM_DTNAS[1].and.;
				CL_DTNAS<=VM_DTNAS[2].and.;
				if(VM_PESS=='T',.T.,;
				if(VM_PESS=='F',len(trim(CL_CGC))<12,;
				if(VM_PESS=='J',len(trim(CL_CGC))>12,.F.)))
				for X1:=1 to VM_NRE[1]
					for X:=1 to VM_VETOR[1,4]
						VM_LINHA[X,Y]=padr(CFEPCODI(VM_VETOR[2,X,1]),VM_VETOR[1,7])
					next
					if Y=VM_VETOR[1,3]
						FN_IMPETI(VM_LINHA,VM_VETOR[1,5],VM_VETOR[1,6]) // testes
						aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate(' ',VM_VETOR[1,7]))})
						Y:=0
					end
					Y++
				next
			end
			pb_brake()
		end
		FN_IMPETI(VM_LINHA,VM_VETOR[1,5],VM_VETOR[1,6])
		pb_deslimp(RST)
	end
end
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*
