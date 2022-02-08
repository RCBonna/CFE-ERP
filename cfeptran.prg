*-----------------------------------------------------------------------------*
 static aVariav := {'I_TRANS.ARR','','',0,0}
 //..................1.............2..3.4.5..6...7...8...9, 10, 11, 12,13
*-----------------------------------------------------------------------------*
#xtranslate ArqT       => aVariav\[  1 \]
#xtranslate TF         => aVariav\[  2 \]
#xtranslate TF2        => aVariav\[  3 \]
#xtranslate RT         => aVariav\[  4 \]
#xtranslate REG        => aVariav\[  5 \]
*-----------------------------------------------------------------------------*
 function CFEPTRANE(P1,P2,pTipoES,pEdCod) // EDITA DADOS DE TRANSPORTADORES
 //.......................ENTRADA / SAIDA
 //....................P2=EDITA QUANTIDADE/PESO
 //.................P1=DADOS PARA EDIÇÃO
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local GETLIST :={}
local VM_CODTR:=P1[15]
TF            :=SaveScreen()

if pTipoES==NIL
	pTipoES:='S'
end

if pEdCod==NIL
	pEdCod:=.T.
end
if !pEdCod.and.empty(P1[15])
	pEdCod:=.T.
end

SalvaCor(SALVA)
pb_box(12,0,22,79,'W+/RB,R/W,,,W+/RB','Dados do Transporte')
@13,02 say 'Tipo Frete........:'       get P1[05]   pict mI1      valid P1[5]>0 .and. P1[5]<=3 .and. LimpaDadosP1(P1[05],P1) .and. aeval(GETLIST,{|DET|DET:display()})==GETLIST   when pb_msg('Tipo de Frete : <1> Emitente (CIF)   <2> Destinatario (FOB)   <3> Sem Frete')
@13,35 say 'Cod.Transportador.:'       get VM_CODTR pict mI5      valid fn_codtr(@VM_CODTR,P1,pTipoES) .and.                aeval(GETLIST,{|DET|DET:display()})==GETLIST                  when P1[05]#3 // when pb_msg('Informe -1 quando o Emitente vai Levar/Trazer as mercadorias').and.pEdCod
@14,02 say 'Nome/Razao Social :'       get P1[01]   pict mUUU           when P1[5]#3 .and. P2
@15,02 say 'Endere‡o..........:'       get P1[02]   pict mUUU           when P1[5]#3
@16,02 say 'Municipio.........:'       get P1[03]   pict mUUU           when P1[5]#3
@16,50 say 'UF:'                       get P1[04]   pict mUUU           when P1[5]#3
@17,02 say 'CNPJ/CPF Transport:'       get P1[08]   pict masc(23)       when P1[5]#3
@17,41 say 'Inscricao Estadual:'       get P1[09]   pict masc(23)       when P1[5]#3 .and. pb_msg('')
@18,02 say 'Placa Veiculo:'            get P1[06]   pict mPLACA         when P1[5]#3 .and. pb_msg('')
@18,35 say 'UF Placa:'                 get P1[07]   pict mUUU           when P1[5]#3 .and. pb_msg('')
pb_box(19,0,22,79,'w+/rb,r/w,,,w+/rb','Embalagens')
@20,02 say 'Qtdade.:'                  get P1[10]   pict masc(06)       when P2
@20,21 say 'Especie:'                  get P1[11]   pict mUUU           when P2
@20,52 say 'Marca:'                    get P1[12]   pict mUUU           when P2
@21,02 say 'Peso Bruto:'               get P1[13]   pict masc(06)       when P2
@21,46 say 'Peso Liquido:'             get P1[14]   pict masc(06)       when P2
read
if lastkey()#K_ESC
	P1[15]:=VM_CODTR
	SaveArray(P1,ArqT)
end
// alert('EDITA;CFEPTRANE;TIPO FRETE:'+STR(P1[5]))
RestScreen(,,,,TF)
SalvaCor(RESTAURA)

//alert('CFEPTRANE;CIDADE:'+P1[3])

return P1

