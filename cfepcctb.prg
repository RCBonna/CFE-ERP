//-----------------------------------------------------------------------------*
  static aVariav := {'',0,0}
//....................1.2.3
//-----------------------------------------------------------------------------*
#xtranslate cTipo   => aVariav\[  1 \]
#xtranslate X       => aVariav\[  2 \]

*-----------------------------------------------------------------------------*
  function CFEPCCTB(P1)	//	Associa EST->CLI/FOR
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local   VM_CAMPO
private VM_TIPO
private VM_MASC
private VM_CABE
private VM_TAMA

pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->CTADET',;
				'E->CTACTB'})
	return NIL
end
if PARAMETRO->PA_CONTAB#chr(255)+chr(25)
	beeperro()
	alert('M¢dulo de Contabilidade n„o ATIVO.')
	dbcloseall()
	return NIL
end

VM_CAMPO:=restarray('ESTOQUE.ARR')
if P1=='E' // .....................Entrada
	VM_TIPO:=array(40,7)
	for X:=1 to 40
		VM_TIPO[X,1]:=pb_zer(VM_CAMPO[X,1],2)+'-'+VM_CAMPO[X,2]
		VM_TIPO[X,2]:=0
		VM_TIPO[X,3]:=0
		VM_TIPO[X,4]:=0
		VM_TIPO[X,5]:=0
		VM_TIPO[X,6]:=0
		VM_TIPO[X,7]:=0
	end
	VM_MASC:={          masc(1), masc(3), masc(3),masc(3),masc(3),masc(3)}
	VM_CABE:={'Tipo de Estoque','CtaEst','CtaICM-R','CtaIPI-R','CtaICM-D','CtaIPI-D'}
	VM_TAMA:={               25,      6 ,        8 ,        8 ,         8,        8 }
	CFEPCCTBE()
elseif P1=='S'	//..................Saida
	VM_TIPO:=array(40,13)
	for X:=1 to 40
		VM_TIPO[X,1]:=pb_zer(VM_CAMPO[X,1],2)+'-'+VM_CAMPO[X,2]
		for X1:=1 TO 12
			VM_TIPO[X,X1+1]:=0
		next
	end
	VM_MASC:={          masc(1), masc(3), masc(3),masc(3), masc(3), masc(3),  masc(3), masc(3), masc(3), masc(3), masc(3), masc(3), masc(3)}
	VM_CABE:={'Tipo de Estoque','CEst','PICM','DICM','PIPI','DIPI','PCOF','DCOF','PPIS','DPis','RVIS','RPRZ','Cust'}
	VM_TAMA:={               25,    4 ,    4 ,     4,     4,    4,      4,     4,     4,     4,     4,     4,    4 }
	CFEPCCTBS()
elseif P1=='T'	//...............Transferencia=T1/T2
	GO TOP
	dbseek('1',.T.)//.................eliminar registros antigos
	while !eof().and.CC_TPMOV$'12'
		delete
		skip
	end

	VM_TIPO:=array(40,13)
	for X:=1 to 40
		VM_TIPO[X,1]:=pb_zer(VM_CAMPO[X,1],2)+'-'+VM_CAMPO[X,2]
		for X1:=1 TO 12
			VM_TIPO[X,X1+1]:=0
		next
	end
	VM_MASC:={          masc(1),    mI5,    mI5,    mI5,    mI5, mI2, mI2, mI2, mI2, mI2, mI2, mI2,   mI5}
	VM_CABE:={'Tipo de Estoque','C-Est','C-MTr','D-Icm','C-Icm','..','..','..','..','..','..','..','D-Est'}
	VM_TAMA:={               25,      5,      5,      5,      5,   2,   2,   2,   2,   2,   2,   2,    5 }
	//.......................1........2.......3.......4.......5....6....7....8....9...10...11...12.....13
	CFEPCCTBT('T') //...........Tipo = T
	
end
dbcloseall()
return NIL

*--------------------------------------------------------ENTRADAS-------------*
  static function CFEPCCTBE() // Rotina de Inclus„o
