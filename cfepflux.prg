*-----------------------------------------------------------------------------*
function CFEPFLUX(P1)	//	Fluxo de Caixa Geral											*
* P1=1=DEFINE SE GERAL OU POR BANCO															*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local FLAG:={.T.,.F.},OPC:=1,;
		ARQ:={'DPCLI','DPFOR'},;
		INTERV:={},;
		VM_PAG:=0,;
		VM_LAR:=78,;
		VM_REL:='Fluxo Pgtos/Receb',;
		TOT:={{0,0,0,0},{0,0,0,0}}	//	vencidadas a vencer//CLI-FOR
		FILTRO:=''
		BCO:=0

pb_lin4(VM_REL,ProcName())

if file('INTERV.DAT')
	INTERV:=restarray('INTERV.DAT')
else
	INTERV:=array(14,6) // 20 intervalos
	aeval(INTERV,{|DET|afill(DET,0)})
	INTERV[01,1]:=-9999
	INTERV[14,2]:= 9999
end

aeval(INTERV,{|DET|afill(DET,0,3)})	//	 zerar campos de valor

if P1#NIL
	if !abre({'R->BANCO'})
		return NIL
	end
	pb_box(20,20)
	@21,22 say 'Informe Banco :' get BCO pict masc(11) valid fn_codigo(@BCO,{'BANCO',{||BANCO->(dbseek(str(BCO,2)))},,{2,1}})
	read
	if lastkey()==K_ESC
		dbcloseall()
		return NIL
	end
	FILTRO:='{||str(BCO,2)=='
end
if !abre({'R->PARAMETRO','R->CLIENTE','R->DPFOR','R->DPCLI'})
	return NIL
end

select('DPFOR')
dbsetorder(4)
if !empty(FILTRO)
	FILTRO1=FILTRO+'str('+fieldname(8)+',2)}'
	FILTRO1=&(FILTRO1)
	dbsetfilter(FILTRO1)
	VM_REL+='-'+pb_zer(BCO,2)+'-'+trim(BANCO->BC_DESCR)
	pb_lin4(VM_REL,ProcName())
end

select('DPCLI')
dbsetorder(4)
if !empty(FILTRO)
	FILTRO2=FILTRO+'str('+fieldname(8)+',2)}'
	FILTRO2=&(FILTRO2)
	dbsetfilter(FILTRO2)
end

setcolor('W+/N+,N/W,,,W/N+')
while OPC>0
	if FLAG[1]
		tone(1000,2)
		pb_msg('Altera‡„o dos Intervalos. Selecione e press <ENTER>, <ESC> sai.',NIL,.F.)
	else
		tone(500,5)
		pb_msg('Visualisar Duplicatas. Selecione e press <ENTER>, <ESC> sai.',NIL,.F.)
	end
	OPC:=abrowse(5,0,22,58,INTERV,{'DiaDe',' Ate','NrDpR','CLI/VlrRECEBER','NrDpP','FOR/Vlr PAGAR'},{5,5,5,15,5,15},{masc(4),masc(4),masc(4),masc(2),masc(4),masc(2)})
	if OPC>1.and.FLAG[1] // Digita
		CPO:=INTERV[OPC,1]
		@row(),2 get CPO pict masc(4) valid CPO>INTERV[OPC-1,1]
		read
		if lastkey()#K_ESC
			INTERV[OPC-1,2]=CPO-1
			INTERV[OPC,  1]=CPO
			FLAG[2]=.T. // Vetor Atualizado
			keyboard(replicate(chr(K_DOWN),OPC))
		end
	elseif OPC=0.and.FLAG[1]
		FLAG[1]=.F.
		pb_msg('Processando...',NIL,.F.)
		for OPC=1 to 2
			select(ARQ[OPC])
			CPO={||fieldget(4)-PARAMETRO->PA_DATA}
			dbeval(;
					{||P2:=ascan(INTERV,{|DET|eval(CPO)>=DET[1].and.eval(CPO)<=DET[2]}),;
						P2:=if(P2=0,1,P2),;
						INTERV[P2,OPC*2+1]++,;
						INTERV[P2,OPC*2+2]+=fieldget(6)-fieldget(7),;
						TOT[if(eval(CPO)<=0,1,2),OPC*2-1]++,;
						TOT[if(eval(CPO)<=0,1,2),OPC*2  ]+=fieldget(6)-fieldget(7);
					  };
					)
		next
		pb_box(13,37)
		@14,39 say padl('[DUPLICATAS CLIENTES]',40) color 'R/W'
		@15,39 say 'Dpl REC Pendentes.:'+transform(TOT[1,1],masc(4))+transform(TOT[1,2],masc(2))
		@16,39 say 'Dpl REC a Vencer..:'+transform(TOT[2,1],masc(4))+transform(TOT[2,2],masc(2))
		@17,39 say 'TOTAL a RECEBER...:'+transform(TOT[1,1]+TOT[2,1],masc(4))+transform(TOT[1,2]+TOT[2,2],masc(2))

		@18,39 say padl('[DUPLICATAS FORNECEDORES]',40) color 'R/W'
		@19,39 say 'Dpl PAG Pendentes.:'+transform(TOT[1,3],masc(4))+transform(TOT[1,4],masc(2))
		@20,39 say 'Dpl PAG a Vencer..:'+transform(TOT[2,3],masc(4))+transform(TOT[2,4],masc(2))
		@21,39 say 'TOTAL a PAGAR.....:'+transform(TOT[1,3]+TOT[2,3],masc(4))+transform(TOT[1,4]+TOT[2,4],masc(2))
		inkey(30)
		OPC=1

	elseif OPC>0.and.!FLAG[1]
		P2:=alert('Selecione...',ARQ)
		if P2#0.and.INTERV[OPC,P2*2+1]>0
			select(ARQ[P2])
			CFEPFLUXA(INTERV[OPC,1],INTERV[OPC,2],P2)
		elseif P2#0
			beeperro()
			pb_msg('N„o h  duplicatas para visualizar.',15,.T.)
		end
	end
