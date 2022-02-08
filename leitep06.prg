//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.,'',0,''}
//....................1.2..3..4..5..6
//-----------------------------------------------------------------------------*
#xtranslate cArq			=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate LCONT			=> aVariav\[  3 \]
#xtranslate cArqExp		=> aVariav\[  4 \]
#xtranslate nRota			=> aVariav\[  5 \]
#xtranslate cMsg			=> aVariav\[  6 \]
 
#include 'RCB.CH'
//-----------------------------------------------------------------------------*
  function LeiteP06()	//	Exportar Dados
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'		,;
				'R->LEIPARAM'		,;
				'R->PROD'			,;
				'R->CLIENTE'		,;
				'R->LEITRANS'		,;
				'R->LEIMOTIV'		,;
				'R->LEIVEIC'		,;
				'R->LEIROTA'		,;		// criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		;		// Criado arquivo no LEITEP00.PRG
			})
	return NIL
end
nX			:=11
cArqExp	:={	padr('PRODUTOR.TXT',50),;					//....1
					padr('ROTA_TRANSPORTADOR.TXT',50),;		//....2
					padr('MOTIVO_REJEICAO.TXT',50),;			//....3
					padr('TRANSPORTADOR_PLACA.TXT',50);		//....4
				}
pb_box(nX++,0,,,,'LEITE-Exportar Dados em Arquivo')
 nX++

select LEIROTA
DBGoBottom();nRotaFim:=LR_CDROTA
DBGoTop()	;nRotaIni:=LR_CDROTA
select LEIPARAM
VM_DIREXPO:=LEIPARAM->LP_DIREXPO

@nX++,01 say 'Diretorio Exportacao Arq.:' get VM_DIREXPO	pict mUUU	valid IsDirectory(trim(VM_DIREXPO))
@nX++,01 say 'Arq.Rota x Produtor......:' get cArqExp[1]	pict mUUU	valid !empty(cArqExp[1])
@nX++,01 say 'Arq.Transportador........:' get cArqExp[2]	pict mUUU	valid !empty(cArqExp[2])
@nX++,01 say 'Arq.Motivos de Rejeicao..:' get cArqExp[3]	pict mUUU	valid !empty(cArqExp[3])
@nX++,01 say 'Arq.Transport. x Placas..:' get cArqExp[4]	pict mUUU	valid !empty(cArqExp[4])
 nX++
@nX++,01 say 'Rota Inicial.............:' get nRotaIni	pict mI6		;
														valid fn_codigo(@nRotaIni,{'LEIROTA',{||LEIROTA->(dbseek(str(nRotaIni,6)))},{||NIL},{2,1}})
@nX++,01 say 'Rota Final...............:' get nRotaFim	pict mI6		;
														valid nRotaFim>=nRotaIni.and.fn_codigo(@nRotaFim,{'LEIROTA',{||LEIROTA->(dbseek(str(nRotaFim,6)))},{||NIL},{2,1}})
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	cNomeArq:=trim(VM_DIREXPO)+if(right(trim(VM_DIREXPO),1)=="\", "","\") + trim(cArqExp[1])
	if pb_ligaimp(,cNomeArq)
		select LEICPROD
		dbseek(str(nRotaIni,6),.T.)
		while !eof().and.LEICPROD->LC_CDROTA<=nRotaFim
			if nRota#LEICPROD->LC_CDROTA
				nRota:=LEICPROD->LC_CDROTA
				LEIROTA->(dbseek(str(LEICPROD->LC_CDROTA,6))) // Pesquisar em Rotas
			end
			CLIENTE->(dbseek(str(LEICPROD->LC_CDCLI,5)))
			??pb_zer(LEICPROD->LC_CDROTA,6)			+';'
			??trim(LEIROTA->LR_DESCR)					+';'
			??DtoC(LEIROTA->LR_DTVALID)				+';'
			??pb_zer(LEICPROD->LC_SEQUENC,3)			+';'
			??pb_zer(LEICPROD->LC_CDFILI,2)			+';'
			??pb_zer(LEICPROD->LC_CDCLI,6)			+';'
			??if(CLIENTE->CL_TIPOFJ=='F','1','2')	+';'
			??trim(CLIENTE->CL_CGC)						+';'
			??trim(CLIENTE->CL_RAZAO)					+';'
			??pb_zer(LEICPROD->LC_CDPROP,2)			+';'
			??pb_zer(LEICPROD->LC_ESTABUL,2)			+';'
			??pb_zer(LEICPROD->LC_TARRO,6)			+';'
			??StrTran(Trim(CLIENTE->CL_ENDER),';')	+';'
			??StrTran(Trim(CLIENTE->CL_FONE),';')	+';'
			??Transform(LEICPROD->LC_ANA_CCS,mD12)	+';'
			??Transform(LEICPROD->LC_ANA_CBT,mD12)	+';'
			?
			skip
		end
		pb_deslimp(,,.F.)
		cMsg:='MENSAGEM - ARQUIVOS GERADOS;'
		cMsg+=';'+padr(cNomeArq,50)
	end

	cNomeArq:=trim(VM_DIREXPO)+if(right(trim(VM_DIREXPO),1)=="\", "","\") + trim(cArqExp[2])
	if pb_ligaimp(,cNomeArq)
		select LEITRANS
		dbgoTop()
		while !eof()
			??pb_zer(LT_CDROTA,6)+';'
			??pb_zer(LT_CDTRAN,5)+';'
			?
			skip
		end
	end
	pb_deslimp(,,.F.)
	cMsg+=';'+padr(cNomeArq,50)
	
	cNomeArq:=trim(VM_DIREXPO)+if(right(trim(VM_DIREXPO),1)=="\", "","\") + trim(cArqExp[3])
	if pb_ligaimp(,cNomeArq)
		select LEIMOTIV
		dbgoTop()
		while !eof()
			??pb_zer(LM_CDMOTIV,4)	+';'
			??trim(LM_DESCR)			+';'
			?
			skip
		end
	end
	pb_deslimp(,,.F.)
	cMsg+=';'+padr(cNomeArq,50)

	cNomeArq:=trim(VM_DIREXPO)+if(right(trim(VM_DIREXPO),1)=="\", "","\") + trim(cArqExp[4])
	if pb_ligaimp(,cNomeArq)
		select LEIVEIC
		dbgoTop()
		while !eof()
			??pb_zer(LV_CDTRAN,5)	+';'
			??trim(LV_PLACA)			+';'
			?
			skip
		end
	end
	pb_deslimp(,,.F.)
	cMsg+=';'+padr(cNomeArq,50)

	Alert(cMsg)
end
dbcloseall()
return NIL

//------------------------------------------------------------------EOF
