*-----------------------------------------------------------------------------*
 function CFEP7100() // Virada Diaria														*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_VLR
local VM_VALOR
local VM_FLAG
local X
local PERIODO
local CF_DATA:=''
pb_lin4('Troca Data Sistema',ProcName())
if !abre({	'E->MOEDA',;
				'E->PARAMETRO',;
				'E->PARAMCTB',;
				'E->CTRNF',;
				'E->DPFOR',;
				'E->DPCLI',;
				'C->CAIXA01',;
				'E->PROD',;
				'E->HISFOR',;
				'E->CAIXASA',;
				'E->HISCLI'})
	return NIL
end

select PARAMETRO
VM_DATA   :=PARAMETRO->PA_DATA+1
VM_VALOR  :=PARAMETRO->PA_VALOR
VM_DIRETO :=PARAMETRO->PA_DIRETO
X         :=MaxRow()-6
VM_LIMANUA:=PA_LIMANUA

set key 330 to DtVolta()		// ALT + "-" --> ALT + Sinal de Menos
set key 386 to DtVolta()		// 
pb_msg('ALT + "-"    <--   Voltar data')
pb_box(X++,MaxCol()-40,MaxRow()-2,MaxCol(),'W+/R,B/W,,,W+/R')
@X++,MaxCol()-39 say padr('Data Atual do Sistema',25,'.')+' '+transform(PA_DATA,mDT)
@X++,MaxCol()-39 say padr('Mudar Data para'      ,25,'.')     get VM_DATA  pict mDT  valid VM_DATA >=PA_DATA
@X++,MaxCol()-39 say padr('Valor do '+trim(PA_MOEDA),25,+'.') get VM_VALOR pict mD83  valid VM_VALOR > 0
read
set key 330 to 
set key 386 to 

