*-----------------------------------------------------------------------------*
  static aVariav := {0,,115,'',{},{},{},"",.f.,0,{}}
*--------------------1----2--3--4--5--6--7--8--9-10-----------------------------*
#xtranslate PAG		=> aVariav\[  1 \]
#xtranslate LAR		=> aVariav\[  2 \]
#xtranslate REL		=> aVariav\[  3 \]
#xtranslate VM_TIPO  => aVariav\[  4 \]
#xtranslate nX			=> aVariav\[  5 \]
#xtranslate aOpcoes	=> aVariav\[  6 \]
#xtranslate nArqTemp	=> aVariav\[  7 \]
#xtranslate lRT		=> aVariav\[  8 \]
#xtranslate nDPL		=> aVariav\[  9 \]
#xtranslate aDados	=> aVariav\[ 10 \]

*-----------------------------------------------------------------------------*
function CFEPCCCS(P1) // Dpls.a Pagar/Receber por BANCO							*
*						P1='CL'=CLIENTES	/	P1='FO'=FORNECEDORES							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

PAG		:=0
REL		:='Duplicatas dos '+if(P1='CL','Clientes','Fornecedores')
aOpcoes	:={"S","N","A","V"}
VM_TIPO	:={}

aadd(VM_TIPO,if(P1='CL','CLIENTE','FORNEC'))
aadd(VM_TIPO,if(P1='CL','DPCLI'  ,'DPFOR'))
aadd(VM_TIPO,if(P1='CL','HISCLI' ,'HISFOR'))
aadd(VM_TIPO,'') // NOME
aadd(VM_TIPO,if(P1='CL',{	'R->PARAMETRO',;
									'R->MOEDA',;
									'R->CLIENTE',;
									'R->HISCLI',;
									'R->DPCLI'},;
								{	'R->PARAMETRO',;
									'R->MOEDA',;
									'R->CLIENTE',;
									'R->HISFOR',;
									'R->DPFOR'}))

pb_lin4(REL,ProcName())
if !abre(VM_TIPO[5])
	return NIL
end
VM_FIM :=&(fieldname(2))
dbsetorder(5) // SELECIONA ORDEM --- CODIGO + DATA EMISSÃO
VM_COD :=0
VM_DATA:={ctod("01/01/1900"),bom(PARAMETRO->PA_DATA)-1}
nX:=16
pb_box(nX++,26,,,,'Selecione')
@nX++,28 say padr('Data Inicio',20,'.') get VM_DATA[1] picture mDT when .F.
@nX++,28 say padr('Data Fim',20,'.')    get VM_DATA[2] picture mDT valid VM_DATA[2]>=VM_DATA[1]
@nX  ,28 say padr(VM_TIPO[1],20,'.')    get VM_FIM     picture masc(4) valid if(VM_FIM==0,.T.,fn_codigo(@VM_FIM,{'CLIENTE',{||dbseek(str(VM_FIM,5))},,{2,1}}))
@nX++,55 say '[0 - para todos]'
@nX++,28 say padr(VM_TIPO[1]+' Zerado?',20,'.') get aOpcoes[2] picture mUUU valid aOpcoes[2]$"SN" when pb_msg('S-Lista clientes com saldo zero    N-So lista clientes com Saldo')
@nX  ,28 say padr('Dpl Zerada?',20,'.') 			get aOpcoes[1] picture mUUU valid aOpcoes[1]$"SN" when pb_msg('S-Lista duplicatas zeradas   N-So lista duplicatas com Saldo')
@nX  ,60 say padr('Tipo Impress',13,'.') 			get aOpcoes[3] picture mUUU valid aOpcoes[3]$"AS" when pb_msg('S-Sintetico  A-Analitico')

