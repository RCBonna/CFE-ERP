*-----------------------------------------------------------------------------*
 function LimpaHis()	// Limpeza de Históricos
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_lin4(_MSG_,ProcName())
if !xxsenha(ProcName(),'Limpeza Historico/2')
	return NIL
end
setcolor(VM_CORPAD)
pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'E->PARAMETRO',;
				'E->HISFOR',;
				'E->HISCLI',;
				'E->ENTCAB',;
				'E->ENTDET',;
				'E->MOVEST',;
				'E->PEDCAB',;
				'E->PEDDET',;
				'E->PEDSVC'})

	return NIL
end
if !pb_sn('A T E N C A O;Esta rotina fara a limpeza;dos dados historicos;Desistir ?')
	iCont:={0,0}
	pb_msg('Eliminando Historico de Fornecedor...')
	select HISFOR
	DbGoTop()
	while !eof()
		iCont[1]++
		@24,65 say str(iCont[1],6)+'/'+str(iCont[2],6)
		if HF_SERIE==SCOLD
			iCont[2]++
			delete
		end
		skip
	end
	pb_msg('Reordenando...')
	pack

	iCont:={0,0}
	pb_msg('Eliminando Historico de Clientes...')
	select HISCLI
	DbGoTop()
	while !eof()
		iCont[1]++
		@24,65 say str(iCont[1],6)+'/'+str(iCont[2],6)
		if HC_SERIE==SCOLD
			iCont[2]++
			delete
		end
		skip
	end
	pb_msg('Reordenando...')
	pack

	iCont:={0,0}
	pb_msg('Eliminando Historico de NF Entradas...')
	select ENTCAB
	DbGoTop()
	while !eof()
		iCont[1]++
		@24,65 say str(iCont[1],6)+'/'+str(iCont[2],6)
		if EC_SERIE==SCOLD
			iCont[2]++
			select ENTDET
			dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
			while !eof().and.str(ENTCAB->EC_DOCTO,8)==str(ENTDET->ED_DOCTO,8)
				if ENTCAB->EC_CODFO == ENTDET->ED_CODFO
					delete
				end
				skip
			end
			select ENTCAB
			delete
		end
		skip
	end
	pb_msg('Reordenando...')
	select ENTDET
	pack
	select ENTCAB
	pack

	iCont:={0,0}
	pb_msg('Eliminando Historico de NF Saida...')
	select PEDCAB
	DbGoTop()
	while !eof()
		iCont[1]++
		@24,65 say str(iCont[1],6)+'/'+str(iCont[2],6)
		if PC_SERIE==SCOLD
			iCont[2]++
  			select PEDDET
			dbseek(str(PEDCAB->PC_PEDID,6),.T.)
			dbeval({||fn_elimi()},,{||PEDCAB->PC_PEDID==PD_PEDID})
			select PEDSVC
			dbseek(str(PEDCAB->PC_PEDID,6),.T.)
			dbeval({||fn_elimi()},,{||PEDCAB->PC_PEDID==PS_PEDID})
			select PEDCAB
			delete
		end
		skip
	end
	pb_msg('Reordenando...')
	select PEDSVC
	pack
	select PEDDET
	pack
	select PEDCAB
	pack
end
dbcloseall()
return NIL
