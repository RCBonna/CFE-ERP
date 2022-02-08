 static XOBSX
 static aVariav := {0, 0,  0, .F., 0,''}
*...................1..2...3...4...5..6...7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate VM_TOTIT   => aVariav\[  2 \]
#xtranslate VM_ICMSX   => aVariav\[  3 \]
#xtranslate RT         => aVariav\[  4 \]
#xtranslate nZ         => aVariav\[  5 \]
#xtranslate cOBSPrd    => aVariav\[  6 \]

*-----------------------------------------------------------------------------*
 function CFEP5106() // atualizar
*-----------------------------------------------------------------------------*
CFEP5201()
return NIL

*-----------------------------------------------------------------------------*
 function FN_ICMSC(VM_DET) // matriz icms (%,base)
*-----------------------------------------------------------------------------*
local VM_ICMS:={}
for nX:=1 to len(VM_DET)
	if VM_DET[nX][02]>0.and.VM_DET[nX][09]>0 // % ICMS
		VM_TOTIT:=Round(Trunca(VM_DET[nX][04]*VM_DET[nX][05],2)-VM_DET[nX][06]-VM_DET[nX][30]+VM_DET[nX][07],2)
		VM_ICMSX:=Ascan(VM_ICMS,{|ELEM|VM_DET[nX][09]:=ELEM[1]})
		if VM_ICMSX==0
			aadd(VM_ICMS,{0,0})
			VM_ICMSX:=len(VM_ICMS)
		end
		VM_ICMS[VM_ICMSX][1]:=VM_DET[nX][09] // %ICMS
		VM_ICMS[VM_ICMSX][2]+=trunca(VM_TOTIT*VM_DET[nX][11]/100,2) // Base
	end
next
return (VM_ICMS)

*-----------------------------------------------------------------------------*
 function FN_IMPRV(P1,P2)
*-----------------------------------------------------------------------------*
@P2[1],P2[2] say P1
return (.T.)

*-----------------------------------------------------------------------------*
 function FN_VLRVENDA(P1,P2)
*-----------------------------------------------------------------------------*
RT:=.T.
if PARAMETRO->PA_CHKVEN==chr(255)+chr(25).and.P1<P2
	RT:=.F.
	if pb_sn(padr('ATENCAO',56,'.')+' Pre‡o de Venda inferior ao do cadastro, Continuar ?')
		if xxsenha(ProcName(),'Autorizar Venda com preco menor')
			RT:=.T.
		end
		@23,50 say space(29)
	end
end
return(RT)

*------------------------------Busca array com todos os produtos de um pedido
 function FN_RTPRDPED(P1,P2)
*------------------------------Busca array com todos os produtos de um pedido
local DET:={}
nZ       :=0
XOBSX    :=array(20,2)
aeval(XOBSX,{|DET|DET[1]:=space(01)})
aeval(XOBSX,{|DET|DET[2]:=space(34)})

if PEDCAB->PC_FLSVC // Nota Fiscal de Serviço ?
	select('PEDSVC')
	dbseek(str(P1,6),.T.)
	while !eof().and.P1==PS_PEDID
		ATIVIDAD->(dbseek(str(PEDSVC->PS_CODSVC,2)))
		aadd(DET,LinDetProd(++nZ))
		DET[nZ][02]:=PS_CODSVC
		DET[nZ][03]:=ATIVIDAD->AT_DESCR
		DET[nZ][04]:=PS_QTDE
		DET[nZ][05]:=PS_VALOR
		DET[nZ][06]:=PS_DESCV
		DET[nZ][07]:=PS_ENCFI
		DET[nZ][08]:=PS_CODTR
		DET[nZ][09]:=PS_ICMSP
		DET[nZ][10]:='SVC'
		DET[nZ][11]:=PS_PTRIB
		DET[nZ][12]:=PS_QTDE
		DET[nZ][13]:=recno()
		DET[nZ][14]:=0.00					//14 MEDIA
		DET[nZ][15]:=PS_VLICM
		DET[nZ][16]:=PS_BAICM
		DET[nZ][17]:=PS_CODOP
		DET[nZ][18]:='II'
		if PS_ICMSP>0
			VM_ICMT[1]+=PS_VLICM
			VM_ICMT[2]+=PS_BAICM
		end
		dbskip()
	end
