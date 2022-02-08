//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.,.T.}
//....................1.2..3...4
//-----------------------------------------------------------------------------*
#xtranslate cArq			=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate lCONT			=> aVariav\[  3 \]
#xtranslate lRT			=> aVariav\[  4 \]

#include 'RCB.CH'
//-----------------------------------------------------------------------------*
	function LeiteP18()	//	Dados da Análise de Leite
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'		,;
				'R->LEIPARAM'		,;		// Parametros do Leite
				'R->PROD'			,;
				'R->CLIENTE'		,;
				'R->LEITRANS'		,;
				'R->LEIMOTIV'		,;
				'R->LEIVEIC'		,;
				'R->LEIROTA'		,;		// criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'C->LEILABOR'		;		// Dados do Laboratorio
			})
	return NIL
end
pb_dbedit1('LeiteP18')  // tela

select LEILABOR
ORDEM ROTDT
VM_CAMPO:=Array(FCount())
VM_DESCR:=Array(FCount())
AFields(VM_CAMPO)
AFields(VM_DESCR)
AEval(VM_DESCR,{|DET,N|VM_DESCR[N]:=substr(VM_DESCR[N],4)})

while .T.
	VM_TARRO	:=0
	VM_DTCOLE:=CtoD('')
	cFilter	:=''
	nX			:=17
//	pb_box(nX++,57,,,,'LEITE-DADOS DO LABORATORIO')
	setcolor('W+/R,R/W+,,,W+/R')
	@22,30 say PadR('Filtro',40)
	@22,40 say 'Nr Tarro :' get VM_TARRO  pict mI6 when pb_msg('Tarro Zerado sera apresentado todos - <ESC> para Sair')
	@22,58 say 'Dt Coleta:' get VM_DTCOLE pict mDT when pb_msg('Data em Branco sera apresentado todas - <ESC> para Sair')
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,.T.,.F.)
		if VM_TARRO>0
			cFilter:='str(LEILABOR->LA_TARRO,6)==str(VM_TARRO,6)'
		end
		if VM_DTCOLE#CtoD('')
			if len(cFilter)>0
				cFilter+='.and.'
			end
			cFilter+='DtoS(LEILABOR->LA_DTCOLE)==DtoS(VM_DTCOLE)' // se Informar Data
		end
		set filter to &cFilter
		DbGoTop()
		dbedit(06,01,maxrow()-3,maxcol()-1,;
					VM_CAMPO,;
					'PB_DBEDIT2',;
					,; // Mascara
					VM_DESCR;
					)
		set filter to
	else
		exit	// Sair do loop
	end
	dbcommit()	
end
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP181() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	LeiteP18T(.T.)
	DbGoTop()
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP182() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if reclock()
	LeiteP18T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP183() // Rotina de Pesquisa
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP184() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
nX:=alert('Excluir ... ',{'Registro','Periodo'})
if nX==1
	ELIMINA_REG('Mensagem: Tarro='+str(FieldGet(4),6)+' Dt.Coleta '+DtoC(FieldGet(3)))
elseif nX==2
	pb_box(18,40,,,,'Selecione')
	VM_DTCOLE:=CtoD('')
	@20,42 say 'Dt.Coleta a excluir:' get VM_DTCOLE	pict mDT
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn('Eliminar todos os dados da coleta '+DtoC(VM_DTCOLE)),.F.)
		set filter to 
		select LEILABOR
		ORDEM DTROT
		DbGoTop()
		DbSeek(DtoS(VM_DTCOLE),.T.) // Iniciar na Data
		while !eof().and.DtoS(LA_DTCOLE)==DtoS(VM_DTCOLE)
			if RecLock()
				pb_msg('Eliminando Dados '+str(LA_TARRO,6))
				DbDelete()
			end
			skip
		end
		select LEILABOR
		ORDEM ROTDT
		set filter to &cFilter
	end
end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP18T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=09
pb_box(nX++,40,,,,'ANALISE DO LEITE-LABORATORIO')
@nX++,42 say 'Dt.Coleta.......:' get VM_DTCOLE		pict mDT;
																	when VM_FL
@nX++,42 say 'Nr.Tarro........:' get VM_TARRO		pict mI6 	valid pb_ifcod2(str(VM_TARRO,6)+DtoS(VM_DTCOLE),NIL,.F.);
																	when VM_FL
nX++
@nX++,42 say 'Nr.Requisicao...:' get VM_NRREQU		pict mI5		valid VM_NRREQU	>=0
@nX++,42 say '% Gordura.......:' get VM_GORDUR		pict mI52	valid VM_GORDUR	>=0
@nX++,42 say '% Proteina......:' get VM_PROTEI		pict mI52	valid VM_PROTEI	>=0
@nX++,42 say '% Lactose.......:' get VM_LACTOS		pict mI52	valid VM_LACTOS	>=0
@nX++,42 say '% Solido Total..:' get VM_PERSOL		pict mI52	valid VM_PERSOL	>=0
@nX++,42 say 'Nr CCS*1000.....:' get VM_NRCCS		pict mI6		valid VM_NRCCS		>=0
@nX++,42 say 'Nr CBT*1000.....:' get VM_NRCBT		pict mI6		valid VM_NRCBT		>=0
@nX++,42 say 'Cod Rota........:' get VM_CDROTA		pict mI6;
																	valid VM_CDROTA	>=0.and.;
																			pb_ifcod2(str(VM_CDROTA,6)+str(VM_TARRO,6),'LEICPROD',.T.,1);
																	when pb_msg('A Rota e o Tarro devem estar Cadastrados')
@nX++,42 say 'Cod Propriedade.:' get VM_CDPROP		pict mI2		valid VM_CDPROP	>=0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		VM_ANOREQ:=Year(	VM_DTCOLE)
		VM_DTANA	:=			VM_DTCOLE
		VM_DTIMP	:=Date()
		VM_USUAR	:=RT_NOMEUSU()
		VM_CDCLI	:=LEICPROD->LC_CDCLI
		VM_ESD	:=VM_PERSOL-VM_GORDUR// 14-ESD-Extrado Seco Desengordurado
		for nX:=1 to fcount()
			nX1:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &nX1
		next
		dbcommit()
	end
end
dbrunlock(RecNo())
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP185() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//------------------------------------------------------------------EOF
