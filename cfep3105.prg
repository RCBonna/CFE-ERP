#include 'RCB.CH'

*-------------------------------------------------------------------
function CFEP3105() // Rotina de Impressão
*-------------------------------------------------------------------

local   VM_OP :={'Lista '+substr('Codigo AlfabetCGC/CPFVended.',indexord()*7-6,7),'Ficha','UF/Cidade/Bairro'}
private VM_OPC:=alert('Impress„o de Clientes, em forma de',VM_OP)
private VM_FL :=alert('Listar...',{'Todos Geral','Todos p/Mes','S¢ '+left(&(fieldname(2)),20)})

if VM_OPC==3.and.VM_FL#3 // UF/Cidade/Bairro
	dbsetorder(5)
	DbGoTop()
	VM_LIM:={{space(2),space(20),space(25)},{'ZZ',replicate('Z',20),replicate('Z',25)}}
	pb_msg('Informe os Limites para Impressao.',NIL,.F.)
	pb_box(18,10)
	@18,20 say '[Inicial]'	color 'W+/R'
	@18,52 say '[Final]'		color 'W+/R'
	@19,12 say 'UF....:'		get VM_LIM[1,1] pict masc(1)
	@20,12 say 'Cidade:'		get VM_LIM[1,2] pict masc(1)
	@21,12 say 'Bairro:'		get VM_LIM[1,3] pict masc(1)
	@19,52 						get VM_LIM[2,1] pict masc(1)
	@20,52 						get VM_LIM[2,2] pict masc(1)
	@21,52 						get VM_LIM[2,3] pict masc(1)
	read
	set filter to CL_UF>=VM_LIM[1,1].and.CL_UF<=VM_LIM[2,1].and.;
						CL_CIDAD>=VM_LIM[1,2].and.CL_CIDAD<=VM_LIM[2,2].and.;
						CL_BAIRRO>=VM_LIM[1,3].and.CL_BAIRRO<=VM_LIM[2,3]
	DbGoTop()	