read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(if(aOpcoes[3]=='A',I15CPP,C15CPP)),.F.)
	nArqTemp:= ArqTemp(,,'')
	dbatual(nArqTemp,;
				{{'XX_CODCLI', 'N',  5,  0},; //  1-Cod+(Cli OU Fornec)
				 {'XX_DUPLIC', 'N',  9,  0},; //  2-Nro Dpl (0000) saldo Anterior
				 {'XX_DTEMIS', 'D',  8,  0},; //  3-Data Emissão
				 {'XX_DTVENC', 'D',  8,  0},; //  4-Data Vencimento
				 {'XX_DTPGTO', 'D',  8,  0},; //  5-Data Pgto
				 {'XX_VLTOT',  'N', 15,  2},; //  6-Valor Total
				 {'XX_VLPAGO', 'N', 15,  2},; //  7-Valor Pago
				 {'XX_VLJURO', 'N', 15,  2},; //  8-Valor Pago-Juros
				 {'XX_VLDESC', 'N', 15,  2},; //  9-Valor Pago-Desc
				 {'XX_RECNO',  'N',  8,  0}}) // 10-nr do registro

	if !net_use(nArqTemp,.T.,20,'TEMP',.T.,.F.,RDDSETDEFAULT())
		dbcloseall()
		return NIL
	end

	Index on str(XX_CODCLI,5) + str(XX_DUPLIC,9) tag CODIGO    to (nArqTemp)

	select CLIENTE
	VM_FIMX:=max(VM_FIM,99999)
	dbseek(str(VM_FIM,5),.T.)
	REL  :='Saldo de '+VM_TIPO[1]+' ate '+dtoc(VM_DATA[2])
	LAR  :=if(aOpcoes[3]=='A',115,81)
	Saldo:={0,0,0,0}
	while !eof().and.if(VM_FIM==0,.T.,&(fieldname(1))==VM_FIM)
		VM_TIPO[4]	:=FieldGet(2) // NOME DO CLIENTE X FORNECEDOR
		VM_COD		:=FieldGet(1)
		pb_msg('Listando:'+str(VM_COD,5)+'-'+VM_TIPO[4])
		PAG			:=if(aOpcoes[3]=='A',0,PAG)
		if GeraDPL(VM_COD) // codigo Cliente+Fornecedor TEM MOVIMENTO?
			select TEMP // arquivo gerado
			go top
			Saldo[2]:=0
			dbeval({||Saldo[2]:=Saldo[2]+(XX_VLTOT-XX_VLPAGO)})
			if aOpcoes[2]=="S".or.str(Saldo[2],15,2)#str(0,15,2)
				if aOpcoes[3]=='S'
					PAG  :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEPCCCSC',LAR)
					?pb_zer(VM_COD,5)+'-'+VM_TIPO[4]
				end
				go top
				while !eof()
					if aOpcoes[1]=="S".or.str(XX_VLTOT-XX_VLPAGO,15,2)#str(0,15,2)
						if aOpcoes[3]=='A' // analitico
							PAG  :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEPCCCSC',LAR)
							 ?transform(XX_DUPLIC,				mDPL) +" "
							??transform(XX_DTEMIS,				mDT)  +" "
							??transform(XX_DTVENC,				mDT)  +" "
							??transform(XX_DTPGTO,				mDT)  +" "
							??transform(XX_VLTOT,				mD82) +" "
							??transform(XX_VLPAGO,				mD82) +" "
							??transform(XX_VLJURO,				mD82) +" "
							??transform(XX_VLDESC,				mD82) +" "
							??transform(XX_VLTOT-XX_VLPAGO,	mD82)
						end
						Saldo[1]+=(XX_VLTOT-XX_VLPAGO)
					end
					skip
				end
				Saldo[3]+=Saldo[1]
				if aOpcoes[3]=='A' // analitico
					? padl('Saldo em '+dtoc(VM_DATA[2]),93)
				end
				??transform(Saldo[1],mD132)
				if aOpcoes[3]=='S' // Sintetico
					??transform(Saldo[3],mD132) // Acumulado
				else
					?replicate('-',LAR)
					eject
				end
				Saldo[1]:=0
			end
			Zap
			Pack
		end
		select CLIENTE
		pb_brake()
	end
	if aOpcoes[3]=='A' // Sintetico
		? padl('Saldo total em '+dtoc(VM_DATA[2]),93)
		??transform(Saldo[3],mD132)
	end
	?replicate('-',LAR)
	?time()
	pb_deslimp(C15CPP)
	FileDelete (nArqTemp + '.*')
	ferase(nArqTemp+OrdBagExt())
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
static function GERADPL(pCod) // duplicatas a pagar
*-----------------------------------------------------------------------------*
lRT   :=.F.
nDPL  :=0
*------------------------------------------------------------->Dpl Pendentes
select(VM_TIPO[2])
*------------------------------------------------------------->Dpl Pendentes
dbseek(str(pCod,5),.T.)
while !eof().and.pCod==FieldGet(2) // Cliente ou Fornecedor
//	alert('Data Pend.'+dtoc(FieldGet(4))+';Data Input'+dtoc(VM_DATA[2])
	if FieldGet(3)<=VM_DATA[2] // Emissão antes = do periodo
		nDPL  :=FieldGet(1)
		aDados:={FieldGet(3),FieldGet(4),FieldGet(5),FieldGet(6)}
		//........DT EMI.....DT Venc.....DT Pgto.....Vlr DPL
		SALVABANCO
		select TEMP
		if dbseek(str(pCod,5)+str(nDPL,9))
			FieldPut(6,FieldGet(6)+aDados[4])
		else
			AddRec(,{;
					pCod,;		// 1-Codigo Cli ou Forec
					nDPL,;		// 2-é saldo anterior
					aDados[1],;	//	3 DT Emissão
					aDados[2],;	//	4 DT Vencimento
					aDados[3],;	//	5 DT Pgto
					aDados[4],;	// 6-Valor total
					0,;// 			7 Valor pago
					0,;// 			8 Valor pago-Juros
					0,;// 			9 Valor pago-Descr
					0;//				10
					})
		end
		RESTAURABANCO
		lRT:=.T.
	end
	skip
