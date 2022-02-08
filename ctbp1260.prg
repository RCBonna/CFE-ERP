*-----------------------------------------------------------------------------*
 static aVariav := {.T., 0,  0, 0,'', 0, '','','','',0, '','',''}
*...................1....2...3..4..5..6...7..8..9,10,11,12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate lTrocando  => aVariav\[  1 \]
#xtranslate nY         => aVariav\[  2 \]


*-----------------------------------------------------------------------------*
function CTBP1260()	//	Atualizar Contas Detalhe										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
private VM_MES:=1
pb_lin4(_MSG_,ProcName())
if !xxsenha(ProcName(),'Atualizar Balancete/Razao')
	return NIL
end

if !abre({	'R->PARAMCTB',;
				'E->CTATIT',;
				'E->CTADET',;
				'E->RAZAO'})
	return NIL
end
pb_box(12,30,,,,'Selecione uma Opcao')
VM_VALIDACC:={'N','N','N'}
@13,32 say 'Atalizar Balancete com valores do Razao?' get VM_VALIDACC[1] pict mUUU valid VM_VALIDACC[1]$'SN'
@14,32 say 'Verificar Contas do Razao x Balancete  ?' get VM_VALIDACC[2] pict mUUU valid VM_VALIDACC[2]$'SN' when VM_VALIDACC[1]=='N'
@15,32 say 'Trocar uma Conta do Razao por Outra    ?' get VM_VALIDACC[3] pict mUUU valid VM_VALIDACC[3]$'SN' when VM_VALIDACC[1]=='N'.and.VM_VALIDACC[2]=='N'
@17,45 say 'Ano.: '+pb_zer(PARAMCTB->PA_ANO,4)
@17,32 say 'Mes.:' get VM_MES pict mI2 valid VM_MES>=1.and.VM_MES<=12 when VM_VALIDACC[1]=='S'
read
if if(lastkey()#K_ESC,pb_sn('Ajustar Balancete ou Razao conforme opcao acima?'),.F.)
	if VM_VALIDACC[1]=='S'
		AtualizaBalancete()
	elseif VM_VALIDACC[2]=='S'
		VerificaCtaRazao()
	elseif VM_VALIDACC[3]=='S'
		TrocaCtaRazao()
	end
end

dbcloseall()
return NIL

*-----------------------------------------------------------------------*
static function AtualizaBalancete()
*-----------------------------------------------------------------------*
local VM_TOT
private VM_DATA:=pb_zer(PARAMCTB->PA_ANO,4)+pb_zer(VM_MES,2)
pb_msg('Reordenando..',1)
select('RAZAO')
Index on RZ_CONTA+dtos(RZ_DATA)+str(RZ_NRLOTE,8) tag TEMPO to LIXOCTB1 for left(dtos(RAZAO->RZ_DATA),6)==VM_DATA
DbGoTop()
select('CTADET')
dbsetorder(2)
DbGoTop()
VM_DEB:='CTADET->CD_DEB_'+pb_zer(VM_MES,2)
VM_CRE:='CTADET->CD_CRE_'+pb_zer(VM_MES,2)
pb_msg('Zerando Contas do Balancete')
dbeval({||&VM_DEB:=0,&VM_CRE:=0})
DBEDIT()
dbcommitall()
select('RAZAO')
pb_msg('Acumulando Contas no Balancete')
while !eof()
 	VM_CONTA:=RZ_CONTA
	VM_TOT:={0,0}
	while !eof().and.VM_CONTA==RZ_CONTA
		VM_TOT[if(RZ_VALOR>0,1,2)]+=RZ_VALOR
		dbskip()
	end
	if CTADET->(dbseek(VM_CONTA))
		&VM_DEB:=abs(VM_TOT[1])
		&VM_CRE:=abs(VM_TOT[2])
	else
		beeperro()
		alert('ERRO - Conta nao cadastrada -'+VM_CONTA+';Use rotina validar e trocar contas contabeis.')
	end
end
return nil

*-------------------------------------------------------------------------------*
static function VerificaCtaRazao() // contra balancete - troca conta inexistente
*-------------------------------------------------------------------------------*
private  VM_CTARZP:=''
private  VM_CONTA :=''
private  VM_CTA   :=0
select('CTADET')
dbsetorder(2)
DbGoTop()
select('RAZAO')
DbGoTop()
while !eof()
	VM_CONTA:=RZ_CONTA
	pb_msg('Validando Contas Contabeis do Razao x Plano de Contas='+VM_CONTA+' '+DtoC(RZ_DATA))
	if CTADET->(dbseek(VM_CONTA))
		dbskip()
	else // trocar conta no razão
		VM_CTA    :=0
		VM_CONTARZ:=VM_CONTA
		CTADET->(dbsetorder(1))
		pb_box(19,30,,,,'Atualizar Conta no Razao')
		@20,32 say 'Conta Inexistente:'+Transform(VM_CONTARZ,MASC_CTB)+' REG'+Str(RecNo(),7) color 'R/W'
		@21,32 say 'Nova Conta.......:' get VM_CTA    picture mI4 valid fn_ifconta(@VM_CTARZP,@VM_CTA)
		read
		if if(lastkey()#K_ESC,pb_sn('Trocar Conta:'+VM_CONTA+' no Razao;Por Conta Ctb:'+VM_CTARZP),.F.)
			dbsetorder(0)
			DbGoTop()
			pb_msg('Aguarde: Trocando Conta:'+VM_CONTA+' Por Conta Ctb:'+VM_CTARZP)
			dbeval({||CtaChange(VM_CTARZP,Recno())},{||RAZAO->RZ_CONTA==VM_CONTA})
			dbcommit()
			dbsetorder(1)
		end
		dbseek(VM_CONTA+'9',.T.)
		CTADET->(dbsetorder(2))
	end
end
return nil

*-------------------------------------------------------------------------------*
static function TrocaCtaRazao() // Troca conta no razao A -> B
*-------------------------------------------------------------------------------*
private  VM_CTARZo:=''
private  VM_CTARZd:=''
private  VM_CTAo  :=0
private  VM_CTAd  :=0
select('CTADET')
dbsetorder(1)
DbGoTop()
select('RAZAO')
DbGoTop()
lTrocando:=.T.
while lTrocando
	VM_CTAo  :=0
	VM_CTAd  :=0
	pb_box(19,30,,,,'Trocar Conta A --> B no Razao')
	@20,32 say 'Conta A-Origem..:' get VM_CTAo pict mI4 valid fn_ifconta(@VM_CTARZo,@VM_CTAo) when pb_msg('Conta Contabil ORIGEM  - <ESC> para sair')
	@21,32 say 'Conta B-Destino.:' get VM_CTAd pict mI4 valid fn_ifconta(@VM_CTARZd,@VM_CTAd) when pb_msg('Conta Contabil DESTINO - <ESC> para sair')
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn('Trocar Conta:'+VM_CTARZo+' no Razao;Por Conta Ctb:'+VM_CTARZd),(lTrocando:=.F.))
		select('RAZAO')
		dbsetorder(0)
		DbGoTop()
		pb_msg('Aguarde: Trocando Conta:'+VM_CTARZo+' Por Conta Ctb:'+VM_CTARZd)
		dbeval({||CtaChange(VM_CTARZd,Recno())},{||RAZAO->RZ_CONTA==VM_CTARZo})
		dbcommit()
		dbsetorder(1)
	end
end
DbGoTop()
Alert('A mudanca de contas do razao nao refletem as mudancas no balancete deve-se recalcular todo o balancete (JAN-DEZ) pois as contas mudaram e se tiverem lancamentos em todos os meses percisa ser recalculado')
return nil

*-----------------------------------------------------------------------*
static function CtaChange(pCTACH,pRec)
replace RAZAO->RZ_CONTA with pCTACH
@24,01 say 'Registro:'+transform(pRec,mI6) color 'B/W'
return nil
*-----------------------------------------------------------------------* Fim
