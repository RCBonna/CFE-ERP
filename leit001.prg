*---------------------------------------------------------------------------------------*
static aVariav := {1, 2, {},0,0}
 //.................1.2...3.4.5..........
*---------------------------------------------------------------------------------------*
#xtranslate nRota		=> aVariav\[  1 \]
#xtranslate nSeq		=> aVariav\[  2 \]
#xtranslate aRotSeq	=> aVariav\[  3 \]
#xtranslate nReg		=> aVariav\[  4 \]
#xtranslate nUltReg	=> aVariav\[  5 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
 function LEIT001()	//	Cadastro de Produtores de Leite								*
*-----------------------------------------------------------------------------*
local TF:=savescreen()
//SetMode(50,132)
//cls
//Dispbox(0,MaxCol(),         4,MaxCol())
//DispBox(5,MaxCol(),  MaxRow(),MaxCol())
SALVABANCO
pb_tela()
pb_lin4("Cadastro Produtores Leite",ProcName())
select CLIENTE
ORDEM LEITE
DbGoTop()
if CLIENTE->CL_LEITSQ<10000
	DbSetOrder(0) // por registros
	DbGoTop()
	if FilLock()
		DbEval({||CLIENTE->CL_LEITSQ:=if(CLIENTE->CL_LEITSQ<10000.and.CLIENTE->CL_LEITSQ>0,CLIENTE->CL_LEITSQ+10000,CLIENTE->CL_LEITSQ)})
	end
	ORDEM LEITE
	DbGoTop()
end
pb_dbedit1('LEIT001','AlteraReord.Bonif.Limpar')  // tela
VM_CAMPO:={	'transform(CL_LEITSQ,masc(58))',;
				'pb_zer(CL_CODCL,5)+"-"+left(CL_RAZAO,5)','left(CL_STATUS,41)','left(CL_NFPR,10)'}
VM_CABE :={'Rota',     'C¢dig-Nome',													'Gordur|Protei|E.S.D.| C.C.S.| C.P.P.|BONUS','NRNF-Prod'}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
ORDEM CODIGO
//SetMode(25,80)
//pb_tela()
restscreen(,,,,TF)
RESTAURABANCO
DbGoTop()
Keyboard chr(27)
return NIL

*-------------------------------------------------------------------* Fim
 function LEIT0011() // Rotina Altera
*-------------------------------------------------------------------*
local RegAnt
local VM_NFPR:=space(20)
nRota:=1
nSeq :=1
CLI  :=0
ORDEM CODIGO
pb_box(16,20,,,,'LEITE-Rotas')
@17,22 say 'Produtor......:' get CLI     pict mI5  valid fn_codigo(@CLI,  {'CLIENTE', {||CLIENTE->(dbseek(str(CLI,5)))}, ,{2,1}})
@19,22 say 'Rota Numero...:' get nRota   pict mI2  valid nRota>= 0                                   when pb_msg('Podem ser informados até 99 rotas diferentes').and.(nRota:=trunca(CLIENTE->CL_LEITSQ/10000,0))>=0
@20,22 say 'Sequencia Rota:' get nSeq 	pict mI4  valid NSeq >= 0.and.ChkSeq(CLI,nRota*10000+nSeq)	when pb_msg('Use sequencias de 10 em 10 para permitir inclusoes').and.(nSeq:=CLIENTE->CL_LEITSQ-trunca(CLIENTE->CL_LEITSQ/10000,0)*10000)>=0
@21,22 say 'NF-Prod.Rural.:' get VM_NFPR pict mUUU 														         when pb_msg('Informe o NRO NF do Produtor Rural - Ref Mes').and.(VM_NFPR:=CLIENTE->CL_NFPR)>=''
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if RecLock()
		Replace 	CLIENTE->CL_LEITSQ with nRota*10000+nSeq,;
					CLIENTE->CL_NFPR   with VM_NFPR
	end
	DBcommitall()
end
ORDEM LEITE
DbGoTop()
return NIL

*-------------------------------------------------------------------* 
static function ChkSeq(pCli,pSeq)
*-------------------------------------------------------------------* 
local RT    :=.T.
local RegAnt:=CLIENTE->(recno())
if pSeq == CLIENTE->CL_LEITSQ .or. pSeq==0
	RT:=.T.
else
	ORDEM LEITE
	if dbseek(str(pSeq,6))
		alert('Sequencia ja existe')
		RT:=.F.
	end
	ORDEM CODIGO
	DbGoTo(RegAnt)
end
return RT

*-------------------------------------------------------------------* Fim
 function LEIT0012() // Calculo de sequencia
*-------------------------------------------------------------------*
if pb_sn('Sera reordando a numeracao;CONFIRMA??')
	ORDEM LEITE
	if FilLock()
		pb_msg('Recalculando Novas Sequencias.... Aguarde.')
		go top
		while !eof()
			nRota  :=trunca(CLIENTE->CL_LEITSQ/10000,0) //Rota inicial
			aRotSeq:={}
			nReg    :=10
			while !eof().and.nRota==trunca(CLIENTE->CL_LEITSQ/10000,0)
				aadd(aRotSeq,{RecNo(),nReg})
				nReg+=10	// número total de registros
				skip
				nUltReg:=RecNo()
			end
			GravaSeqRota()
			DbGoTo(nUltReg) // Voltar para último registro processado
		end
	end
	dbunlock()
end
return NIL

*-------------------------------------------------------------------*
static function GravaSeqRota()
*-------------------------------------------------------------------*
for nReg:=1 to len(aRotSeq)
	DbGoTo(aRotSeq[nReg,1])
	replace CLIENTE->CL_LEITSQ with nRota*10000+aRotSeq[nReg,2]	
next
return NIL

*-------------------------------------------------------------------*
 function LEIT0013() // Rotina Bonificação