end

*----------------------------------------------------------------> HISTORICO
select(VM_TIPO[3]) // LER HISTÓRICO
*----------------------------------------------------------------> HISTORICO
dbseek(str(pCod,5),.T.)
while !eof().and.pCod==FieldGet(1)
	if FieldGet(3)<=VM_DATA[2] // Emissão antes = do período?
		nDPL  :=FieldGet(2)
		aDados:={FieldGet(3),;	//1-DT EMI
					FieldGet(4),;	//2-DT VENC
					if(FieldGet(5)<=VM_DATA[2],FieldGet(5),ctod('')),;	//3-DT PGTO menor que período
					FieldGet(6),;	//4-VLR DPL
					if(FieldGet(5)<=VM_DATA[2],FieldGet(7),0),;	//5-VLR PGTO não considerar se data fora do período
					if(FieldGet(5)<=VM_DATA[2],FieldGet(8),0),;	//6-VLR JUROS não considerar se data fora do período
					if(FieldGet(5)<=VM_DATA[2],FieldGet(9),0)}	//7-VLR DESC não considerar se data fora do período
		SALVABANCO
		select TEMP
		if dbseek(str(pCod,5)+str(nDPL,9))
			FieldPut(7,FieldGet(7)+aDados[5])
			FieldPut(8,FieldGet(8)+aDados[6])
			FieldPut(9,FieldGet(9)+aDados[7])
		else
			AddRec(,{;
						pCod,;	// 		1-Codigo Cli ou Forec
						nDPL,;	// 		2-é saldo anterior
						aDados[1],;//	3
						aDados[2],;//	4
						aDados[3],;//	5
						aDados[4],;//	6-valor total
						aDados[5],;//	7 valor pago
						aDados[6],;//	8 valor pago-Juros
						aDados[7],;// 	9 valor pago-Descr
						0;//				10
						})
		end
		RESTAURABANCO
		lRT:=.T.
	end
	skip
end
return(lRT)

*-----------------------------------------------------------------------
function CFEPCCCSC() // Cabecalho
*-----------------------------------------------------------------------
if aOpcoes[3]=='A'
	?'Codigo '+VM_TIPO[1]+'...:'+pb_zer(VM_COD,5)+'-'+VM_TIPO[4]
	?replicate('-',LAR)
	?"   Docto     Dt.Emiss   Dt.Venct    Dt.Pgto     Vlr Dupl    Vlr Pgtos    Vlr Juros     Vlr Desc        Saldo"
else
	?"Cliente/Fornecedor"+space(39)+"Vlr Saldo  Vlr Acumulado"
end
?replicate('-',LAR)
return NIL
*---------------------------------------------EOF--------------------------------*
