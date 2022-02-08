*-----------------------------------------------------------------------------*
static aVariav := {0,{2, 55, 08,  9, 53, 54, 3, 56, 57, 4},"" }
//.................1,,( 3........4....5/6..........7......8.......9.......10.......11......12....13)..
*-----------------------------------------------------------------------------*
#xtranslate nX     => aVariav\[  1 \]
#xtranslate aCPOS  => aVariav\[  2 \]
#xtranslate nGRAVA => aVariav\[  3 \]

*-------------------------------------------------------------------* 
#include 'RCB.CH'
 
*-------------------------------------------------------------------* 
 function CFEP3100T(VM_FL)
*-------------------------------------------------------------------* 
local GETLIST := {}
local VM_CTCPL
local X
local X1
local X2
local LCONT:=.T.
local ORDANT
local CHKCGCCPFCli:=left(PLinha('Validar CPF/CNPJ Zero','N'),1)

for X :=1 to fcount()
	X1 :="VM"+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next
if VM_FL	// inclus
	ORDANT:=indexord()
	dbsetorder(1)
	dbgobottom()
	VM_CODCL  :=CL_CODCL+1
	dbsetorder(ORDANT)
	VM_CIDAD  := PARAMETRO->PA_CIDAD
	VM_CEP    := PARAMETRO->PA_CEP
	VM_UF     := PARAMETRO->PA_UF
	VM_DTCAD  := date()
	VM_CGC    := space(14)
	VM_TIPOFJ := 'F'
else
	VM_TIPOFJ := if(empty(VM_TIPOFJ),if(len(trim(VM_CGC))<12,'F','J'),VM_TIPOFJ)
	VM_DTCAD  := if(empty(VM_DTCAD),date(),VM_DTCAD)
end

	VM_ESTCIV := if(empty(VM_ESTCIV),    'C',VM_ESTCIV)
	VM_CDPAIS := if(empty(VM_CDPAIS),   1058,VM_CDPAIS)
	VM_CDIBGE:=  if(empty(VM_CDIBGE),4209201,VM_CDIBGE)
	
	
pb_box(5,0,22,79,,'Cadastro de Clientes')
@06,02 say 'C¢digo....:'  get VM_CODCL   pict mI5    valid VM_CODCL>0.and.pb_ifcod2(str(VM_CODCL,5),NIL,.F.,1) when VM_FL
@06,51 say 'Dt Cadastro:' get VM_DTCAD   pict mDT    valid dtos(VM_DTCAD)<=dtos(date())
@07,02 say 'Nome/Raz„o:'  get VM_RAZAO   pict mUUU   valid !empty(VM_RAZAO)
@07,60 say 'F/J:'         get VM_TIPOFJ  pict mUUU   valid VM_TIPOFJ$'FJ' when pb_msg('Tipo de pessoa <F>isico   ou  <J>uridico')
if PARAMETRO->PA_CONTAB==USOMODULO
	@08,02 say 'NomeFantas:'  get VM_NFANTA  pict mUUU                        when (VM_NFANTA:=if(empty(VM_NFANTA),if(VM_TIPOFJ=='J',VM_RAZAO,VM_NFANTA),VM_NFANTA))>=''.and.if(VM_TIPOFJ=='J',.T.,.F.)
end
@09,02 say 'Endere‡o..:'  get VM_ENDER   pict mXXX
@09,60 say 'Nro:'         get VM_ENDNRO  pict mXXX

@10,02 say 'Bairro....:'  get VM_BAIRRO  pict mXXX
@11,02 say 'Complement:'  get VM_ENDCOMP pict mXXX                       when pb_msg('Dados Complemetares do Endereco')
@10,51 say 'Cidade:'      get VM_CIDAD   pict mXXX   valid chkCidade(VM_CIDAD)
@11,51 say 'CEP.:'        get VM_CEP     pict mCEP
@11,70 say 'UF:'          get VM_UF      pict mUUU   valid VM_UF=='EX'.or.pb_uf(@VM_UF) // ex=Exterior