end
if FLAG[2]
	savearray(INTERV,'INTERV.DAT')
end
dbcloseall()
if if(pb_sn('Imprimir ?'),pb_ligaimp(RST),.F.)
	VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),'',VM_PAG,NIL,VM_LAR)
	?padc(VM_REL,VM_LAR)
	?
	? padr('Intervalo/dias',23,'-')
	??' Duplicatas a RECEBER'
	??space(13)+'Duplicatas a PAGAR'
	?replicate('-',VM_LAR)
	for VM_X=1 to 14
		? transform(INTERV[VM_X,1],masc(4))+' a '
		??transform(INTERV[VM_X,2],masc(4))+space(1)+replicate('.',9)+space(1)
		??transform(INTERV[VM_X,3],masc(4))
		??transform(INTERV[VM_X,4],masc(2))+space(1)+replicate('.',9)+space(1)
		??transform(INTERV[VM_X,5],masc(4))
		??transform(INTERV[VM_X,6],masc(2))
	next
	?replicate('-',VM_LAR)
	? padr('Dpl Pendentes',24,'.')+transform(TOT[1,1],masc(4))+transform(TOT[1,2],masc(2))
	??space(1)+replicate('.',9)+space(1)+transform(TOT[1,3],masc(4))+transform(TOT[1,4],masc(2))
	? padr('Dpl a Vencer',24,'.') +transform(TOT[2,1],masc(4))+transform(TOT[2,2],masc(2))
	??space(1)+replicate('.',9)+space(1)+transform(TOT[2,3],masc(4))+transform(TOT[2,4],masc(2))
	? padr('TOTAL',24,'.')        +transform(TOT[1,1]+TOT[2,1],masc(4))+transform(TOT[1,2]+TOT[2,2],masc(2))
	??space(1)+replicate('.',9)+space(1)+transform(TOT[1,3]+TOT[2,3],masc(4))+transform(TOT[1,4]+TOT[2,4],masc(2))
	?replicate('-',VM_LAR)
	eject
	pb_deslimp()
end
return NIL

*-----------------------------------------------------------------------------*
function CFEPFLUXB()
return NIL

function CFEPFLUXA(P1,P2,P3)
local CPO:={||fieldget(4)-PARAMETRO->PA_DATA},;
		VM_X,;
		VM_Y,;
		VM_QUAD:=savescreen(),;
		VM_TF

salvabd(SALVA)
select('CLIENTE')
P3  :=alias()+'->'+fieldname(2)
VM_Y:=alias()
salvabd(RESTAURA)
dbsetrelat(left(P3,at('-',P3)-1), {||str(fieldget(2),5)} )
DbGoTop()

salvacor(SALVA)
setcolor('N/W')
@21,15 to 22,79
@21,21 say '[Nome]'
@21,52 say 'Dt Vcto'
@21,71 say 'Valor'
VM_TF:=savescreen()
VM_X :=21
while !eof().and.lastkey()#K_ESC
	if eval(CPO)>=P1.and.eval(CPO)<=P2
		scroll(VM_X-1,15,21,79,1)
		@21,15 say '³'+space(1)+left(&P3,32)+' '+dtoc(fieldget(4))+' '+;
								transform(fieldget(6)-fieldget(7),masc(2))+space(3)+'³'
		VM_X--
		if VM_X=5
			VM_X=21
			tone(500,3)
			tone(950,4)
			pb_msg('Pressione <ENTER> para Continuar.',0)
			restscreen(,,,,VM_TF)
		end
	end
	dbskip()
end
if lastkey()#K_ESC
	pb_msg('Pressione <ENTER> ou <ESC> para cancelar.',0,.T.)
end
restscreen(,,,,VM_QUAD)
salvacor(RESTAURA)
dbclearrel()
return NIL
