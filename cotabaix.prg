*-----------------------------------------------------------------------------*
	function CotaBaix()	//	Baixar Cotas
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local Fat
	alert('Esta rotina de Baixa e Ativacao de Socios; NAO MAIS E NECESSARIO;USAR ROTINAS ASSOCIAR E DESASSOCIAR')
return NIL

function CotaBaixZZZZZ()	//	Baixar Cotas
if !abre({	'R->PARAMETRO',;
				'E->COTADV',;
				'E->COTAS',;
				'C->CLIENTE'})
	return NIL
end
ordem BAIXAS
DbGoTop()
pb_tela()
pb_lin4(_MSG_,ProcName())
pb_dbedit1("CFEPBXCP",'BaixarAtivar')
VM_CAMPO:=array(3)
VM_MUSC :=array(3)
VM_CABE :=array(3)

VM_CAMPO[1]:='CL_CODCL'          ; VM_MUSC[1]:=mI5 ; VM_CABE[1]:='Codigo'
VM_CAMPO[2]:='left(CL_RAZAO,20)' ; VM_MUSC[2]:=mXXX; VM_CABE[2]:='Nome Associado'
VM_CAMPO[3]:='CL_DTBAIX'         ; VM_MUSC[3]:=mDT ; VM_CABE[3]:='Data Baixa'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
	function CFEPBXCP1() // Rotina de BAIXA
*-----------------------------------------------------------------------------*
ordem CODIGO
while lastkey()#K_ESC
	
	VM_CODCL  :=0
	VM_DTBAIX :=ctod('')
	ValorBaixa:=0
	Contabiliz:='N'
	Parcelas  :=5
	
	pb_box(16,18,,,,'Baixar Associados')
	@17,20 say 'Cod.Associado.:' get VM_CODCL   pict mI5   valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.empty(CL_DTBAIX).and.reclock().and.CP_Tem_Saldo(CL_CODCL,@ValorBaixa)
	@18,20 say 'Data da Baixa.:' get VM_DTBAIX  pict mDT
	@19,20 say 'Contabilizar ? ' get Contabiliz Pict mUUU  valid Contabiliz$'SN'
	@20,20 say 'Vlr da Baixar.:' get ValorBaixa pict mI92  valid ValorBaixa>0 when Contabiliz=='S'
	@21,20 say 'Nr.Parcelas...:' get Parcelas   pict mI2   valid Parcelas  >0 when Contabiliz=='S'
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)

//						VM_FAT:=fn_parc(VM_PARCE,(VM_TOT-VM_DESCG-VM_VLRENT),VM_ULTPD,PARAMETRO->PA_DATA)

	replace CL_DTBAIX with VM_DTBAIX
		GravaCota({	VM_CODCL,;
						VM_DTBAIX,;
						-ValorBaixa,;
						'Ref. baixa do quadro social';
					})
		if Contabiliz=='S'
			Fat:=Parc_Cota(Parcelas,ValorBaixa,VM_DTBAIX)
			for X:=1 to len(Fat)
				GravaCotaDV({	VM_CODCL,;	//1-Associado
									FAT[X,2],;	//2-Data Venc
									FAT[X,3],;	//3-Saldo Inicial
									0,;			//5-Vlr Ja Pago
									'P',;			//4-Tipo movimento = Pagamento/Baixa
									.F.,;			//6-Flag de Contabilizado
									VM_DTBAIX})	//7-Dt Mov
			end
		end
		dbskip(0)
	end
end
ordem BAIXAS
DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
	function CFEPBXCP2() // Rotina de Ativacao
*-----------------------------------------------------------------------------*
	ordem CODIGO
	VM_CODCL :=CL_CODCL
	pb_box(18,18,,,,'Ativar Associados')
	@20,20 say 'Cod.Associado:' get VM_CODCL  pict mI5   valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.!empty(CL_DTBAIX).and.reclock()
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		replace CL_DTBAIX with ctod('')
		dbskip(0)
	end
	ordem BAIXAS
	DbGoTop()

return NIL

*-----------------------------------------------------------------------------*
 static function Parc_Cota(P1,P2,P3)
*-----------------------------------------------------------------------------*
local VM_VLRT:={}
local VM_VLRP:=0
local VM_FAT :={}
local ORD    :=1
local GetList:={}
local TF     :=savescreen(12,40)
aadd(VM_VLRT,P2)
VM_VLRP :=round(VM_VLRT[1]/P1+0.001,2)
aadd(VM_VLRT,VM_VLRT[1])

for ORD:=1 to P1
	if ORD==P1
		VM_VLRP:=VM_VLRT[1]
	end
	VM_VLRT[1]-=VM_VLRP
	aadd(VM_FAT,{ORD,;
					 ctod('31/12/'+str(year(P3)+ORD,4)),;
					 VM_VLRP})
next
salvacor(SALVA)
setcolor('B/W,W/B,,,B/W')
while .T..and.len(VM_FAT)>0
	VM_VLRT[1]:=0
	aeval(VM_FAT,{|DET|VM_VLRT[1]+=DET[3]})
	@23,42 say space(38) color 'W+/R'
	@23,56 say 'Saldo....:'+transform(VM_VLRT[1]-VM_VLRT[2],masc(5)) color 'W+/R'
	pb_msg('Press <ENTER> para alterar ou <ESC> para encerrar <DUP>',NIL,.F.)
	ORD:=abrowse(12,40,22,79,VM_FAT,;
									{'Duplic','Dt. Vcto','Valor  Parcela'},;
									{      10,        10,              15},;
									{    mDPL,       mDT,         masc(2)})
	if ORD>0
		VM_DAT:= VM_FAT[ORD,2]
		VM_VLR:= VM_FAT[ORD,3]
		@row(),52 get VM_DAT picture masc(7) valid VM_DAT>=P3
		if Len(VM_FAT)>1
			@row(),66 get VM_VLR picture masc(5) valid VM_VLR>=0
		end
		read
		if lastkey()#K_ESC
			VM_FAT[ORD,2]:=VM_DAT
			VM_FAT[ORD,3]:=VM_VLR
			keyboard replicate(chr(K_DOWN),ORD)
		end
	else
		if str(round(VM_VLRT[1]-VM_VLRT[2],2),15,2)#str(0.00,15,2)
			if pb_sn('Valor das Parcelas n„o Fechado, Abandonar ?')
				VM_FAT:={}
				exit
			end
		else
			if pb_sn('Parcelamento OK. Sair ?')
				exit
			else
				VM_FAT:={}
				exit
			end
		end
	end
end
salvacor(RESTAURA)
restscreen(12,40,,,TF)
set cursor ON
return (VM_FAT)
