*-----------------------------------------------------------------------------*
function CFEPSPCR() // Registro no SPC														*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#define SIM ' Env '
#define NAO '     '

local ENVIOS:={},X

private VM_DET,VM_CODIG,VM_DATAE
if !abre({	'R->PARAMETRO',;
				'R->BANCO',;
				'R->CTACTB',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'R->DPCLI',;
				'R->HISCLI',;
				'R->DIARIO'})
	return NIL
end
select('DPCLI');dbsetorder(5)
select('CLIENTE')
pb_tela()
pb_lin4(_MSG_,ProcName())
VM_CODIG:=0
VM_DATAA:={ctod(''),bom(PARAMETRO->PA_DATA-30)-1}
VM_DATAE:=PARAMETRO->PA_DATA
VM_REREG:='N'
scroll(06,01,21,78)
@05,32 say 'N§Cadastro SPC '+str(PARAMETRO->PA_NRASPC,6) color 'R/W'
@06,02 say 'Data envio documento ao SPC'        get VM_DATAE picture masc(7)
@06,40 say 'Verificar Clientes j  Registrados ' get VM_REREG picture masc(1) valid VM_REREG$'SN'
@07,02 say 'Dupls atrasadas de'                 get VM_DATAA[1] picture masc(7)
@07,30 say 'ate '                               get VM_DATAA[2] picture masc(7) valid VM_DATAA[1]<=VM_DATAA[2]
read
if lastkey()#K_ESC
	select('CLIENTE')
	DbGoTop()
	while !eof()
		@08,02 say 'Cliente : '+pb_zer(CLIENTE->CL_CODCL,5)+'-'+CLIENTE->CL_RAZAO
		@09,60 say 'Dt Reg: '+dtoc(CLIENTE->CL_DTSPC) color 'R/W+*'
		if VM_REREG=='N'.and.CLIENTE->CL_DTSPC>ctod('')
			pb_brake()
			loop
		end
		dbrunlock()
		while !reclock();end
		VM_DET:={}
		salvabd(SALVA)
		select('DPCLI')
		dbseek(str(CLIENTE->CL_CODCL,5),.T.) // Procura 1.DPL
		dbeval({||if(reclock(),;
					aadd(VM_DET,{	SIM,;//................................ 1-Selecao
										&(fieldname(1)),;//.................... 2-Nr Dpl
										&(fieldname(3)),;//.................... 3-Dt Emis
										&(fieldname(4)),;//.................... 4-Dt Venc
										&(fieldname(6)),;//.................... 5-Vlr Compra
										&(fieldname(6))-&(fieldname(7)),;//.... 6-Vlr Atrasado
										&(fieldname(10)),;//................... 7-Nr NF
										&(fieldname(11))}),;//................. 8-Serie
					pb_msg('Duplicata '+transform(&(fieldname(1)),masc(16))+' em uso.',0,.T.))},;
					{||&(fieldname(4))>=VM_DATAA[1].and.&(fieldname(4))<=VM_DATAA[2]},;
					{||&(fieldname(2))==CLIENTE->CL_CODCL})
		salvabd(RESTAURA)
		if len(VM_DET)>0.and.if(CLIENTE->CL_DTSPC>ctod(''),pb_sn('Cliente j  registrado no SPC. Faze-lo novamente ?'),.T.)
			VM_CAB:={'Selec','N§ Dpls','Dt Emiss','Dt Venc','Valor Total','Valor Atraso','Nt Fisc','Ser'   }
			VM_TAM:={     5,        9 ,        8 ,       8 ,           12,           12 ,       6 ,   3    }
			VM_MAS:={masc(1), masc(16),   masc(7),  masc(7),      masc(5),       masc(5), masc(19),masc(1) }
			OPC:=1
			while OPC>0
				pb_msg('Pressione <ENTER> para mudar Situa‡„o, <ESC> Sair',NIL,.F.)
				OPC:=abrowse(10,00,22,79,VM_DET,VM_CAB,VM_TAM,VM_MAS)
				if OPC>0
					VM_DET[OPC,1]:=if(VM_DET[OPC,1]==SIM,NAO,SIM)
					Keyboard replicate(chr(K_DOWN),OPC)
				end
			end
			FLAG:=.F.
			aeval(VM_DET,{|DET|FLAG:=if(DET[1]==SIM,.T.,FLAG)})
			if FLAG
				OPC:=alert('Selecione ... ',{'Imprimir Registro','Pr¢ximo Cliente','Sair'})
				if OPC==1
					CFEPSPCRI()
					VALOREN:=0
					aeval(VM_DET,{|DET|VALOREN+=if(DET[1]==SIM,DET[6],0)})
					CLIENTE->CL_DTSPC:=VM_DATAE
					CLIENTE->CL_VLRSPC:=VALOREN
					aadd(ENVIOS,{CLIENTE->CL_RAZAO,SIM})
					salvabd(SALVA)
					pb_msg('Verificando registros no SPC',nil,.F.)
					X:=0
					select('CLIOBS')
					dbseek(str(VM_CODIG,5),.T.)
					dbeval({||X++},,{||VM_CODIG==CO_CODCL})
					if X<30
						for Y:=1 to len(VM_DET)
							if VM_DET[Y,1]==SIM
								while !AddRec();end
								replace  CO_CODCL with VM_CODIG,;
											CO_SEQUE with ++X,;
											CO_OBS   with 'Valor '+;
															transform(VM_DET[Y,6],VM_MAS[5])+;
															' em atrazo desde '+;
															dtoc(VM_DET[Y,4])
							end
						next
					end
					salvabd(RESTAURA)
				elseif OPC==3
					dbgobottom()
					dbskip()
				end
			end
		end
		select('CLIENTE')
		pb_brake()
	end