@12,02 say 'CGC/CPF...:' get VM_CGC;
                         pict mCGC ;
                         valid pb_chkdgt(VM_CGC,if(VM_TIPOFJ=='J',1,2)).and.fn_cadcgc(VM_CGC,VM_FL,recno()).and.;
                         (if(CHKCGCCPFCli=='S',val(VM_CGC)>0.or.VM_UF='EX',.T.)) ;
								 when (GetActive():picture:=(if(VM_TIPOFJ=='F',mCPF+space(4),mCGC)))>=''.and.(GetActive():varPut(if(VM_TIPOFJ=='F',left(CLIENTE->CL_CGC,11),CLIENTE->CL_CGC)))>=''
@12,32 say 'Tp Empresa.:'  get VM_TPEMPR pict mI1    valid VM_TPEMPR=0.or.VM_TPEMPR=5 when pb_msg('Tipo Empresa: 0=Normal 5=Super Simples').and.VM_TIPOFJ=='J'
@12,51 say 'IE/RG.:'       get VM_INSCR   pict mUUU     valid VM_INSCR='ISENTO'.or.IE_OK(VM_INSCR,VM_UF,VM_TIPOFJ) when fn_pessoaf()
@13,02 say 'Fone......:'   get VM_FONE    pict mUUU
@13,51 say 'Fax...:'       get VM_FAX     pict mUUU
@14,02 say 'C¢d.Vended:'   get VM_VENDED  pict mI3      valid if(VM_VENDED==0,.T.,fn_codigo(@VM_VENDED,{'VENDEDOR',{||VENDEDOR->(dbseek(str(VM_VENDED,3)))},{||CFEP5610T(.T.)},{2,1}})) when PARAMETRO->PA_VENDED==USOMODULO.and.PR('VENDEDOR',str(VM_VENDED,3),2,.T.,{14,17}).and.VM_FL
@14,51 say 'Dt Reg.SPC:'   get VM_DTSPC   pict mDT      valid fn_cliobs(VM_CODCL,VM_DTSPC) when pb_msg('Use CTRL+Y para apagar o campo',nil,.f.)
@15,51 say 'Dt ConsSPC:'   get VM_DTCSP   pict mDT
@15,02 say 'Tipo/Ativ.:'   get VM_ATIVID  pict masc(11) valid fn_codar(@VM_ATIVID,'TIPOCLI.ARR')
@16,02 say 'Lim Credit:'   get VM_LIMCRE  pict mD82     valid VM_LIMCRE>=0
@16,32 say 'DT.Ult.Comp:'  get VM_DTUCOM  pict mDT					when pb_msg('Atualiza DT de validacao do Cadastro do Cliente')
//@15,51 say 'Dt Baixa..:'   get VM_DTBAIX  pict mDT                        when VM_ATIVID#1
@17,02 say 'Iscr.Munic:'   get VM_INSMUN  pict mUUU                       when VM_TIPOFJ=='J'
@17,32 say 'Cod.IBGE...:'  get VM_CDIBGE  pict mI7                        when pb_msg('Codigo Municipio IBGE - VER TABELA')
@17,62 say 'Cod.PAIS:'     get VM_CDPAIS  pict mI5                        when pb_msg('Codigo Pais - VER TABELA')
@18,02 say 'CodSUFRAMA:'   get VM_CDSUFRA pict mUUU                       when pb_msg('Consulte tabela SUFRAMA - http://www.icmsconsultafacil.com.br/icms/codigos/codigodsuframa.htm')
@19,02 say 'Referencia:'   get VM_REFER   pict mXXX
@20,02 say 'Obs.......:'   get VM_OBS     pict mXXX+'S50'
@21,02 say 'MatrizCobr:'   get VM_MATRIZ  pict mI5      valid VM_MATRIZ==0.or.CodCli(@VM_MATRIZ)   when pb_msg('Se este cliente tem uma matriz informar o codigo para UNIFICAR cobranca').and.VM_TIPOFJ=='J'

if VM_MATRIZ>0.and.!VM_FL
	CodCli(@VM_MATRIZ)
end
read
setcolor(VM_CORPAD)
if empty(VM_LOCTRC)
	VM_DATAAC:=ctod('')
	VM_CARGOC:=space(len(CL_CARGOC))
	VM_RENDAC:=0
end

VM_NFANTA:=if(empty(VM_NFANTA),VM_RAZAO,VM_NFANTA) // se não tem Nome Fantasia = Razão Social