*-----------------------------------------------------------------------------*
function CFEPTRANL(pTipo) // LE DADOS DE TRANSPORTADORES
*-----------------------------------------------------------------------------*
local  P1:=array(15)
default pTipo to .T.
	P1[01]:=space(40)
	P1[02]:=space(40)
	P1[03]:=space(20)
	P1[04]:=space(02)
	P1[05]:= 3
	P1[06]:=space(07)
	P1[07]:=space(02)
	P1[08]:=space(18)
	P1[09]:=space(18)
	P1[10]:= 0
	P1[11]:=space(20)
	P1[12]:=space(20)
	P1[13]:= 0
	P1[14]:= 0
	P1[15]:=-1
if pTipo.and.file (ArqT)
	P1:=restarray(ArqT)
end
if select('PEDCAB') > 0
	P1[13]:=PEDCAB->TR_PBRU
	P1[14]:=PEDCAB->TR_PLIQ
end
return P1

*-----------------------------------------------------------------------------*
function CFEPTRANG(pTipo,P1) // GRAVA DADOS DE TRANSPORTADORES
*-----------------------------------------------------------------------------*
if pTipo=='S'
	select('PEDCAB')
	//	alert('SAIDA;CFEPTRANE;TIPO FRETE:'+STR(P1[5]))
	replace  PEDCAB->TR_NOME   with P1[01],;
				PEDCAB->TR_ENDE   with P1[02],;
				PEDCAB->TR_MUNI   with P1[03],;
				PEDCAB->TR_UFT    with P1[04],;
				PEDCAB->TR_TIPO   with P1[05],;
				PEDCAB->TR_PLACA  with P1[06],;
				PEDCAB->TR_UFV    with P1[07],;
				PEDCAB->TR_CGC    with P1[08],;
				PEDCAB->TR_INCR   with P1[09],;
				PEDCAB->TR_QTDEM  with P1[10],;
				PEDCAB->TR_ESPE   with P1[11],;
				PEDCAB->TR_MARC   with P1[12],;
				PEDCAB->TR_PBRU   with P1[13],;
				PEDCAB->TR_PLIQ   with P1[14],;
				PEDCAB->TR_CODTRA with P1[15]
elseif pTipo=='E'
	select('ENTCAB')
	//alert('ENTRADA;CFEPTRANE;TIPO FRETE:'+STR(P1[5]))
	replace  ENTCAB->TR_NOME   with P1[01],;
				ENTCAB->TR_ENDE   with P1[02],;
				ENTCAB->TR_MUNI   with P1[03],;
				ENTCAB->TR_UFT    with P1[04],;
				ENTCAB->TR_TIPO   with P1[05],;
				ENTCAB->TR_PLACA  with P1[06],;
				ENTCAB->TR_UFV    with P1[07],;
				ENTCAB->TR_CGC    with P1[08],;
				ENTCAB->TR_INCR   with P1[09],;
				ENTCAB->TR_QTDEM  with P1[10],;
				ENTCAB->TR_ESPE   with P1[11],;
				ENTCAB->TR_MARC   with P1[12],;
				ENTCAB->TR_PBRU   with P1[13],;
				ENTCAB->TR_PLIQ   with P1[14],;
				ENTCAB->TR_CODTRA with P1[15]
end
dbskip(0)
return NIL

*-----------------------------------------------------------------------------*
function CFEPTRANR(pTipo) // LER DADOS DE TRANSPORTADORES DO ARQUIVO
*-----------------------------------------------------------------------------*
local  	P1		:=array(15)
			P1[15]:=0

if pTipo=='S'
	select('PEDCAB')
	P1[01]:=PEDCAB->TR_NOME
	P1[02]:=PEDCAB->TR_ENDE
	P1[03]:=PEDCAB->TR_MUNI
	P1[04]:=PEDCAB->TR_UFT
	P1[05]:=PEDCAB->TR_TIPO
	P1[06]:=PEDCAB->TR_PLACA
	P1[07]:=PEDCAB->TR_UFV 
	P1[08]:=PEDCAB->TR_CGC
	P1[09]:=PEDCAB->TR_INCR
	P1[10]:=PEDCAB->TR_QTDEM
	P1[11]:=PEDCAB->TR_ESPE
	P1[12]:=PEDCAB->TR_MARC
	P1[13]:=PEDCAB->TR_PBRU
	P1[14]:=PEDCAB->TR_PLIQ
	P1[15]:=PEDCAB->TR_CODTRA