end
if if(VM_OPC>0.and.VM_FL>0,pb_ligaimp(RST+C15CPP),.F.)
	if VM_FL=1
		DbGoTop()
	end
	if VM_FL==2
		VM_MES:=array(12,2)
		for VM_PAG=1 to 12
			VM_MES[VM_PAG,1]:=VM_PAG
			VM_MES[VM_PAG,2]:=pb_mesext(VM_PAG,'C')
		end
		keyboard replicate(chr(K_DOWN),month(date()))
		while (VM_PAG:=abrowse(8,60,22,79,VM_MES,{' ','Mes'},{2,15},{masc(11),masc(1)}))=0
		end
		VM_NMES:=VM_PAG
		dbsetfilter({||month(CL_DTNAS)==VM_NMES})
		DbGoTop()
	end

	VM_PAG = 0
	VM_REL = 'Cadastro de Clientes - '+VM_OP[VM_OPC]
	if VM_OPC=1.or.VM_OPC=3
		VM_LAR = 132
		??I15CPP
		VM_VENDED=0
		VM_CIDAD=''
		while !eof()
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP3105A',VM_LAR)
			if VM_OPC==3
				if VM_CIDAD#CL_UF+'/'+CL_CIDAD
					VM_CIDAD=CL_UF+'/'+CL_CIDAD
					?padc('UF/Cidade : '+trim(VM_CIDAD),VM_LAR,'-')
				end
			end
			if indexord()=4 // por vendedor
				if VM_VENDED#CL_VENDED
					VM_VENDED:=CL_VENDED
					VM_CPO:=VM_CAMPO[15]
					?INEGR+&VM_CPO+CNEGR
					?replicate('+',34)
				end
			end
			? pb_zer(CL_CODCL,5)+'-'+left(CL_RAZAO,30)+space(1)
			if len(trim(CL_CGC))<13
				??transform(CL_CGC,masc(17))+space(1)
			else
				??transform(CL_CGC,masc(18))
			end
			??space(1)+left(CL_INSCR,15)
			??space(1)+CL_FONE
			if VM_OPC#3
				??space(1)+CL_FAX
				??space(1)+left(CL_CIDAD,15)+'/'+CL_UF
			else
				??space(1)+CL_BAIRRO
			end
			if VM_FL=2
				?space(34)+CL_ENDER+' '+CL_BAIRRO+' '+transform(CL_CEP,masc(10))+' Dt Nasc '+dtoc(CL_DTNAS)
			end
			if VM_FL=3
				dbgobottom()
			end
			pb_brake()
 		end
		?replicate('-',VM_LAR)
		?'Impresso as '+time()
	else	//	------------------------------------------------------------FICHA
		VM_LAR     :=80
		VM_REL = 'Ficha Cadastro de Clientes'
		while !eof()
			for X:=1 to len(VM_CAMPO)-33
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,,VM_LAR)
				VM_CPO:=VM_CAMPO[X]
				if !empty(&VM_CPO)
					?padr(VM_CABE[X],17,'.')+': '
					if X=14
						??left(&VM_CPO,60)
						if !empty(substr(&VM_CPO,61,60))
							?space(19)+substr(&VM_CPO,61,60)
						end
						if !empty(substr(&VM_CPO,121,60))
							?space(19)+substr(&VM_CPO,121,60)
						end
					else
						??&VM_CPO
					end
					
				end
			next
			X:=33
			VM_CPO:=VM_CAMPO[X] // Referencia
			if !empty(&VM_CPO)
				?padr(VM_CABE[X],17,'.')+': '
				??&VM_CPO
			end
			X:=41
			VM_CPO:=VM_CAMPO[X] // Referencia
			if !empty(&VM_CPO)
				?padr(VM_CABE[X],17,'.')+': '
				??&VM_CPO
			end
			
			if len(trim(CL_CGC))==11
				? padc('[DADOS PESSOA FISICA]',VM_LAR,'-')
				VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,,VM_LAR)
				? padr('Filiacao',  17,'.')+CL_FILIAC
				? padr('Dt Nascim',17,'.')+dtoc(CL_DTNAS)+space(20)
				? padr('Bens',17,'.')+CL_BENS
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,,VM_LAR)
				if !empty(CL_LOCTRA)
					? padr('Inf.Trab',17,'.')+CL_LOCTRA
					VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,,VM_LAR)
					? padr('Dt Admiss',17,'.')+dtoc(CL_DATAAD)+space(10)
					??'Cargo:'+CL_CARGO+space(5)+'Remun.(SM):'+str(CL_REMUN,3)
				end
				if CL_ESTCIV$'CD'
					VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,,VM_LAR)
					? padc('[DADOS DO CONJUGE]',VM_LAR,'-')
					? padr('Nome Conj', 17,'.')+CL_CONJUG+space(1)
					??'Docto:'+CL_DOCTOC
					VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,,VM_LAR)
					? padr('Data Nasc', 17,'.')+dtoc(CL_DATANC)
					? padr('Filiacao',  17,'.')+CL_FILICG
					if !empty(CL_LOCTRC)
						VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,,VM_LAR)
						? padr('Inf.Trab',  17,'.')+CL_LOCTRC
						? padr('Dt Admiss', 17,'.')+dtoc(CL_DATAAC)+space(10)
						??'Cargo:'+CL_CARGOC+space(5)+'Renda (SM):'+str(CL_RENDAC,3)
					end
				end
			end
			?replicate('-',VM_LAR)
			if PARAMETRO->PA_FICHCLI=='S'
				?
				?'O cliente acima identificado e abaixo assinado, declara os devidos fins que as'
				?'informacoes prestadas neste cadastro sao a expressao de verdade, sendo que  se'
				?'responsabiliza pela  comunicacao a  empresa,  em caso de eventual alteracao em'
				?'qualquer dos dados.'
				?'Daclara,outrossim,que o endereco indicado esta apto a receber correspondencia.'
				?
				?
				?'_________________________________________________________'
				?CLIENTE->CL_RAZAO
			end
			if prow()>45
				setprc(64,1)
			end
			if VM_FL=3
				dbgobottom()
			end
			pb_brake()
		end
	end
	eject
	pb_deslimp(C15CPP)
end
dbclearfil()
dbsetorder(2)
DbGoTop()
return NIL

*-------------------------------------------------------------------* 
 function CFEP3105A()
*-------------------------------------------------------------------* 
? padr(VM_CABE[01],6)
??padr(VM_CABE[02],31)
??padr(VM_CABE[08],19)
??padr(VM_CABE[09],16)
??padr(VM_CABE[11],21)
if VM_OPC#3
	??padr(VM_CABE[12],21)
	??padr(VM_CABE[06],16)
	??padr(VM_CABE[07],2)
else
	??'Bairro'
end
?replicate('-',VM_LAR)
return NIL

*-------------------------------------------------------------------* 
 function CFEP3105B()
*-------------------------------------------------------------------* 
// ..... cabec para ficha
return NIL