if if(lastkey()#K_ESC,pb_sn(),.F.)
	VM_DTUCOM := if(empty(VM_DTUCOM),Date(),VM_DTUCOM)
	if VM_FL
		while !pb_ifcod2(str(VM_CODCL,5),NIL,.F.,1)
			beeperro()
			beeperro()
			VM_CODCL++
			alert('*** ALERTA ***;Codigo do cliente esta sendo cadastrado;Alterado para '+str(VM_CODCL,5))
		end
		LCONT:=AddRec()
		replace CL_CODCL with VM_CODCL
		dbcommit()
	else
		if &(fieldname(2))#VM_RAZAO
			salvabd(SALVA)
			select('DPCLI')
			dbsetorder(5)
			dbseek(str(VM_CODCL,5),.T.)
			dbeval({||DPCLI->DR_ALFA:=VM_RAZAO},,{||DPCLI->DR_CODCL==VM_CODCL.and.reclock(1000)})
			salvabd(RESTAURA)
		end
	end
	if LCONT
		if VM_MATRIZ==VM_CODCL
			VM_MATRIZ:=0
		end
		cls
		for X:=1 to fcount()
			X1:="VM"+substr(fieldname(X),3)
			if !VM_FL // é alteração --> gravar mudanças para sped-fiscal registro 175
 				nX:=AsCan(aCPOS,{|DET|DET==X})
/*				?fieldname(X)+" ==> "
				??&(fieldname(X))
				??"  =  "
				??&X1
				??" s:"
				??X
				??" matrix?:"
				??nX
				// e o campo é diferente do já existente
				inkey(0)
 */			if nX>0.and.; // é um campo controlado
					&(fieldname(X)) # &X1 // e o campo é diferente do já existente
					if FieldType(X)=="N"
						nGrava:=trim(str(&(fieldname(X))))
					elseif FieldType(X)=="D"
						nGrava:=strtran(dtoc(&(fieldname(X))),'/','')
					else
						nGrava:=&(fieldname(X))
					end
					MovCliSped({VM_CODCL,date(),aCPOS[nX],nGrava,RT_NOMEUSU()})
				end
			end
			replace &(fieldname(X)) with &X1
		next
		dbcommit()
	end
else
	if VM_FL.and.VM_CODCL>0 // cancelamento inclusao
		fn_cliobs(VM_CODCL,ctod('')) // exclui mov SPC
	end
end
dbrunlock(recno())
return NIL

*-------------------------------------------------------------------
function FN_PESSOAF() // Rotina de Pesquisa
*-------------------------------------------------------------------
local GETLIST:={}
local VM_TF  :=savescreen(12,0,18,79)
if VM_TIPOFJ=='F'.and.PARAMETRO->PA_CADCLI=='C'
	salvacor(SALVA)
	pb_box(12,0,18,79,'W+/BG,R/W,,,W+/BG','Dados Pessoa F¡sica')
	@13,02 say 'Filia‡„o..:' get VM_FILIAC pict masc( 1)
	@14,02 say 'Dt Nascim.:' get VM_DTNAS  pict mDT
	@14,30 say 'local Nasc:' get VM_LOCNAS pict masc( 1)
	@14,64 say 'Est.Civil.:' get VM_ESTCIV pict '!'      valid (VM_ESTCIV$' CSDVA') when pb_msg('<C>asado <S>olteiro <D>ivorciado <V>iuvo <A>maziado')
	@15,02 say 'Bens......:' get VM_BENS   pict masc( 1) when FN_CONJUGE()
	@16,04 say 'Inf.Trab:'   get VM_LOCTRA pict masc( 1)
	@17,02 say 'Dt Admiss.:' get VM_DATAAD pict masc( 7) when !empty(VM_LOCTRA)
	@17,32 say 'Cargo.....:' get VM_CARGO  pict masc( 1) when !empty(VM_LOCTRA)
	@17,60 say 'Remun.(SM):' get VM_REMUN  pict masc(12) valid VM_REMUN>=0 when !empty(VM_LOCTRA)
	read
	restscreen(12,0,18,79,VM_TF)
	salvacor(RESTAURA)
end
return .T.
*-------------------------------------------------------------------
function FN_CONJUGE() // Rotina de Pesquisa
*-------------------------------------------------------------------
local GETLIST:={}
local VM_TF:=savescreen(17,0,22,79)
if VM_ESTCIV$'CD'.and.PARAMETRO->PA_CADCLI=='C'
	salvacor(SALVA)
	pb_box(17,0,22,79,'W+/W,W+/R,,,W+/W','Dados Conjuge')
	@18,02 say 'Nome Conj.:' get VM_CONJUG pict masc( 1)
	@18,60 say 'Docto:'      get VM_DOCTOC pict masc( 1)
	@19,02 say 'Filia‡„o..:' get VM_FILICG pict masc( 1)+'S40'
	@19,60 say 'DtNasc:'     get VM_DATANC pict masc( 7)
	@20,02 say '  Inf.Trab:' get VM_LOCTRC pict masc( 1)
	@21,02 say 'Dt Admiss.:' get VM_DATAAC pict masc( 7) when !empty(VM_LOCTRC)
	@21,32 say 'Cargo.....:' get VM_CARGOC pict masc( 1) when !empty(VM_LOCTRC)
	@21,60 say 'Renda (SM):' get VM_RENDAC pict masc(12) valid VM_RENDAC>=0 when !empty(VM_LOCTRC)
	read
	if empty(VM_LOCTRC)
		VM_DATAAC=ctod('')
		VM_CARGOC=space(len(CL_CARGOC))
		VM_RENDAC=0
	end
	salvacor(RESTAURA)
	restscreen(17,0,22,79,VM_TF)
end
return .T.

*-------------------------------------------------------------------* 
 static function CodCli(P1)
*-------------------------------------------------------------------* 
local RT :=.T.
local REG:=recno()
if !CLIENTE->(dbseek(str(P1,5)))
	salvabd(SALVA)
	select CLIENTE
	salvacor(SALVA)
	ORDEM ALFA
	DbGoTop()
	TF:=savescreen(5,0)
	pb_box(05,00,22,42,,'Matriz Cobranca')
	private VM_ROT:={||NIL}
	dbedit(06,01,21,41,{fieldname(2),fieldname(1)},'FN_TECLAx','','','',' ¯ ')
	P1:=&(fieldname(1))
	restscreen(5,0,,,TF)
	ORDEM CODIGO
	salvacor(.F.)
	RT:=.F.
else
	if CLIENTE->CL_TIPOFJ=='F'
		alert('Cliente nao pode ser do tipo Pessoa Fisica')
		RT :=.F.
	end
	@row(),col()+2 say CLIENTE->CL_RAZAO
end
DbGoTo(REG)
return RT

*---------------------------------------------------------------------------*
 function chkCidade(pCidade)
*---------------------------------------------------------------------------*
local RT:=.T.
local X
For X:=1 to LEN(pCidade)
	if substr(pCidade,X,1)<'A'.or.substr(pCidade,X,1)>'Z'
		if substr(pCidade,X,1)==' '
		else
			RT:=.F.
			X:=1000
		end
	end
next
if !RT
	alert('Cidade nao pode conter acentos;ou caracteres estranhos')
end
return RT

*-------------------------------------------------------------------* 
 function CFEP3100T1(VM_FL)
*-------------------------------------------------------------------* 
local GETLIST := {}
local VM_RT:=.T.
dbsetorder(1)
while VM_RT
	VM_CODCL :=CL_CODCL
	VM_CCTRA1:=CL_CCTRA1
	pb_box(18,10,21,79,,'Altera Conta Contabil-Transferencia')
	@19,12 say 'C¢digo Cliente:' get VM_CODCL   pict mI5 valid VM_CODCL>0.and.fn_codigo(@VM_CODCL,  {'CLIENTE', {||CLIENTE-> (dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.reclock()
	@20,12 say 'Conta Contabil:' get VM_CCTRA1  pict mI4 valid VM_CCTRA1==0.or.fn_ifconta(,@VM_CCTRA1) when pb_msg('Informe Conta contabil para Transferencia de Saida')
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		replace CL_CCTRA1 with VM_CCTRA1
		dbrunlock(recno())
		skip
		if eof()
			go top
		end
	else
		VM_RT:=.F.
	end
end
dbrunlock(recno())
dbsetorder(2)
return NIL
//--------------------------------END
