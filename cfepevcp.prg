*-----------------------------------------------------------------------------*
 function CFEPEVCP()	//	Envia valores para extrato
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local CODIGO
local ANO  :=1997
local NUMDP:=0
local TOTSOB:={0,0}
local VM_HISTOR
local VM_HISTDS
local VM_DATA
local VM_DATAVC

if !abre({	'R->PARAMETRO',;
				'R->COTAPA',;
				'R->CLIENTE',;
				'C->DPFOR',;
				'C->DIARIO',;
				'C->COTAS',;
				'E->COTASSO',;
				'E->COTASCV'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
select('COTASSO')
dbgobottom()
ANO  :=CP_ANO
if CP_DISTRI
	alert('SOBRA de : '+str(ANO,4)+';Ja enviada para Extrato')
	dbcloseall()
	return NIL
end
select('COTASCV')
DbGoTop()
while !eof()
	TOTSOB[1]+=CP_VLRSOBR//.................Soma Sobra de Captalizacao
	TOTSOB[2]+=CP_VLRDIST//.................Soma Sobra de Distribuicao
	dbskip()
end
DbGoTop()
if str(TOTSOB[1],15,2)#str(COTASSO->CP_VALORD,15,2)
	alert('Valor a CAPITALIZAR nao esta fechando corretamente;Verificar na rotina de calculo.')
	dbcloseall()
	return NIL
end
if str(TOTSOB[2],15,2)#str(COTASSO->CP_VALORP,15,2)
	alert('Valor a DISTRIBUIR nao esta fechando corretamente;Verificar na rotina de calculo.')
	dbcloseall()
	return NIL
end
VM_HISTOR:=COTASSO->CP_HISTOR
VM_HISTDS:=COTASSO->CP_HISTDS
VM_DATA  :=ctod('31/12/'+str(ANO))
VM_DATAVC:=eoy(VM_DATA)
pb_box(16,00,,,,'Incluir Sobras no Extrato e Contas a Pagar')
@17,01 say 'Data Lancamento.:' get VM_DATA   pict mDT
@18,01 say 'Hist.CAPITALIZAR:' get VM_HISTOR pict mXXX

@20,01 say 'Hist.DISTRIBUIR.:' get VM_HISTDS pict mXXX
@21,01 say 'Data Vencimento.:' get VM_DATAVC pict mDT valid VM_DATAVC>=VM_DATA
read
if if(lastkey()#K_ESC,pb_sn('Incluir sobras de '+str(ANO)+' no EXTRATO'),.F.)
	pb_msg('Enviando Sobras Para Capitalizar...')
	select('COTASCV')
	DbGoTop()
	while !eof()
		select('COTAS') // Criando lancamento no extrato
		if AddRec()
			replace 	CP_CODCL  with COTASCV->CP_CODCL,;
						CP_DATAE  with VM_DATA,;
						CP_VALOR  with COTASCV->CP_VLRSOBR,;
						CP_HISTOR with VM_HISTOR
		end
		select('COTASCV')
		dbskip()
	end
	select COTASCV
	DbGoTop()
	NUMDP:=1
	while !eof()
		if COTASCV->CP_VLRDIST>0
			CLIENTE->(dbseek(str(COTASCV->CP_CODCL,5)))
			select DPFOR
			if AddRec(,{val(right(str(COTASCV->CP_ANO,4),2)+PB_zer(NUMDP,4)+'01'),;//.01-Cod.DPL
							COTASCV->CP_CODCL,;//..................................02-Fornecedor
							VM_DATA,;//............................................03-Data Emissao
							VM_DATAVC,;//..........................................04-Data Vencimento
							ctod(''),;//...........................................05-Data Pagamento
							COTASCV->CP_VLRDIST,;//................................06-Valor DPL
							0.00,;//...............................................07-Valor Pago
							1,;//..................................................08-Cod Banco
							1,;//..................................................09-Moeda
							NUMDP,;//..............................................10-Nr NF
							'SOB',;//..............................................11-Serie (SOB=Sobras)
							CLIENTE->CL_RAZAO,;//..................................12-Alfa-DP
							ctod(''),;//...........................................13-Data Protesto
							'',;//.................................................14-Ofico Protesto
							0.00,;//...............................................15-Juros ao Mes
							'N',;//................................................16-N->Normal P-PREVISAO X->PROTESTO
							'DISTRIB-'+STR(COTASCV->CP_ANO);//.....................17-Nr do Boleto
							})
				NUMDP++
			end
			select COTASCV
		end
		dbskip()
	end
	*----------------------------------------------------------CONTABILIZACAO
	CODIGO:='CP:DIS:'+str(Ano,4)+'/'+SONUMEROS(time())
	fn_atdiario(VM_DATA,;
					COTAPA->PA_CTA05,;	// D=Distribuicao
					DEB*TOTSOB[2],;
					COTAPA->PA_HIST3,;
					CODIGO;
					)
	fn_atdiario(VM_DATA,;
					COTAPA->PA_CTA06,;	// C=Distribuicao
					CRE*TOTSOB[2],;
					COTAPA->PA_HIST3,;
					CODIGO;
					)
	*----------------------------------------------------------FECHA DISTRIBUIÇAO
	select('COTASSO')
	replace CP_DISTRI with .T.
	// CONTABILIZAÇAO
	// TOTSOB[2]
end
dbcloseall()
return nil
