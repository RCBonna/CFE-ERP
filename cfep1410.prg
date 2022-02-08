*-----------------------------------------------------------------------------*
function CFEP1410()	//	Cadastro de Layout de Cheques									*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())
scroll(06,01,21,78,0)

if !abre({'C->BANCO','C->CTADET','C->LAYOUT'})
	return NIL
end
select('BANCO')
DbGoTop()

VM_CAMPO:= {'BC_CODBC', 'BC_DESCR'}
VM_MUSC := {       mI2,      mXXX }
VM_CABE := {'Codigo',  'Descricao'}

pb_dbedit1('CFEP141','AlteraExclui')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function CFEP1411() && Rotina de Inclus„o
local LAYOUT:={{'VALOR     ',0,0 },;//1
					{'EXTENSO1  ',0,0 },;//2
					{'EXTENSO2  ',0,0 },;//3
					{'PORTADOR  ',0,0 },;//4
					{'CIDADE(UF)',0,0 },;//5
					{'DIA       ',0,0 },;//6
					{'MES       ',0,0 },;//7
					{'ANO       ',0,0 }}	//8
local X,NRLIN,LPP
select('LAYOUT')
NRLIN:=BANCO->BC_NRLIN
LPP  :=BANCO->BC_LPP
dbseek(str(BANCO->BC_CODBC,2),.T.)
while !eof().and.BANCO->BC_CODBC == LAYOUT->LY_CODBC
	LAYOUT[LY_SEQ,2]:=LAYOUT->LY_LINHA		
	LAYOUT[LY_SEQ,3]:=LAYOUT->LY_COLUNA
	dbskip()
end

pb_box(08,01,,,,'Informe/'+BANCO->BC_DESCR)
@09,03 say 'Numero de Linhas do Cheque.....:' get NRLIN pict mI2 valid NRLIN > 8
@10,03 say 'Compactacao <1=6 lpp> <2=8 lpp>:' get LPP   pict mI1 valid LPP>0.and.LPP<3
@12,10 say 'Nome do Campo    Linha    Coluna'
for X:=1 to len(LAYOUT)
	@12+X,10 say LAYOUT[X,1]
	@12+X,30 get LAYOUT[X,2] pict mI2 valid GetActive():VarGet() >=0
	@12+X,40 get LAYOUT[X,3] pict mI2 valid GetActive():VarGet() > 0
end
read
if if(lastkey()#K_ESC,pb_sn(),.f.)
	select('BANCO')
	if reclock()
		replace 	BC_NRLIN with NRLIN,;
					BC_LPP   with LPP
		select('LAYOUT')
		for X:=1 to len(LAYOUT)
			if !dbseek(str(BANCO->BC_CODBC,2)+str(X,2))
				while !AddRec();end
				replace 	LY_CODBC with BANCO->BC_CODBC,;
							LY_SEQ	with X
				dbunlock()
			end
			if reclock()
				replace	LY_DADO		with LAYOUT[X,1],;
							LY_LINHA		with LAYOUT[X,2],;
							LY_COLUNA 	with LAYOUT[X,3]
			end
		next
		dbunlock()
	end
end
select('BANCO')
dbunlock()
return NIL

*-------------------------------------------------------------------* 
function CFEP1412() // Rotina de Exclusao
if pb_sn('Eliminar Layout do Banco '+BC_DESCR)
	select('LAYOUT')
	dbseek(str(BANCO->BC_CODBC,2),.T.)
	while !eof().and.BANCO->BC_CODBC == LAYOUT->LY_CODBC
		if reclock()
			dbdelete()
		end
		dbskip()
	end
	dbunlock()
	select('BANCO')
end
dbunlock()
return NIL
//-----------------------------------------------------------EOF