elseif pTipo=='E'
	select('ENTCAB')
	P1[01]:=ENTCAB->TR_NOME
	P1[02]:=ENTCAB->TR_ENDE
	P1[03]:=ENTCAB->TR_MUNI
	P1[04]:=ENTCAB->TR_UFT
	P1[05]:=ENTCAB->TR_TIPO
	P1[06]:=ENTCAB->TR_PLACA
	P1[07]:=ENTCAB->TR_UFV
	P1[08]:=ENTCAB->TR_CGC
	P1[09]:=ENTCAB->TR_INCR
	P1[10]:=ENTCAB->TR_QTDEM
	P1[11]:=ENTCAB->TR_ESPE
	P1[12]:=ENTCAB->TR_MARC
	P1[13]:=ENTCAB->TR_PBRU
	P1[14]:=ENTCAB->TR_PLIQ
	P1[15]:=ENTCAB->TR_CODTRA
end
if P1[15]<1
	P1[15]:=-1
end
return P1

*-----------------------------------------------------------------------------*
function FN_CODTR(P1,P2,pTipoES) // GRAVA DADOS DE TRANSPORTADORES
*-----------------------------------------------------------------------------*
RT:=.T.
REG:=0
if P1<0
	P2[01]:=padr(CLIENTE->CL_RAZAO,40)
	P2[02]:=left(CLIENTE->CL_ENDER,40)
	P2[03]:=padr(CLIENTE->CL_CIDAD,20)
	P2[04]:=CLIENTE->CL_UF
	P2[05]:=2
	P2[06]:=if(pTipoES=='E',padr(PLinha('TransPlaca',space(7)),7),space(7))
	P2[07]:=CLIENTE->CL_UF
	P2[08]:=transform(CLIENTE->CL_CGC,if(CLIENTE->CL_TIPOFJ=='J',mCGC,mCPF))
	P2[09]:=padr(CLIENTE->CL_INSCR,18)
	P2[11]:=padr(PLinha('TransEmbEsp',space(20)),20)
	P2[12]:=padr('DIVERSOS',20)
	keyboard replicate(chr(13),6)
else
	salvabd(SALVA)
	select CLIENTE
	REG:=recno()
	if !dbseek(str(P1,5))
		salvacor(SALVA)
		ORDEM ALFA
		DbGoTop()
		TF2:=savescreen(5,0)
		pb_box(05,00,22,62,,'Emitentes')
		private VM_ROT:={||NIL}
		dbedit(06,01,21,61,{fieldname(2),fieldname(8),fieldname(1)},'FN_TECLAx','','','',' ¯ ')
		P1:=&(fieldname(1))
		restscreen(5,0,,,TF2)
		ORDEM CODIGO
		salvacor(.F.)
	end
	P2[01]:=left(CLIENTE->CL_RAZAO,40)
	P2[02]:=left(CLIENTE->CL_ENDER,40)
	P2[03]:=padr(CLIENTE->CL_CIDAD,20)
	P2[04]:=     CLIENTE->CL_UF
	P2[07]:=     CLIENTE->CL_UF
	P2[08]:=transform(CLIENTE->CL_CGC,if(CLIENTE->CL_TIPOFJ=='J',mCGC,mCPF))
	P2[09]:=padr(CLIENTE->CL_INSCR,18)
	P2[15]:=CLIENTE->(FieldGet(1))
	DbGoTo(REG)
	keyboard replicate(chr(13),6)
	if lastkey()=K_ESC
		RT:=.F.
	end
	salvabd(RESTAURA)
end
return(RT)

*-----------------------------------------------------------------------------*
static function LimpaDadosP1(pTipo,P1) // LIMPA DADOS
*-----------------------------------------------------------------------------*
if pTipo==3
	P1[01]:=space(40)
	P1[02]:=space(40)
	P1[03]:=space(20)
	P1[04]:=space(02)
	P1[05]:= 3
	P1[06]:=space(07)
	P1[07]:=space(02)
	P1[08]:=space(18)
	P1[09]:=space(18)
	P1[15]:= 0
end
return(.T.)

*-------------------------------------------------------------EOF----------------*