*-------------------------------------------------------------------*
local Vlr      :={0,0,0,0,0,0}
local ProdLeite:={}
local lCont  :=.T.
local CStatus
local OPC:=-1
DbGoTop()
while !eof()
   CStatus:=if(len(trim(CL_STATUS))<=30,'0.0100|0.0000|0.0000| 0.0000| 0.0000|0.00|',CL_STATUS)
	//.........................................1......2......3......4......5......6
	Vlr[1]:=val(token(CStatus,'|',1))	// 1-Gordura
	Vlr[2]:=val(token(CStatus,'|',2))	// 2-Proteina
	Vlr[3]:=val(token(CStatus,'|',3))	// 3-ESD
	Vlr[4]:=val(token(CStatus,'|',4))	// 4-CCS
	Vlr[5]:=val(token(CStatus,'|',5))	// 5-CPP
	Vlr[6]:=val(token(CStatus,'|',6))	// 6-Bonus
	aadd(ProdLeite,{	CL_LEITSQ,; //...1
							pb_zer(fieldget(1),5)+chr(45)+left(fieldget(2),30),;//...2
							Vlr[1],;//...3-Gordura
							Vlr[2],;//...4-Proteina
							Vlr[3],;//...5-ESD
							Vlr[4],;//...6-CCS
							Vlr[5],;//...7-CPP
							Vlr[6],;//...8-Bonus
							recno(),;//..9-Nro Registro no Cad Cliente
							.F.})// 10 - NÃO ALTERADO
	skip
end
if len(ProdLeite)>0
	setcolor('W+/G,N/W,,,W+/G')
	pb_msg('Pressione ESC para SAIR')
	OPC:=1
	Keyboard chr(13)
	while OPC>0
		OPC:=Abrowse(5,0,22,79,ProdLeite,{'Rota','Codig-Produtor','Gordur','Protei','E.S.D.','C.C.S.','C.P.P.','BONUS' },;
													{    6,              29 ,      6 ,      6 ,      6 ,      7 ,      7 ,     4	},;
													{  mI6,             mXXX,    mI64,   mI64 ,   mI64 ,    mI74,    mI74,   mD12 },,;
													'Valores para produtores de Leite')
		if OPC>0
			Vlr[1]:=ProdLeite[OPC,3]
			Vlr[2]:=ProdLeite[OPC,4]
			Vlr[3]:=ProdLeite[OPC,5]
			Vlr[4]:=ProdLeite[OPC,6]
			Vlr[5]:=ProdLeite[OPC,7]
			Vlr[6]:=ProdLeite[OPC,8]
//			Keyboard chr(13)+chr(13)
			@row(),38 get Vlr[1] pict mI64 valid Vlr[1]>=0	// 1-Gordura
			@row(),45 get Vlr[2] pict mI64 valid Vlr[2]>=0	// 2-Proteina
			@row(),52 get Vlr[3] pict mI64 valid Vlr[3]>=0	// 3-ESD
			@row(),59 get Vlr[4] pict mI74 valid Vlr[4]<=1	// 4-CCS
			@row(),67 get Vlr[5] pict mI74 valid Vlr[5]<=1	// 5-CPP
			@row(),75 get Vlr[6] pict mD12 valid Vlr[6]>=0	// 6-Bonus
			read
			if lastkey()#K_ESC
				ProdLeite[OPC,03]:=Vlr[1]
				ProdLeite[OPC,04]:=Vlr[2]
				ProdLeite[OPC,05]:=Vlr[3]
				ProdLeite[OPC,06]:=Vlr[4]
				ProdLeite[OPC,07]:=Vlr[5]
				ProdLeite[OPC,08]:=Vlr[6]
				ProdLeite[OPC,10]:=.T. // ALTERADO
				if OPC # len(ProdLeite)
					Keyboard replicate(chr(K_DOWN),OPC++)+chr(13)
				end
			else
				Vlr[1]:=Alert('TOMAR ACAO',{'Gravar','Sair','Digitar'})
				if Vlr[1]==1
					OPC:=0
				elseif Vlr[1]==2
					OPC:=-1
				else
					OPC:=1
				end
			end
		end
	end
end
if OPC<0
	*.....sair sem gravar
else
	for OPC:=1 to len(ProdLeite)
		pb_msg('Gravando dados alterados...'+str(OPC,5))
		if ProdLeite[OPC,10] // Alterado?
			DbGoTo(ProdLeite[OPC,9])
			while !reclock();end
			CStatus:=str(ProdLeite[OPC,3],6,4)+'|'+;	// 1-Gordura
						str(ProdLeite[OPC,4],6,4)+'|'+;	// 2-Proteina
						str(ProdLeite[OPC,5],6,4)+'|'+;	// 3-ESD
						str(ProdLeite[OPC,6],7,4)+'|'+;	// 4-CCS
						str(ProdLeite[OPC,7],7,4)+'|'+;	// 5-CPP
						str(ProdLeite[OPC,8],4,2)+'|'		// 6-Bonus
			replace CLIENTE->CL_STATUS with CStatus
		end
	next
	DBUnlockAll()
	DBCommitAll()
end
DbGoTop()
setcolor(VM_CORPAD)
return NIL

*-------------------------------------------------------------------* Fim
 function LEIT0014() // Limpar NFPR
*-------------------------------------------------------------------*
if pb_sn('Limpar valores digitados para;nro das NF Prod.Rural?')
	DbGoTop()
	while !eof()
		if !empty(CLIENTE->CL_NFPR)
			if RecLock()
				replace CLIENTE->CL_NFPR with ''
			end
			DBUnlock()
		end
		skip
	end
	DBCommitAll()
	DbGoTop()
end
return NIL
//--------------------------------------------------EOF---------------------*