end
if len(ENVIOS)>0
	ENVIOS:=asort(ENVIOS,,,{|X,Y|X[1]<Y[1]})
	pb_msg('Pressione <ENTER> para mudar envios',nil,.F.)
	OPC:=1
	setcolor('W+/R')
	while OPC>0
		OPC:=abrowse(5,0,22,40,ENVIOS,{'Nome Cliente','Env'},{30,5},{masc(23),masc(1)})
		if OPC>0
			ENVIOS[OPC,2]:=if(ENVIOS[OPC,2]==SIM,NAO,SIM)
		end
	end
	NREV:=0
	aeval(ENVIOS,{|DET|NREV+=if(DET[2]==SIM,1,0)})
	DET:={'Servico de Protecao ao Credito (SPC) - '+PARAMETRO->PA_CIDAD,;
			'Av Cacador 46  Fones (0492) - 46-2270 e 46-2493'}
	if file('SPC.ARR')
		DET:=restarray('SPC.ARR')
	end
	pb_box(18,0,,,,'Dados SPC - Envios '+str(NREV))
	DET[1]:=padr(DET[1],80)
	DET[2]:=padr(DET[2],80)
	@19,1 get DET[1]
	@20,1 get DET[2]
	read
	if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
		savearray(DET,'SPC.ARR')
		for OPC:=1 to 2
			SPCLISCAB(NREV)
			for X=1 to NREV
				? space(10)+pb_zer(X,2)+'. '+ENVIOS[X,1]
				if prow()>55
					?
					?space(50)+'Listagem continua....'
					eject
					SPCLISCAB(NREV)
					??space(50)+'continacao...'
				end
			next
			?
			?'Nota : Impresso em Ordem Alfabetica.'
			?
			?PARAMETRO->PA_CIDAD+dtexp(VM_DATAE)+'.'
			?
			?'Em qualquer caso e ocasiao assumo total e irrestrita responsabilidade pelos'
			?'nomes acima enviados ao SPC.'
			?
			?
			?'Associado '+str(PARAMETRO->PA_NRASPC,6)+'    ----------------------------------'
			?space(20)+'Carimbo e Assinatura Autorizada'
			eject
		next
		pb_deslimp(C15CPP)
	end
end
// dbcommitall()
dbcloseall()
return NIL