else
	select('PEDDET')
	dbseek(str(P1,6),.T.)
	while !eof().and.P1==PD_PEDID
		PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
		aadd(DET,LinDetProd(++nZ))
		DET[nZ][02]:=PD_CODPR
		DET[nZ][03]:=DesProd(PROD->PR_DESCR)
		DET[nZ][04]:=PD_QTDE
		DET[nZ][05]:=PD_VALOR 	// Valor Unitário - 4 CASAS
		DET[nZ][06]:=PD_DESCV	// Desconto por Item
		DET[nZ][07]:=PD_ENCFI
		DET[nZ][08]:=PD_CODTR
		DET[nZ][09]:=PD_ICMSP
		DET[nZ][10]:=PROD->PR_UND
		DET[nZ][11]:=PD_PTRIB	// % Tributado
		DET[nZ][12]:=PD_QTDE
		DET[nZ][13]:=recno()
		DET[nZ][14]:=PD_VLRMD // Vlr Unitário Total
		DET[nZ][15]:=PD_VLICM
		DET[nZ][16]:=PD_BAICM
		DET[nZ][17]:=PD_CODOP
		DET[nZ][18]:=PROD->PR_CFTRIB // Para Impressora Fiscal
		DET[nZ][19]:=PD_NROADT
		DET[nZ][20]:=PD_CFISIPI
		DET[nZ][21]:=PD_DESTRAN
		DET[nZ][22]:=PD_DESTRAC
		if PD_ICMSP>0
			VM_ICMT[1]+=PD_VLICM
			VM_ICMT[2]+=PD_BAICM
		end
		DET[nZ][23]:=PD_CODCOF	// Codigo PIS
		DET[nZ][24]:=0.65			// % PIS tem que gravar no PD
		DET[nZ][25]:=0.00			// Base PIS tem que gravar no PD
		DET[nZ][26]:=PD_VLPIS	// Valor PIS
		DET[nZ][27]:=PD_VLCOFI	// Vlr Cofins
		DET[nZ][30]:=PD_DESCG	// Vlr Desconto Proporcional Geral NF
		
		dbskip()
	end
end
P2:=nZ
for nX:=nZ+1 to CTRNF->NF_NRLIN
	aadd(DET,LinDetProd(nX))
next
select('PEDCAB')
return (DET)

*-------------------------------------------------------------
 static function DesProd(P1)
*-------------------------------------------------------------
if !empty(PROD->PR_CODOBS)
	if XOBS->(dbseek(PROD->PR_CODOBS))
		if !empty(XOBS->OB_DESCR)
			ArrXObs(PROD->PR_CODOBS,XOBS->OB_DESCR)
			P1:=left(P1,37)+'['+PROD->PR_CODOBS+']'
		end
	end
end
//alert('Prd:'+str(PEDDET->PD_CODPR,L_P)+';obs:'+PROD->PR_CODOBS+';:'+P1)
return padr(P1,40)

*-------------------------------------------------------------
 static function ArrXObs(P1,P2)
*-------------------------------------------------------------
nX:=Ascan(XOBSX,{|DET|DET[1]==P1})
if nX==0
	nX:=Ascan(XOBSX,{|DET|DET[1]==' '})
	if nX>0
		XOBSX[nX][1]:=P1
		XOBSX[nX][2]:='['+P1+']-'+P2
	end
end
return NIL

*-------------------------------------------------------------
 function DevXObs(P1)
*-------------------------------------------------------------
if XOBSX==NIL
	XOBSX                   :=array(20,2)
	aeval(XOBSX,{|DET|DET[1]:=space(01)})
	aeval(XOBSX,{|DET|DET[2]:=space(34)})
end
return XOBSX[P1,2]

*-------------------------------------------------------------
 function DevObsPr()
*-------------------------------------------------------------
cOBSPrd:=''
if len(XOBSX)>0
	for nX:=1 to len(XOBSX)
		if !empty(XOBSX[nX,1])
			cOBSPrd+='* '+trim(XOBSX[nX,2])
		end
	end
end
return (cOBSPrd)

//----------------------------------EOF---------------------------------