*--------------------------------------------------------ENTRADAS-------------*
local FORNEC:=VM_CTAFO:=VM_CTAFU:=0,VM_RT:=.F.
scroll(6,1,21,78)
pb_msg('Selecione tipo de Fornecedor',nil,.f.)
keyboard chr(K_ENTER)
@06,01 say 'Tipo de Fornecedor..........:' get FORNEC   picture masc(11) valid fn_codar(@FORNEC,'TIPOFOR.ARR')
read
if lastkey()#K_ESC
	pb_msg('Entre com as Contas Contabeis',NIL,.T.)
	VM_CTAFO:=fn_lecc('E',FORNEC,0, 0)
	VM_CTAJU:=fn_lecc('E',FORNEC,0, 1)
	VM_CTADE:=fn_lecc('E',FORNEC,0, 2)
	VM_CTAFU:=fn_lecc('E',FORNEC,0, 3)
	VM_CTAAD:=fn_lecc('E',FORNEC,0, 4)
	VM_CTSOB:=fn_lecc('E',FORNEC,0, 5)	// Pagamento das Sobras de Distribuição dos Sócios
	VM_CTQUO:=fn_lecc('E',FORNEC,0, 6)	// Pagamento Saida de Sócios Sócios
	VM_RT   :=.T.

	dbseek('E'+str(FORNEC,2)+str(0,2)+str(10,2),.T.)
	dbeval({||VM_TIPO[CC_TPEST,CC_SEQUE-9]:=CC_CONTA},,{||CC_TPMOV='E'.and.CC_TPCFO==FORNEC})
	@07,01 say 'Conta Fornecedor............:' get VM_CTAFO picture masc(03) valid fn_ifconta(,@VM_CTAFO)
	@08,01 say 'Conta Juros Pagos...........:' get VM_CTAJU picture masc(03) valid fn_ifconta(,@VM_CTAJU)
	@09,01 say 'Conta Desc Recebido.........:' get VM_CTADE picture masc(03) valid fn_ifconta(,@VM_CTADE)
	@10,01 say 'Conta Funrural..............:' get VM_CTAFU picture masc(03) valid fn_ifconta(,@VM_CTAFU)
	@11,01 say 'Conta Adto Fornecedor.......:' get VM_CTAAD picture masc(03) valid fn_ifconta(,@VM_CTAAD)
	@12,01 say 'Conta Bx Distrib (SOB)......:' get VM_CTSOB picture masc(03) valid fn_ifconta(,@VM_CTSOB) when pb_msg('Conta DEBITO - para baixa de valores para SOBras de Distrib Contas')
	@13,01 say 'Conta Bx Saida Socios (QUO).:' get VM_CTQUO picture masc(03) valid fn_ifconta(,@VM_CTQUO) when pb_msg('Conta DEBITO - para baixa de valores Saidas de Socios')
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		setcolor('W+/GB')
		while .T.
			pb_msg('Selecione tipo de Estoque',nil,.f.)
			salvacor(SALVA)
			OPC:=Abrowse(9,0,22,79,VM_TIPO,VM_CABE,VM_TAMA,VM_MASC)
			if OPC>0.and.OPC<len(VM_TIPO)
				if empty(VM_TIPO[OPC,1])
					alert('Tipo de Estoque n„o definido.')
					loop
				end
				VM_CTA01:=VM_TIPO[OPC,2]
				VM_CTA02:=VM_TIPO[OPC,3]
				VM_CTA03:=VM_TIPO[OPC,4]
				VM_CTA04:=VM_TIPO[OPC,5]
				VM_CTA05:=VM_TIPO[OPC,6]
				pb_box(16,0,,,,"Contas Contabeis Entradas")
				@17,2 say 'D-Cta Estoque.....:' get VM_CTA01 picture masc(03) valid VM_CTA01==0.or.fn_ifconta(,@VM_CTA01)
				@18,2 say 'D-Cta ICMS-Recup..:' get VM_CTA02 picture masc(03) valid VM_CTA02==0.or.fn_ifconta(,@VM_CTA02)
				@19,2 say 'D-Cta IPI-Recup...:' get VM_CTA03 picture masc(03) valid VM_CTA03==0.or.fn_ifconta(,@VM_CTA03)
				@20,2 say 'C-Cta ICMS-S/Compr:' get VM_CTA04 picture masc(03) valid VM_CTA04==0.or.fn_ifconta(,@VM_CTA04)
				@21,2 say 'C-Cta IPI-S/Compra:' get VM_CTA05 picture masc(03) valid VM_CTA05==0.or.fn_ifconta(,@VM_CTA05)
				read
				salvacor(RESTAURA)
				if if(lastkey()#K_ESC,pb_sn(),.F.)
					VM_TIPO[OPC,2]:=VM_CTA01
					VM_TIPO[OPC,3]:=VM_CTA02
					VM_TIPO[OPC,4]:=VM_CTA03
					VM_TIPO[OPC,5]:=VM_CTA04
					VM_TIPO[OPC,6]:=VM_CTA05
					VM_RT:=.T.
				end
			elseif VM_RT.and.pb_sn('Sair dos lan‡amentos de contas e gravar ?')
				exit
			elseif !VM_RT
				exit
			end
		end
		if VM_RT
			fn_grcc('E',FORNEC,0, 0,VM_CTAFO)
			fn_grcc('E',FORNEC,0, 1,VM_CTAJU)
			fn_grcc('E',FORNEC,0, 2,VM_CTADE)
			fn_grcc('E',FORNEC,0, 3,VM_CTAFU)
			fn_grcc('E',FORNEC,0, 4,VM_CTAAD)
			fn_grcc('E',FORNEC,0, 5,VM_CTSOB)
			fn_grcc('E',FORNEC,0, 6,VM_CTQUO)
			for X:=1 to len(VM_TIPO)
				fn_grcc('E',FORNEC,X,11,VM_TIPO[X,2])
				fn_grcc('E',FORNEC,X,12,VM_TIPO[X,3])
				fn_grcc('E',FORNEC,X,13,VM_TIPO[X,4])
				fn_grcc('E',FORNEC,X,14,VM_TIPO[X,5])
				fn_grcc('E',FORNEC,X,15,VM_TIPO[X,6])
			end
		end
	end
end
return NIL

*------------------------------------------------------------SAIDA------------*
  static function CFEPCCTBS() // Rotina de Inclus„o
*------------------------------------------------------------SAIDA------------*
local FORNEC:=VM_CTAFO:=VM_CTAFU:=0,VM_RT:=.F.
scroll(6,1,21,78)
pb_msg('Selecione tipo de Cliente',nil,.f.)
keyboard chr(K_ENTER)
@06,01 say 'Tipo de Cliente...:' get FORNEC   picture masc(11) valid fn_codar(@FORNEC,'TIPOCLI.ARR')
read
if lastkey()#K_ESC
	pb_msg('Entre com as Contas Contabeis',nil,.f.)
	VM_CTAFO:=fn_lecc('S',FORNEC,0, 0)
	VM_CTAJU:=fn_lecc('S',FORNEC,0, 1)
	VM_CTADE:=fn_lecc('S',FORNEC,0, 2)
	VM_CTAFU:=fn_lecc('S',FORNEC,0, 3)
	VM_CTAAD:=fn_lecc('S',FORNEC,0, 4)
	VM_CTARC:=fn_lecc('S',FORNEC,0, 5) // Recebimento de Integralização de Sócios

	dbseek('S'+str(FORNEC,2)+str(0,2)+str(10,2),.T.)
	dbeval({||VM_TIPO[CC_TPEST,CC_SEQUE-9]:=CC_CONTA},,{||CC_TPMOV='S'.and.CC_TPCFO==FORNEC})
	@07,1 say 'Conta Clientes....:' get VM_CTAFO picture masc(03) valid fn_ifconta(,@VM_CTAFO)
	@08,1 say 'Conta Juros Receb.:' get VM_CTAJU picture masc(03) valid fn_ifconta(,@VM_CTAJU)
	@09,1 say 'Conta Desc Conced.:' get VM_CTADE picture masc(03) valid fn_ifconta(,@VM_CTADE)
	@11,1 say 'Conta Adto Client.:' get VM_CTAAD picture masc(03) valid fn_ifconta(,@VM_CTAAD)
	@12,1 say 'Conta Rec.Ent.Soc.:' get VM_CTARC picture masc(03) valid fn_ifconta(,@VM_CTARC) when pb_msg('Conta CREDITO para recebimento de valores entrada de Socios-Cota Parte-Receber')
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		setcolor('W+/GB')
		while .t.
			salvacor(SALVA)
			pb_msg('Selecione tipo de Estoque',nil,.f.)
			OPC:=abrowse(9,0,22,79,VM_TIPO,VM_CABE,VM_TAMA,VM_MASC)
			if OPC>0.and.OPC<len(VM_TIPO)
				if empty(VM_TIPO[OPC,1])
					alert('Tipo de Estoque n„o definido.')
					loop
				end
				for X=1 to 12
					X1='VM_CTA'+pb_zer(X,2)
					&X1=VM_TIPO[OPC,X+1]
				end
				pb_box(09,0,,,,"Contas Contabeis Saidas")
				@10,2 say 'C-Conta Estoque....:' get VM_CTA01 picture masc(03) valid VM_CTA01==0.or.fn_ifconta(,@VM_CTA01)
				@11,2 say 'C-Conta ICMS-Recup.:' get VM_CTA02 picture masc(03) valid VM_CTA02==0.or.fn_ifconta(,@VM_CTA02)
				@12,2 say 'D-Conta ICMS-Desp..:' get VM_CTA03 picture masc(03) valid VM_CTA03==0.or.fn_ifconta(,@VM_CTA03)
				@13,2 say 'C-Conta IPI -Recup.:' get VM_CTA04 picture masc(03) valid VM_CTA04==0.or.fn_ifconta(,@VM_CTA04)
				@14,2 say 'D-Conta IPI -Desp..:' get VM_CTA05 picture masc(03) valid VM_CTA05==0.or.fn_ifconta(,@VM_CTA05)
				@15,2 say 'C-Conta COFINS-Pass:' get VM_CTA06 picture masc(03) valid VM_CTA06==0.or.fn_ifconta(,@VM_CTA06)
				@16,2 say 'D-Conta COFINS-Desp:' get VM_CTA07 picture masc(03) valid VM_CTA07==0.or.fn_ifconta(,@VM_CTA07)
				@17,2 say 'C-Conta PIS-Pass...:' get VM_CTA08 picture masc(03) valid VM_CTA08==0.or.fn_ifconta(,@VM_CTA08)
				@18,2 say 'D-Conta PIS-Desp...:' get VM_CTA09 picture masc(03) valid VM_CTA09==0.or.fn_ifconta(,@VM_CTA09)
				@19,2 say 'C-Conta Venda Vista:' get VM_CTA10 picture masc(03) valid VM_CTA10==0.or.fn_ifconta(,@VM_CTA10)
				@20,2 say 'C-Conta Venda Prazo:' get VM_CTA11 picture masc(03) valid VM_CTA11==0.or.fn_ifconta(,@VM_CTA11)
				@21,2 say 'D-Conta Custo Merc.:' get VM_CTA12 picture masc(03) valid VM_CTA12==0.or.fn_ifconta(,@VM_CTA12)
				read
				salvacor(RESTAURA)
				if if(lastkey()#K_ESC,pb_sn(),.F.)
					for X:=1 to 12
						X1:='VM_CTA'+pb_zer(X,2)
						VM_TIPO[OPC,X+1]:=&X1
					end
					VM_RT:=.T.
				end
			elseif VM_RT.and.pb_sn('Sair dos lan‡amentos de contas e gravar ?')
				exit
			elseif !VM_RT
				exit
			end
		end
		if VM_RT
			fn_grcc('S',FORNEC,0, 0,VM_CTAFO)
			fn_grcc('S',FORNEC,0, 1,VM_CTAJU)
			fn_grcc('S',FORNEC,0, 2,VM_CTADE)
			fn_grcc('S',FORNEC,0, 4,VM_CTAAD)
			fn_grcc('S',FORNEC,0, 5,VM_CTARC)
			for X:=1 to len(VM_TIPO)
				for X1:=1 to 12
					fn_grcc('S',FORNEC,X,X1+10,VM_TIPO[X,X1+1])
				next
			end
		end
	end
end
return NIL

//--------------------------------------------------------TRANSFERENCIAS-------*
  static function CFEPCCTBT(pTipo) // Rotina de Inclus„o
//--------------------------------------------------------TRANSFERENCIAS-------*
local FORNEC  :=0
local VM_CTAFO:=0
local VM_CTAFU:=0
local VM_RT   :=.F.
private X1

scroll(6,1,21,78)
pb_msg('Selecione tipo de Fornecedor',nil,.f.)
keyboard chr(K_ENTER)
@6,1 say 'Tipo de Cliente...:' get FORNEC   picture masc(11) valid fn_codar(@FORNEC,'TIPOCLI.ARR')
@7,1 say 'Tipo Transferencia: '+pTipo 
read
if lastkey()#K_ESC
	pb_msg('Entre com as Contas Contabeis',nil,.f.)
	VM_CTAFO:=fn_lecc(pTipo,FORNEC,0, 0)
	VM_CTAJU:=fn_lecc(pTipo,FORNEC,0, 1)
	VM_CTADE:=fn_lecc(pTipo,FORNEC,0, 2)
	VM_CTAFU:=fn_lecc(pTipo,FORNEC,0, 3)
	VM_CTAAD:=fn_lecc(pTipo,FORNEC,0, 4)

	dbseek(pTipo+str(FORNEC,2)+str(0,2)+str(10,2),.T.)
	dbeval({||VM_TIPO[CC_TPEST,CC_SEQUE-9]:=CC_CONTA},,{||CC_TPMOV==pTipo.and.CC_TPCFO==FORNEC})
	setcolor('W+/GB')
	while .T.
		pb_msg('Selecione tipo de Estoque',nil,.f.)
		salvacor(SALVA)
		OPC:=abrowse(9,0,22,79,VM_TIPO,VM_CABE,VM_TAMA,VM_MASC)
		if OPC>0.and.OPC<len(VM_TIPO)
			if empty(VM_TIPO[OPC,1])
				alert('Tipo de Estoque n„o definido.')
				loop
			end
			for X:=1 to 12
				X1:='VM_CTA'+pb_zer(X,2)
				&X1:=0
			end
			VM_CTA01:=VM_TIPO[OPC,02]// 
			VM_CTA02:=VM_TIPO[OPC,03]
			VM_CTA03:=VM_TIPO[OPC,04]
			VM_CTA04:=VM_TIPO[OPC,05]
			VM_CTA12:=VM_TIPO[OPC,13]
			X:=16
			pb_box(X++,0,,,,'Contas de Transferencias')
			@X++,2 say 'C-Cta Estoque..:' get VM_CTA01 picture masc(03) valid VM_CTA01==0.or.fn_ifconta(,@VM_CTA01)
			@X++,2 say 'C-Marg.Transf..:' get VM_CTA02 picture masc(03) valid VM_CTA02==0.or.fn_ifconta(,@VM_CTA02)
			@X++,2 say 'D-ICMS-Desp....:' get VM_CTA03 picture masc(03) valid VM_CTA03==0.or.fn_ifconta(,@VM_CTA03)
			@X++,2 say 'C-ICMS-Recup...:' get VM_CTA04 picture masc(03) valid VM_CTA04==0.or.fn_ifconta(,@VM_CTA04)
			@X++,2 say 'D-Cta Estoque..:' get VM_CTA12 picture masc(03) valid VM_CTA12==0.or.fn_ifconta(,@VM_CTA12)
			read
			salvacor(RESTAURA)
			if if(lastkey()#K_ESC,pb_sn(),.F.)
				for X:=1 to 12
					X1:='VM_CTA'+pb_zer(X,2)
					VM_TIPO[OPC,X+1]:=&X1
				end
				VM_RT:=.T.
			end
		elseif VM_RT.and.pb_sn('Sair dos lan‡amentos de contas e gravar ?')
			exit
		elseif !VM_RT
			exit
		end
	end
	if VM_RT
		fn_grcc(pTipo,FORNEC,0, 0,VM_CTAFO)
		fn_grcc(pTipo,FORNEC,0, 1,VM_CTAJU)
		fn_grcc(pTipo,FORNEC,0, 2,VM_CTADE)
		fn_grcc(pTipo,FORNEC,0, 3,VM_CTAFU)
		for X:=1 to len(VM_TIPO)
			for X1:=1 to 12
				fn_grcc(pTipo,FORNEC,X,X1+10,VM_TIPO[X,X1+1])
			next
		end
	end
end
return NIL

//-----------------------------------------------------------------------------*
  function FN_GRCC(P1,P2,P3,P4,P5)	//<<<<<<<<<<<<<<<<< MELHORAR
//-----------------------------------------------------------------------------*
if !dbseek(P1+str(P2,2)+str(P3,2)+str(P4,2))
	dbappend(.T.)
end
replace  CC_TPMOV with P1,;//Tipo de Contabilização (E-ENTRADA S-SAIDA 1=TRANSFERENCIA)
			CC_TPCFO with P2,;//Codigo grupo de Fornecedor/Cliente
			CC_TPEST with P3,;//Codigo grupo de Produtos
			CC_SEQUE with P4,;//Sequencia (dentro de cada Tipo)
			CC_CONTA with P5	//Código da Conta Contábil
if P5==0
	dbdelete()
end
return NIL

//--------------------------------------------------------------------------*
  function FN_LECC(P1,P2,P3,P4)
//--------------------------------------------------------------------------*
local VM_CTA01:=0
salvabd(.T.)
select('CTACTB')
if dbseek(P1+str(P2,2)+str(P3,2)+str(P4,2))
	VM_CTA01=CC_CONTA
end
salvabd(.F.)
return(VM_CTA01)

//-------------------------> MELHORAR FAZER IMPRESSAO