function CFEPSPCRI() // Impressao
local X,Y,VM_CAB:={'Cod Assoc','Dt Compra','Total Compra','C/A','Valor Atraso','Dt Atraso','Mot','Dt Ult PI'}
//----------------------1----------2-------------3--------4---------5-----------6--------7---------8-
if pb_ligaimp(I15CPP+I33LPP)
	for Y:=1 to 2
		?? replicate('-',132)
		? padc('SERVICO DE PROTECAO AO CREDITO - SPC'+space(15)+'REGISTRO',132)
		? replicate('-',132)
		? padc('IDENTIFICACAO',132,'-')
		? 'Nome : '+INEGR+CLIENTE->CL_RAZAO+CNEGR+space(10)+'Data Nascimento :'+dtoc(CLIENTE->CL_DTNAS)+;
		  space(5)+'local Nascimento : '+CLIENTE->CL_LOCNAS
		? replicate('-',132)
		? 'Estado Civil...: '+fn_estciv(CLIENTE->CL_ESTCIV)+space(5)
		??'Conjuge : '+CLIENTE->CL_CONJUG+space(5)+'Data Nasc : '+dtoc(CLIENTE->CL_DATANC)
		? 'Residencia.....: '+CLIENTE->CL_ENDER+space(5)+CLIENTE->CL_BAIRRO+space(5)
		??'Cidade : '+CLIENTE->CL_CIDAD+' - '+CLIENTE->CL_UF
		? 'local Trabalho.: '+CLIENTE->CL_LOCTRA
		? 'Profissao Cargo: '+CLIENTE->CL_CARGO
		? replicate('-',132)
		? 'Filiacao.......: '+CLIENTE->CL_FILIAC
		? replicate('-',132)
		? 'Documentos * C.P.F. : '+transform(CLIENTE->CL_CGC,masc(if(len(trim(CLIENTE->CL_CGC))==11,17,18)))
		? space(13)+   'CI/RG. : '+CLIENTE->CL_INSCR
		? replicate('-',132)
		? '| DATA ENVIO SPC |'
		for X:=1 to 8
			??' '+padc(VM_CAB[X],len(VM_CAB[X]))+' |'
		next
		? replicate('-',132)
		for X:=1 to len(VM_DET)
			if VM_DET[X,1]==SIM
				?  '| '+padc(transform(VM_DATAE,masc(7)),14)+' |'
				?? ' '+padc(str(PARAMETRO->PA_NRASPC,6),len(VM_CAB[1]))+' |'
				?? ' '+padc(transform(VM_DET[X,3],VM_MAS[3]),len(VM_CAB[2]))+' |'	
				?? ' '+padc(transform(VM_DET[X,5],VM_MAS[5]),len(VM_CAB[3]))+' |'
				?? ' '+padc('A',len(VM_CAB[4]))+' |'
				?? ' '+padc(transform(VM_DET[X,6],VM_MAS[6]),len(VM_CAB[5]))+' |'
				?? ' '+padc(transform(VM_DET[X,4],VM_MAS[4]),len(VM_CAB[6]))+' |'
				?? ' '+padc('07',len(VM_CAB[7]))+' |'
				?? ' '+padc(transform(VM_DET[X,3],VM_MAS[3]),len(VM_CAB[8]))+' |'
			end
		next
		? replicate('-',132)
		?
		?
		?
		?space(50)+PARAMETRO->PA_CIDAD+transform(VM_DATAE,masc(7))
		?
		?space(50)+replicate('_',50)
		?space(50)+'Assinatura do Associado'
		eject
	next
	pb_deslimp(I66LPP+C15CPP)
end
return NIL

function FN_ESTCIV(P1)
local RT:=''
if P1=='C'
	RT:='Casado'
elseif P1=='S'
	RT:='Solteiro'
elseif P1=='S'
	RT:='Solteiro'
elseif P1=='D'
	RT:='Desquitado'
elseif P1=='V'
	RT:='Viuvo'
end
return(padr(RT,12))

function SPCLISCAB(P1)
	? 'Ao'
	? INEGR+DET[1]+CNEGR
	? INEGR+DET[2]+CNEGR
	?
	?INEGR+'NESTA'+CNEGR
	?
	?'Mes de '+pb_mesext(VM_DATAE,'C')+' de '+str(year(VM_DATAE),4)
	?
	?'Anexamos a presente '+alltrim(str(P1))+' Cartoes Registro conforme relacao abaixo :'
	?
return NIL