if if(lastkey()#K_ESC,pb_sn('Mudar data de : '+dtoc(PA_DATA)+;
                            ';   para data  : '+dtoc(VM_DATA)),.F.)
	if VM_DATA > date()
		beepaler()
		beepaler()
		beepaler()
		beepaler()
		if (VM_DATA - Date()) > 365
			alert('Voce esta tentando fazer uma alteracao de data superior a 365 dias;Use periodos menores')
			dbcloseall()
			return NIL
		end
		if alert('A T E N C A O;A nova data e maior que a data do computador;Mesmo assim vc deseja continuar?',{'NAO',' sim '})<2
			dbcloseall()
			return NIL
		end
		beepaler()
	end
	if PARAMETRO->PA_EMCUFI.and.CupomFiscal() // Usa Impressora Fiscal
		*-------------------------------> Programar formas de pagamento
		XXX:=CF_Info('27')
		ALERT('Virada = '+XXX)
		if XXX =='000000'
			CF_ProgFormPgto()
		end

		CF_DATA:=CF_Info('23')
		if CF_DATA==''
			Alert("ERR0;Data da impressora sem Valor......;Data nao Atulizada.")
			dbcloseall()
			return NIL
		end
		CF_DATA:=ctod(substr(CF_DATA,1,2)+'/'+substr(CF_DATA,3,2)+'/'+substr(CF_DATA,5,2))
		if CF_DATA#VM_DATA
			Alert('Data Impressora Fiscal:'+dtoc(CF_DATA)+';'+;
					'Data do Sistema.......:'+dtoc(VM_DATA)+';Devem ser Iguais')
			dbcloseall()
			return NIL
		else
			SALVABANCO
			for X:=1 TO 3
				select CAIXA01
				if X == 1
					ORDEM CXA01
				elseif X == 2
					ORDEM CXA02
				end
				if dbseek(str(X,2)+dtos(PARAMETRO->PA_DATA))
					if !AX_FECHAD
						alert("******* ATENCAO *******;Caixa "+str(X,2)+" Aberto para o Dia Anterior;Use rotina de fechamento")
						dbcloseall()
						return NIL
					end
				end
			end
			RESTAURABANCO
		end
	end
	if if(month(VM_DATA)#month(PA_DATA),VIR_MES(left(dtos(PA_DATA),6)),.T.) // VIRADA MENSAL
		VM_FLAG:=year(VM_DATA)#year(PA_DATA) // virada anual ?
		Replace  PA_DATA    with VM_DATA,;
					PA_VALOR   with VM_VALOR,;
					PA_CFFORMA with 'N'
		Select MOEDA
		if !dbseek(dtos(VM_DATA))
			dbappend(.T.)
		end
		Replace  MO_DATA    with VM_DATA,;
					MO_VLMOED1 with VM_VALOR,;
					MO_VLMOED2 with 1

		pb_msg('Atualizando Controle NF...')
		Select CTRNF
		DbEval({||CTRNF->NF_SITUA:='L'},{||CTRNF->NF_SITUA=='T'})
		DbGoBottom()
		while !bof()
			P1:=NF_TIPO
			P2:=.F.
			while !bof().and.P1==NF_TIPO
				if P2.and.NF_SITUA=='F'
					delete
				end
				if NF_SITUA=='F'
					P2:=.T.
				end
				dbskip(-1)
			end
		end
		Pack
		DbCommitAll()
		if VM_FLAG.and.VM_LIMANUA$' S' // É Virada Anual
			CFEPVANO()
		end
	end
	FileDelete ('WORK*.*')
	FileDelete ('TEMP*.*')
end
DbCloseAll()
ARQ(.F.)
ARQI(.F.)
return NIL

*-----------------------------------------------------------------------------*
 static function VIR_MES(ANOMES)
*-----------------------------------------------------------------------------*
local Contador
local TF :=savescreen()
local OPC:=alert('ATENCAO - VIRADA MENSAL;Fazer Copia ANTES.', {'Nao Fazer','CONTINUAR'}, 'R/W')

if OPC==2		// Continua
	dbcloseall()
	pb_msg('Copia de dados do Mes-back-up em '+VM_DIRETO,Nil,.F.)
	COPIAMES(ANOMES,VM_DIRETO) // SALVAR MES ANTES DE CONTINUAR
	RestScreen(,,,,TF)
	if !abre({	'E->MOEDA',;
					'E->PARAMETRO',;
					'E->PARAMCTB',;
					'E->CTRNF',;
					'E->DPFOR',;
					'E->DPCLI',;
					'E->MOVEST',;
					'E->PEDCAB',;
					'E->PEDPARC',;
					'E->PROD',;
					'E->HISFOR',;
					'E->SALDOS',;
					'E->HISCLI'})
		Return .F.
	end
	pb_msg('Processando Estoque',Nil,.F.)
	if PARAMETRO->PA_LIMEST
		Select MOVEST
		Zap
		Pack
	end
	pb_msg('Processando Estoque/Saldos',nil,.F.)
	Select PROD
	Ordem CODIGO
	DbGoTop()
	while !eof()
		@24,60 say str(PROD->PR_CODPR,L_P)
		select SALDOS
		if !SALDOS->(dbseek(str(1,2)+ANOMES+str(PROD->PR_CODPR,L_P)))
			AddRec()
			replace 	SALDOS->SA_EMPRESA with 1,;
						SALDOS->SA_PERIOD  with ANOMES,;
						SALDOS->SA_CODPR   with PROD->PR_CODPR
		end
		replace 	SALDOS->SA_QTD with PROD->PR_QTATU,;// saldo no fim do mes
					SALDOS->SA_VLR with PROD->PR_VLATU

		select PROD
		replace 	PROD->PR_SLDQT with PROD->PR_QTATU,;
					PROD->PR_SLDVL with PROD->PR_VLATU
		Skip
	end
	pb_msg('Atualizando HIST.Fornecedores.',NIL,.F.)
	select('HISFOR')
	dbeval({||dbdelete()},{||(VM_DATA-HF_DTPGT)>PARAMETRO->PA_HTFOR})
	Pack

	pb_msg('Atualizando HIST.Clientes.',NIL,.F.)
	select('HISCLI')
	dbeval({||dbdelete()},{||(VM_DATA-HC_DTPGT)>PARAMETRO->PA_HTCLI})
	Pack

	pb_msg('Atualizando Pedidos/Parcelamento.',NIL,.F.)
	Contador:=0
	select PEDCAB
	ORDEM GPEDIDO
	select PEDPARC
	DbGoTop()
	while !eof()
		@23,60 say 'Proces : '+str(PP_PEDID,6)
		if !PEDCAB->(dbseek(str(PEDPARC->PP_PEDID,6)))
			Delete
			Contador++
			@24,70 say str(Contador,5)
		else
			if PEDCAB->PC_DTEMI<date()-356.and.PEDCAB->PC_FLAG
				Delete
				Contador++
				@24,70 say str(Contador,5)
			end
		end
		Skip
	end
	if Contador > 0
		Pack
	end
end
select PARAMETRO
return (OPC==2)

*-------------------------------------------------------------
 static function DtVolta()
*-------------------------------------------------------------
replace PARAMETRO->PA_DATA with PARAMETRO->PA_DATA - 1
alert('Tenha cuidado quanto retroceder a data;Data alterada para = '+dtoc(PARAMETRO->PA_DATA))
keyboard chr(27)
return NIL
