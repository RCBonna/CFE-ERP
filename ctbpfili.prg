*-----------------------------------------------------------------------------*
function CTBPFILI()	//	Integra E/S Filial
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

beepaler()
if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
				'C->CTACTB',;
				'C->PROD',;
				'C->CTATIT',;
				'C->CTADET',;
				'C->CLIENTE',;
				'C->ENTDET',;
				'C->ENTCAB',;
				'C->PEDDET',;
				'C->PEDCAB',;
				'C->NATOP'})
	return NIL
end
pb_lin4('Atualizacao Contabil FILIAL <ENTRADA/SAIDAS>',ProcName())

VM_DATA :={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)}
VM_CONTA:={0,0,0,0}
ARQ     :='CTASFILI.ARR'
if file('CTASFILI.ARR')
	VM_CONTA:=restarray(ARQ)
end
VM_CTA1:=VM_CONTA[1]
VM_CTA2:=VM_CONTA[2]
VM_CTA3:=VM_CONTA[3]
VM_CTA4:=VM_CONTA[4]
VM_CTAX:=space(20)

pb_box(10,16,,,,'Contas Contabeis/Selecao')
@11,18 say 'Entradas   (D):' get VM_CTA1 pict mI4 valid fn_ifconta(@VM_CTAX,@VM_CTA1)
@12,18 say '           (C):' get VM_CTA2 pict mI4 valid fn_ifconta(@VM_CTAX,@VM_CTA2)

@13,18 say 'Saidas     (C):' get VM_CTA4 pict mI4 valid fn_ifconta(@VM_CTAX,@VM_CTA4)
@14,18 say '           (D):' get VM_CTA3 pict mI4 valid fn_ifconta(@VM_CTAX,@VM_CTA3)

@16,18 say 'Data Inicial..:' get VM_DATA[1] pict masc(07)
@17,18 say 'Data Final....:' get VM_DATA[2] pict masc(07) valid VM_DATA[2]>=VM_DATA[1]
@21,18 say 'Processando...:'
read
if lastkey()#K_ESC
	//---------------ENTRADA - ENTRADA----------------------------------------
	//---------------ENTRADA - ENTRADA----------------------------------------
	//---------------ENTRADA - ENTRADA----------------------------------------
	//---------------ENTRADA - ENTRADA----------------------------------------
	VM_CONTA[1]:=VM_CTA1
	VM_CONTA[2]:=VM_CTA2
	VM_CONTA[3]:=VM_CTA3
	VM_CONTA[4]:=VM_CTA4
	SAVEARRAY(VM_CONTA,ARQ)

//----------------------------------------------------------------------------------------------------
	select('PROD')
		ordem CODIGO
	select('ENTCAB')
		ordem DTEDOC
	DbGoTop()
	dbseek(dtos(VM_DATA[1]),.T.)
	while !eof().and.ENTCAB->EC_DTENT<=VM_DATA[2]
		@21,40 say ENTCAB->EC_DOCTO
		if !ENTCAB->EC_FLCTB.and.ENTCAB->(reclock())
			CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
			CTBPFILIE(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5))
			replace ENTCAB->EC_FLCTB with .T.
		end
		dbunlockall()
		dbskip()
	end

	//-------------------SAIDAS - SAIDAS---------------------------------------
	//-------------------SAIDAS - SAIDAS---------------------------------------
	//-------------------SAIDAS - SAIDAS---------------------------------------
	//-------------------SAIDAS - SAIDAS---------------------------------------
	//-----------------------------------------------------------------------

	select('PROD')
		ordem CODIGO
	select('PEDCAB')
		ordem DTENNF
	DbGoTop()
	dbseek(dtos(VM_DATA[1]),.T.)
	while !eof().and.PEDCAB->PC_DTEMI<=VM_DATA[2]
		@21,40 say PEDCAB->PC_PEDID
		if PEDCAB->PC_FLAG.and.!PEDCAB->PC_FLCTB.and.PEDCAB->(reclock())
			CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
			CTBPFILIS(PEDCAB->PC_PEDID)
			replace PC_FLCTB with .T.
		end
		dbunlockall()
		dbskip()
	end

end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CTBPFILIE(P1)
*-----------------------------------------------------------------------------*
local VM_VLRS :=0

salvabd(SALVA)
select('ENTDET')
dbseek(P1,.T.)
while !eof().and.(str(ENTDET->ED_DOCTO,8)+ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5))==P1
	PROD->(dbseek(str(ENTDET->ED_CODPR,L_P)))
	VM_VLRS+=round(ENTDET->ED_VALOR,2)	// VLR COMPRA
	dbskip()
end
salvabd(RESTAURA)
	fn_atdiarix(ENTCAB->EC_DTENT,;
					VM_CTA1,;				// CTA Estoque
					DEB*VM_VLRS,;
 					'Produto Deposito cfe NF '+alltrim(str(ENTDET->ED_DOCTO))+' de '+CLIENTE->CL_RAZAO,;
					'EN'+P1)

	fn_atdiarix(ENTCAB->EC_DTENT,;
					VM_CTA2,;				// CTA FORNECEDOR
					CRE*VM_VLRS,;
 					'Produto Deposito cfe NF '+alltrim(str(ENTDET->ED_DOCTO))+' de '+CLIENTE->CL_RAZAO,;
					'EN'+P1)
return NIL

*-----------------------------------------------------------------------------*
function CTBPFILIS(P1)
*-----------------------------------------------------------------------------*
local VM_ULTNF:=PC_NRNF
local VM_VLRS :=0

salvabd(SALVA)
select('PEDDET')
dbseek(str(P1,6),.T.)
while !eof().and.PEDDET->PD_PEDID==P1
	PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
	VM_VLRS+=round(PEDDET->PD_VALOR*PEDDET->PD_QTDE,2)	// VLR VENDA
	dbskip()
end
salvabd(RESTAURA)
	fn_atdiarix(PEDCAB->PC_DTEMI,;
					VM_CTA4,;	// CTA Estoque
					CRE*VM_VLRS,;
					'Retirada Produto Dep. cfe NF '+alltrim(str(VM_ULTNF))+' de '+CLIENTE->CL_RAZAO,;
					'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)

	fn_atdiarix(PEDCAB->PC_DTEMI,;
					VM_CTA3,;	// CTA CUSTO MERC VENDIDA
					DEB*VM_VLRS,;
					'Retirada Produto Dep. cfe NF '+alltrim(str(VM_ULTNF))+' de '+CLIENTE->CL_RAZAO,;
					'FT'+str(VM_ULTNF,6)+PEDCAB->PC_SERIE)

return NIL

*-----------------------------------------------------------------------------*
// Especial
// Atual saldo das Contas - 	P1 - Data
//										P2 - Conta
//										P3 - Valor
//										P4 - Historico
//										P5 - Docto

static function FN_ATDIARIX(P1,P2,P3,P4,P5)
*-----------------------------------------------------------------------------*
if str(P2,15,2)<>str(0,15,2).and.str(P3,15,2)<>str(0,15,2)
	salvabd(SALVA)
	select('DIARIO')
	while !AddRec();end
	fieldput(1,P1)
	fieldput(2,P2)
	fieldput(3,P3)
	fieldput(4,P4)
	fieldput(5,P5)
	dbrunlock(recno())
	salvabd(RESTAURA)
end
return NIL
*-----------------------------------------EOF---------------------------------*
