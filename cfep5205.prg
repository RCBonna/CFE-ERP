//-----------------------------------------------------------------------------*
 static aVariav := {0, 0, 0, {}, 0}
 //.................1..2..3...4..5..6...7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nX1        => aVariav\[  2 \]
#xtranslate nReg       => aVariav\[  3 \]
#xtranslate aDados     => aVariav\[  4 \]
#xtranslate nRegN      => aVariav\[  5 \]

//-----------------------------------------------------------------------------*
  function CFEP5205() // re-Imprime NF a partir de outra (Simples Remessa)
//-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_SERIE:=space(3)
local VM_NRNF :=0
dbsetorder(5)
pb_box(10,00,,,,'Selecao de NF Base para Simples Remessa')
@11,04 say 'Serie :'           get VM_SERIE pict masc(01)
@11,30 say 'Numero NF Origem:' get VM_NRNF  pict masc(19) valid pb_ifcod2(str(VM_NRNF,6)+VM_SERIE,NIL,.T.,5)
read
if lastkey()#K_ESC
	if !PC_FLCAN
		set function 10 to '+'+chr(13)
		VM_CLI   :=PC_CODCL
		VM_CODOP :=PC_CODOP
		VM_OBS   :=PC_OBSER
		VM_ICMSPG:=0
		@13,04 say 'Data Emissao: '+transform(PC_DTEMI,masc(07))
		@14,04 say 'Total NF....: '+transform(PC_TOTAL,masc(2))
		@16,04 say 'Cliente.....:'  get VM_CLI   pict mI5  valid fn_codigo(@VM_CLI,  {'CLIENTE', {||CLIENTE->(dbseek(str(VM_CLI,5)))},  {||CFEP3100T(.T.)},{2,1,8,7}}).and.fn_libcli().and.eval({||VM_VEND:=CLIENTE->CL_VENDED})>=0
		@17,04 say 'Nat.Operac..:'  get VM_CODOP pict mNAT valid fn_codigo(@VM_CODOP,{'NATOP',   {||NATOP->(dbseek(str(VM_CODOP,7)))},  {||CFEPNATT(.T.)},{1,2,3}}).and.NATOP->NO_TIPO$'S'.and.confNatOp(CLIENTE->CL_UF,'CLIENTE') when VM_SERIE#'ADT'
		@19,01 say 'OBS:'           get VM_OBS   pict mUUU+'S70'  valid fn_obs(@VM_OBS) when pb_msg('Informe Observacao para a Pedido F10-para buscar OBS')
		read
		set function 10 to 
		if pb_sn()
			CFEP5205X()
		end
	else
		alert('NF esta Cancelada')
	end
end
dbsetorder(2)
DbGoTop()
return NIL

//--------------------------------------------------------------------------*
  static function CFEP5205X() // REimpressao notas fiscal
//--------------------------------------------------------------------------*
VM_BCO   := 0
VM_ULTDP := 0
VM_PARCE := 0
nReg     :=recno()

VM_ULTPD:=fn_psnf('PED')
ORDEM GPEDIDO
while dbseek(str(VM_ULTPD,6))
	VM_ULTPD:=fn_psnf('PED')
end
ORDEM FPEDIDO
go nReg // volta registro origem

//VM_ULTPD  := PC_PEDID
VM_SERIE  :=        PC_SERIE
VM_ULTNF  :=fn_psnf(VM_SERIE) // pega pb_brake() número de NF da Série
//VM_ULTNF :=PC_NRNF
@12,04 say 'N£mero da Nota Fiscal a ser Impressa.: '+str(VM_ULTNF,6)
@13,40 say 'Novo pedido:'+str(VM_ULTPD,7)
CopiaReg()
nRegN    :=recno()
replace 	PC_PEDID with VM_ULTPD,;
			PC_NRNF  with VM_ULTNF,;
			PC_CODOP with VM_CODOP,;
			PC_CODCL with VM_CLI,;
			PC_FLCTB with .T.,;
			PC_FLCXA with .T.,;
			PC_NRCXA with  0 ,;
			PC_CODBC with  VM_BCO ,;
			PC_CODCG with  0 ,;
			PC_NRDPL with VM_ULTDP,;
			PC_FATUR with VM_PARCE,;
			PC_OBSER with VM_OBS
go nReg // volta registro origem para duplicar os registro filhos
select('PEDDET')
dbseek(str(PEDCAB->PC_PEDID,6),.T.)
while !eof().and.PEDCAB->PC_PEDID == PEDDET->PD_PEDID
	nReg  :=recno()
	CopiaReg()
	replace  PD_PEDID with VM_ULTPD,;
				PD_CODOP with VM_CODOP
	go nReg
	skip
end
dbcommitall()

select('PEDCAB')
go nRegN // volta registro origem para duplicar os registro filhos
CTRNF->   (dbseek(PEDCAB->PC_SERIE))
VENDEDOR->(dbseek(str(PEDCAB->PC_VEND,3)))
NATOP->   (dbseek(str(PEDCAB->PC_CODOP,7)))
CLIENTE-> (dbseek(str(PEDCAB->PC_CODCL,5)))
VM_NOMEC  :=CLIENTE->CL_RAZAO
VM_NOMNF  :=VM_NOMEC    //CLIENTE->CL_RAZAO
XOBSX     :=array(20,2)
VM_ICMT   :={0,0}
VM_DET    :=fn_rtprdped(VM_ULTPD)
VM_ICMS   :=FN_ICMSC(VM_DET)
VM_AVALIS :=0
VM_AVAL   :={0,space(45),space(45),space(18)}
I_TRANS   :=CFEPTRANL()
VM_FAT    :={}
if pb_sn('Imprimir NF Simples Remessa ?')
	CFEPIMNF() // rot impressao
else
	//..............Excluir.........
	select('PEDDET')
	dbseek(str(PEDCAB->PC_PEDID,6),.T.)
	while !eof().and.PEDCAB->PC_PEDID == PEDDET->PD_PEDID
		if RecLock()
			dbdelete()
		end
		skip
	end
	select('PEDCAB')
	dbdelete()
	fn_backnf(VM_SERIE,VM_ULTNF)
	fn_backnf('PED',   VM_ULTPD)
end

select('PEDCAB')
dbunlockall()
DbGoTop()
if eof().or.bof()
	keyboard '0'
end
setcolor(VM_CORPAD)
return NIL

*-------------------------------------------------------------
  static function CopiaReg()
*-------------------------------------------------------------
aDados:={}
for nX:=1 to fCount()
	aadd(aDados,FieldGet(nX))
end
while !AddRec(,aDados)
end
dbcommitall()
return NIL

//-----------------------------------------------EOF
