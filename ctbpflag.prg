*-----------------------------------------------------------------------------*
 static aVariav := {0,{},0,0,0,0,0,0}
 //.................1,.2,3,4,5,6,7,8
*-----------------------------------------------------------------------------*
#xtranslate nX       => aVariav\[  1 \]
#xtranslate Flag     => aVariav\[  2 \]
#xtranslate wConta   => aVariav\[  3 \]
#xtranslate wData    => aVariav\[  4 \]
#xtranslate wValor   => aVariav\[  5 \]
#xtranslate wHist    => aVariav\[  6 \]
#xtranslate wChave   => aVariav\[  7 \]
#xtranslate nY       => aVariav\[  8 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------------*
	function CTBPFLAG()	//	muda FLAG contabilização (E)Entrada e (I)Saida Integração
*-----------------------------------------------------------------------------------*

pb_lin4('<Muda Flag Contabilizacao (E)+(S)>',ProcName())

if abre({	'R->PARAMCTB',;
				'R->PARAMETRO';
			})

	if PARAMETRO->PA_CONTAB#chr(255)+chr(25)
		alert('ALERTA;Modulo Contabil nao disponivel;')
		dbcloseall()
		return NIL
	end

	DATA:={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)}
	Flag:={'S','S','S','S','S','S'}
	nX:=11
	pb_box(nX++,16,,,,'Muda Sinalizador de Contabilizacao')
	@nX++,18 say 'NF Entradas..:' get Flag[1] pict mUUU valid Flag[1]$'SN' when pb_msg('Contabilizar NF Entradas ?')
	@nX++,18 say 'Servicos.....:' get Flag[2] pict mUUU valid Flag[2]$'SN' when pb_msg('Contabilizar Faturamento Produtos/Serviços ?')
	//@nX++,18 say 'Conta Parte..:' get Flag[3] pict mUUU valid Flag[3]$'SN' when pb_msg('Contabilizar Lancamentos de Cota Parte ?')
	@nX++,18 say 'Transferencia:' get Flag[4] pict mUUU valid Flag[4]$'SN' when pb_msg('Contabilizar Transferencia de Produtos-Consumo e Producao ?')
	//@nX++,18 say 'Adto Cli/Forn:' get Flag[5] pict mUUU valid Flag[5]$'SN' when pb_msg('Contabilizar Adiantamentos a Clientes e Fornecedores ?')
	//@nX++,18 say 'Conhec.Frete.:' get Flag[6] pict mUUU valid Flag[6]$'SN' when pb_msg('Contabilizar Conhecimento de Frete ?')
	nX++
	@nX++,18 say 'Data Inicial.:' get DATA[1] pict mDT  valid ValidaMesContabilFechado(DATA[1],'CONTABILIZAR')
	@nX++,18 say 'Data Final...:' get DATA[2] pict mDT  valid DATA[2]>=DATA[1].and.ValidaMesContabilFechado(DATA[2],'CONTABILIZAR')
	@nX  ,18 say 'Processando..:'
	nX:=12
	@nX++,48 say 'Ano/Mes Contabil.: '+pb_zer(PARAMCTB->PA_ANO,4)+'/'+pb_zer(PARAMCTB->PA_MES,2)
	read
	dbcloseall()
	if if(lastkey()#K_ESC,pb_sn('Iniciar a Mudança Flag'),.F.)
		//----------------------------------------------------CONTABILIZAR ENTRADAS
		if Flag[1]=='S'
			MudaCtbPImEn(DATA)
		end

		//----------------------------------------------------CONTABILIZAR SERVICOS + FATURAMENTO <- AINDA NÃO CONCLUIDO)
		if Flag[2]=='S'
			MudaCtbPImFa(DATA)
		end

		//----------------------------------------------------CONTABILIZAR COTA PARTE
		//if Flag[3]=='S'
		//	CotaInte(DATA,nX)
		//end

		//----------------------------------------------------CONTABILIZAR TRANSFERENCIA (PROD/CONS/SAIDAS)
		if Flag[4]=='S'
			MudaCtbPMeTr(DATA)
		end

		//----------------------------------------------------CONTABILIZAR ADIANTAMENTOS CLIENTES/FORNECEDOR
		//if Flag[5]=='S'
		//	CxaPInte(DATA,nX)
		//end

		//----------------------------------------------------CONTABILIZAR CONHECIMENTO DE FRETE
		//if Flag[6]=='S'
		//	CtbPInCF(DATA,nX)
		//end
	end
end
dbcloseall()

return NIL

*------------------------------------------------------------------------------------------*
	static function MudaCtbPImEn(pDATA)
*------------------------------------------------------------------------------------------*
nX:=0
beepaler()
if abre({	'R->PARAMETRO',;
				'C->ENTCAB',;
				'C->DIARIO';
			})

	select('ENTCAB')
	ORDEM DTEDOC
	DbGoTop()
	dbseek(dtos(pDATA[1]),.T.)
	while !eof().and.ENTCAB->EC_DTENT<=pDATA[2]
		@12,40 say 'Entradas:'+dtoc(ENTCAB->EC_DTENT)+'/'+str(nX,4)
		if ENTCAB->EC_FLCTB//......................Registro Contabilizado 
			if ENTCAB->(RecLock())
				RemoveCTB('ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE)
				replace ENTCAB->EC_FLCTB with .F. //.Marcar como Nao Contabilizado a NFe/Frete
				DbRLock()
				nX++
			end
		end
		dbskip()
	end
end
dbcloseall()
return NIL

*------------------------------------------------------------------------------------------*
	static function MudaCtbPImFa(pDATA)
*------------------------------------------------------------------------------------------*
nX:=0
beepaler()
if abre({	'R->PARAMETRO',;
				'C->PEDCAB',;
				'C->DIARIO';
			})
	select('PEDCAB')
	ordem DTENNF
	DbGoTop()
	dbseek(dtos(pDATA[1]),.T.)
	while !eof().and.PEDCAB->PC_DTEMI<=pDATA[2]
		@13,40 say 'Notas de Servico:'+pb_zer(PEDCAB->PC_PEDID,6)+'/'+str(nX,4)
		if PEDCAB->PC_FLAG//....................................................Só notas impressas
			if PEDCAB->PC_FLCTB // Registro Contabilizado
				if PEDCAB->(RecLock())
					if PEDCAB->PC_FLSVC //.............................Notas Servico
						replace PEDCAB->PC_FLCTB with .T.
						DbRLock()
						nX++
					end
				end
			end
		end
		dbskip()
	end
	dbcloseall()
end
return NIL

*------------------------------------------------------------------------------------------*
	static function MudaCtbPMeTr(pDATA)
*------------------------------------------------------------------------------------------*
nX:=0
beepaler()
if abre({	'R->PARAMETRO',;
				'C->DIARIO',;//....Lançamentos
				'C->PEDCAB',;//....para transferencias
				'C->PEDDET',;//....para transferencias
				'C->MOVEST';
			})
	select PEDCAB
	ORDEM DTEPED
	dbseek(dtos(pDATA[1]),.T.)
	while !eof().and.dtos(PEDCAB->PC_DTEMI)<=dtos(pDATA[2])
		@14,35 say 'Transf Saidas : '+dtoc(PEDCAB->PC_DTEMI)+'/'+Str(nX,4)
		if PEDCAB->PC_FLAG//..................................Foi Impresso
			if PEDCAB->PC_FLCTB//..............................Foi Contabilizado
				if PEDCAB->(RecLock())//........................Travar Registro
					RemoveCTB('SAIT:'+AllTrim(str(PEDCAB->PC_NRNF,6))+'/'+PEDCAB->PC_SERIE)
					replace PEDCAB->PC_FLCTB with .T.
					DbRLock()
					nX++
				end
			end
		end
		skip
	end
	dbcloseall()
end
return NIL

*--------------------------------------------------------------------------
function RemoveCTB(pChave)
*--------------------------------------------------------------------------
salvabd(SALVA)
select DIARIO
DbGoTop()
while !eof()
//	alert('Chave:'+trim(pChave)+';Diari:'+DIARIO->DI_DOCTO+';Igual?'+if(trim(pChave)==trim(DIARIO->DI_DOCTO),"S","N"))
	if trim(pChave)==trim(DIARIO->DI_DOCTO)
		if RecLock()
			DbDelete()
			DbRLock()
		end
	end
	skip
end
salvabd(RESTAURA)
return NIL
*---------------------------------------------------EOF------------------
