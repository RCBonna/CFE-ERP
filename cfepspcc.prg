*-----------------------------------------------------------------------------*
function CFEPSPCC() // Cancela Registro no SPC											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#define SIM ' X '
#define NAO '   '

if !abre({	'C->PARAMETRO',;
				'C->BANCO',;
				'R->CTACTB',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'D->DPCLI',;
				'C->HISCLI',;
				'C->DIARIO'})
	return NIL
end

VM_DET:={{'01',NAO,'Liquidou justificando o atrazo',space(45)},;
			{'02',NAO,'Liquidou sem nada alegar'},;
			{'03',NAO,'Liquidou atraves de advogado ou em Juizo'},;
			{'04',NAO,'Liquidou por influencia do SPC'},;
			{'05',NAO,'Liquidou sob ameaca de Protesto'},;
			{'06',NAO,'Liquidou em cartorio'},;
			{'07',NAO,'Liquidou por devolucao da mercadoria'},;
			{'08',NAO,'Liquidou por retirada da mercadoria'},;
			{'09',NAO,'Liquidado por fiador ou avalista'},;
			{'10',NAO,'Liquidado por parente'},;
			{'11',NAO,'Regularizado por composicao'},;
			{'12',NAO,'Deixou em Dia o atrazo'},;
			{'13',NAO,space(40)},;
			{'14',NAO,space(40)} }
if file('DES_SPC.ARR')
	VM_DET:=restarray('DES_SPC.ARR')
end	

select('CLIENTE')

while .T.
	dbrunlock()
	aeval(VM_DET,{|DET|DET[2]=NAO})
	pb_tela()
	pb_lin4(_MSG_,ProcName())
	VM_CODIG:=0
	VM_VLRPG:=0
	VM_DATAE:=PARAMETRO->PA_DATA
	VM_DATAP:=PARAMETRO->PA_DATA
	VM_DATAR:=ctod('')
	scroll(06,01,21,78)
	@06,02 say padr('Sr(a)',    16,'.') get VM_DET[1,4] pict masc(01) valid !empty(VM_DET[1,4])
	@07,02 say padr('Data Dcto',16,'.') get VM_DATAE pict masc(07)
	@08,02 say padr('Cliente',  16,'.') get VM_CODIG picture masc(04) valid fn_codigo(@VM_CODIG,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODIG,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.reclock()
	@09,53 say 'Valor Pago...'          get VM_VLRPG pict masc(05) valid VM_VLRPG>=0 when (VM_VLRPG:=CLIENTE->CL_VLRSPC)>=0
	@10,53 say 'Data  Pgto...'          get VM_DATAP pict masc(07)
	@11,53 say 'Data Registro'          get VM_DATAR pict masc(07) valid !empty(VM_DATAR) when (VM_DATAR:=CLIENTE->CL_DTSPC)>=ctod('')
	@12,53 say 'N§Cadastro SPC '+str(PARAMETRO->PA_NRASPC,6)
	read
	if lastkey()#K_ESC
		VM_CAB:={   'SQ',   'Sel','Descricao da Forma Pgto'}
		VM_TAM:={     2 ,      3 ,                      40 }
		VM_MAS:={masc(1),masc(1) ,                 masc(23)}
		OPC:=1
		while OPC>0
			pb_msg('Os Campos 13 e 14 s„o livres para sua digita‡„o',NIL,.F.)
			OPC:=abrowse(09,00,22,50,VM_DET,VM_CAB,VM_TAM,VM_MAS)
			if OPC>0
				if VM_DET[OPC,2]==NAO
					VM_DET[OPC,2]=SIM
					if OPC>12
						@row(),9 get VM_DET[OPC,3]
						read
					end
				else
					VM_DET[OPC,2]=NAO
				end
				keyboard replicate(chr(K_DOWN),OPC)
			else
				FLAG:=.F.
				aeval(VM_DET,{|DET|FLAG:=if(DET[2]==SIM,.T.,FLAG)})
				if FLAG
					savearray(VM_DET,'DES_SPC.ARR')
					CFEPSPCCI()
					CLIENTE->CL_DTSPC:=ctod('')
					salvabd(SALVA)
					pb_msg('Verificando registros no SPC',nil,.F.)
					select('CLIOBS')
					dbseek(str(VM_CODIG,5),.T.)
					dbeval({||dbdelete()},{||reclock()},{||VM_CODIG==CO_CODCL})
					salvabd(RESTAURA)
				elseif !pb_sn('N„o foi selecionado nenhum motivo, Sair ?')
					OPC=1
				end
			end
		end
	else
		exit
	end
end
// dbcommitall()
dbcloseall()
return NIL

function CFEPSPCCI()
local X,Y,Z
if pb_ligaimp(I15CPP+I33LPP)
	for Z=1 to 2
		? 'Sr(a) : '+VM_DET[1,4]+space(10)
		?? PARAMETRO->PA_CIDAD+dtexp(VM_DATAE)+'.'
		?
		? replicate('-',132)
		? padc('SERVICO DE PROTECAO AO CREDITO - SPC',132)
		? replicate('-',132)
		?
		? 'NESTA:'
		?
		? 'Para os efeitos regulamentares, comunicamo-lhes que '+INEGR+CL_RAZAO+CNEGR
		??' CPF : '+transform(CLIENTE->CL_CGC,masc(if(len(trim(CLIENTE->CL_CGC))==11,17,18)))
		? space(86)+'Data Nascimento : '+dtoc(CLIENTE->CL_DTNAS)
		? 'Residente a '+CL_ENDER+space(1)+CL_BAIRRO+space(1)
		??'Cidade: '+CL_CIDAD+'('+CL_UF+')'
		?
		? 'Codigo do Associado :'+str(PARAMETRO->PA_NRASPC,6)+' regularizou a situacao de seu debito conosco,'
		?
		? 'pela forma indicada no quadro abaixo com X pg.'+space(10)
		?? 'R$ '+transform(VM_VLRPG,masc(5))+space(10)+'Em '+dtoc(VM_DATAP)
		?
		? replicate('-',132)
		for X:=1 to len(VM_DET)/2
			?' |'
			for Y:=1 to 3
				??' '+padr(transform(VM_DET[X,  Y],VM_MAS[Y]),VM_TAM[Y])+' |'
			next
			??space(10)+'|'
			for Y:=1 to 3
				??' '+padr(transform(VM_DET[X+7,Y],VM_MAS[Y]),VM_TAM[Y])+' |'
			next
		next
		? replicate('-',132)
		?
		? 'Data do Registro '+dtoc(VM_DATAR)
		?
		?space(50)+replicate('_',50)
		?space(50)+'Carimbo e Assinatura do Autorizada'
		eject
	next
	pb_deslimp(I66LPP+C15CPP)
end
return NIL
