*-----------------------------------------------------------------------------*
function CFEPPDDR()	//	Digitacao e Impressao de Pedidos Diretos					*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'R->PARAMETRO',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->CLIENTE'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
pb_box()
VM_FORNEC:=0
VM_CLIENT:=0
@06,01 say 'Emitente.....:' get VM_FORNEC pict masc(4) valid fn_codigo(@VM_FORNEC,{'CLIENTE',{||dbseek(str(VM_FORNEC,5))},{||CFEP3100T(.T.)},{2,1,3,4,5,6}})
read
if lastkey()#27
	@07,01 say 'Endere‡o.....: '+CLIENTE->CL_ENDER+' '+trim(CLIENTE->CL_CIDAD)+'/'+CLIENTE->CL_UF
	VM_ATT :=padr(CLIENTE->CL_CONTAT,60)
	VM_DATA:=PARAMETRO->PA_DATA
	VM_OBS :={}
	for VM_OPC=1 to 3
		aadd(VM_OBS,{0,; // ..........................Cliente
						 'Pedido.......:'+space(50),;	//..2
						 'Produto......:'+space(50),;	//..3
						 'Codigo.......:'+space(50),;	//..4
						 'Quantidade...:'+space(50),;	//..5
						 'Preco........:'+space(50),;	//..6
						 'Pagamento....:'+space(50),;	//..7
						 'local Entrega:'+space(50)})	//..8
	next
	aadd(VM_OBS,{padc('Autor',50)})
	if file('PDDR_OBS.ARR')
		VM_OBS:=restarray('PDDR_OBS.ARR')
		VM_OBS[1,1]:=0
		VM_OBS[2,1]:=0
		VM_OBS[3,1]:=0
	end
	@08,01 say 'ATT Sr(a)....:' get VM_ATT
	read
	while lastkey()#K_ESC
		VM_OPC:=alert('Selecione uma Op‡„o ... ',{'Cliente 1','Cliente 2','Cliente 3','FIM'},'W+/R')
		if VM_OPC=4.or.VM_OPC=0
			exit
		end
		fn_edped(VM_OPC)
	end
	if lastkey()#K_ESC
		@21,01 say 'Data.:' get VM_DATA
		@21,20 say 'Autor:' get VM_OBS[4,1]
		read
	end
	if if(lastkey()#27,pb_ligaimp(RST),.F.)
		savearray(VM_OBS,'PDDR_OBS.ARR')
		?'De :'+VM_EMPR
		?'P/ :'+CLIENTE->CL_RAZAO
		?
		?'Att.Sr(a) : '+VM_ATT
		?
		for VM_OPC=1 to 3
			if VM_OBS[VM_OPC,1]>0
				CLIENTE->(dbseek(str(VM_OBS[VM_OPC,1],5)))
				?VM_OBS[VM_OPC,2]
				?space(5)+'Cliente...: '+CLIENTE->CL_RAZAO
				?space(5)+'Endereco..: '+CLIENTE->CL_ENDER
				?space(5)+'Bairro....: '+CLIENTE->CL_BAIRRO+' CEP :'+CLIENTE->CL_CEP
				?space(5)+'Cidade....: '+CLIENTE->CL_CIDAD+' / '+CLIENTE->CL_UF
				?space(5)+'CNPJ/CPF..: '+transform(CLIENTE->CL_CGC,masc(if(len(CLIENTE->CL_CGC)>12,18,17)))+' I.E.: '+CLIENTE->CL_INSCR
				?space(5)+'Fone......: '+CLIENTE->CL_FONE
				?space(5)+VM_OBS[VM_OPC,3]
				?space(5)+VM_OBS[VM_OPC,4]
				?space(5)+VM_OBS[VM_OPC,5]
				?space(5)+VM_OBS[VM_OPC,6]
				?space(5)+VM_OBS[VM_OPC,7]
				?space(5)+VM_OBS[VM_OPC,8]
				?
			end
		next
		?trim(PARAMETRO->PA_CIDAD)+'('+PARAMETRO->PA_UF+') '+pb_zer(day(VM_DATA),2)+' de '+pb_mesext(VM_DATA,'C')+' de '+str(year(VM_DATA),4)+'.'
		?
		?
		?'Atenciosamente,'
		?
		?VM_OBS[4,1]
		?
		?VM_EMPR
		?PARAMETRO->PA_ENDER
		?transform(PARAMETRO->PA_CEP,masc(10))+' - '+trim(PARAMETRO->PA_CIDAD)+' - '+PARAMETRO->PA_UF
		?'Telefone: '+trim(PARAMETRO->PA_FONE)+'  Fax: '+trim(PARAMETRO->PA_FAX)
		eject
		pb_deslimp()
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function FN_EDPED(P1)
salvacor(SALVA)
pb_box(9,0,22,79)
@9,2 say '[Opcao : '+str(P1,1)+']' color 'R/W'
VM_CLIENT:=VM_OBS[P1,1]
@10,01 say 'Cliente......:' get VM_CLIENT pict masc(4) valid fn_codigo(@VM_CLIENT,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLIENT,5)))},{||CFEP3100T(.T.)},{2,1,3,4,5,6,7}})
read
if lastkey()#27
	@11,01 say 'Endere‡o.....: '+CLIENTE->CL_ENDER + ' B:'+left(CLIENTE->CL_BAIRRO,15)
	@12,16 say CLIENTE->CL_CEP+' '+CLIENTE->CL_CIDAD +'/'+CLIENTE->CL_UF
	@13,16 say transform(CLIENTE->CL_CGC,masc(if(len(CLIENTE->CL_CGC)>12,18,17)))+' IE '+CLIENTE->CL_INSCR+' F:'+CLIENTE->CL_FONE
	@14,01 say 'Ped:'   get VM_OBS[P1,2]
	@15,01 say 'L1.:'   get VM_OBS[P1,3]
	@16,01 say 'L2.:'   get VM_OBS[P1,4]
	@17,01 say 'L3.:'   get VM_OBS[P1,5]
	@18,01 say 'L4.:'   get VM_OBS[P1,6]
	@19,01 say 'L5.:'   get VM_OBS[P1,7]
	@20,01 say 'L6.:'   get VM_OBS[P1,8]
	read
	if updated()
		VM_OBS[P1,1]=VM_CLIENT
	end
end
salvacor(RESTAURA)
return NIL
