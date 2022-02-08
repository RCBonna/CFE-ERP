*-----------------------------------------------------------------------------*
function CFEPTRNF() // Transferencia de dados da NF Entrada/Saida					*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local DIRETORIO:='NFS_'
local ARQS
local ANO
local X
if !abre({'E->PARAMETRO','E->ENTDET','E->ENTCAB','E->PEDDET','E->PEDCAB'})
	return NIL
end
ANO      :=year(PARAMETRO->PA_DATA)-1
DIRETORIO+=pb_zer(ANO,4)
if !pb_sn('Transferir dados de NF ref ano '+str(ANO,4)+';e eliminar os dados dos arquivos atuais ?')
	dbcloseall()
	return NIL
end
if file(DIRETORIO+'\CFEAED.DBF')
	alert('Dados do Ano de '+right(DIRETORIO,4)+' j  liberado')
	dbcloseall()
	return NIL
end
dbcloseall()
dirmake(DIRETORIO)
ARQS:={	'CFEAEC.DBF',;
			'CFEAED.DBF',;
			'CFEAPC.DBF',;
			'CFEAPD.DBF'}
			
	for X:=1 to len(ARQS)
		fn_transf(DIRETORIO,ARQS[X],filesize(ARQS[X]))
	next
	
	if file(DIRETORIO+'\'+ARQS[1])
		use (DIRETORIO+'\'+ARQS[2]) new alias ENTRADA1
		Index on str(ED_DOCTO,8)+str(ED_CODFO,5) to LIXO
		use (DIRETORIO+'\'+ARQS[1]) new alias ENTRADA
		while !eof()
			if year(ENTRADA->EC_DTENT)#ANO
				salvabd(SALVA)
				select('ENTRADA1')
				dbseek(str(ENTRADA->EC_DOCTO,8)+str(ENTRADA->EC_CODFO,5),.T.)
				dbeval({||dbdelete()},,{|| str(ENTRADA->EC_DOCTO,8)+str(ENTRADA->EC_CODFO,5)==;
													str(ED_DOCTO,8)+str(ED_CODFO,5)})
				salvabd(RESTAURA)
				dbdelete()
			end
			dbskip()
		end
		pack
		close
		select('ENTRADA1')
		pack
		close
	end

	if file(DIRETORIO+'\'+ARQS[3])
		use (DIRETORIO+'\'+ARQS[4]) new alias SAIDA1
		Index on str(PD_PEDID,6) to LIXO
		use (DIRETORIO+'\'+ARQS[3]) new alias SAIDA
		while !eof()
			if year(SAIDA->PC_DTEMI)#ANO
				salvabd(SALVA)
				select('SAIDA1')
				dbseek(str(SAIDA->PC_PEDID,6),.T.)
				dbeval({||dbdelete()},,{|| str(SAIDA->PC_PEDID,6)==;
													str(SAIDA1->PD_PEDID,6)})
				salvabd(RESTAURA)
				dbdelete()
			end
			dbskip()
		end
		pack
		close
		select('SAIDA1')
		pack
		close
	end
	
	while !abre({'E->ENTDET','E->ENTCAB'});end
	pb_msg('Apagando registros do arquivo de Notas Fiscais - Entradas',NIL,.F.)
	DbGoTop()
	while !eof()
		if year(ENTCAB->EC_DTENT)==ANO
			salvabd(SALVA)
			select('ENTDET')
			dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
			dbeval({||dbdelete()},	{||ENTCAB->EC_CODFO==ENTDET->ED_CODFO},;
											{||str(ENTCAB->EC_DOCTO,8)==;
												str(ENTDET->ED_DOCTO,8)})
			salvabd(RESTAURA)
			dbdelete()
		end
		dbskip()
	end
	pb_msg('Organizando Notas Fiscais - Entrada',NIL,.F.)
	pb_compac(.T.)
	select('ENTDET')
	pb_compac(.T.)
	dbcloseall()

	while !abre({'E->PEDDET','E->PEDCAB'});end
	pb_msg('Apagando registros do arquivo de Notas Fiscais - Saidas',NIL,.F.)
	dbsetorder(4)
	DbGoTop()
	while !eof()
		if year(PC_DTEMI)==ANO.and.PC_FLAG
			salvabd(SALVA)
			select('PEDDET')
			dbseek(str(PEDCAB->PC_PEDID,6),.T.)
			dbeval({||dbdelete()},,{|| str(PEDCAB->PC_PEDID,6)==;
												str(PEDDET->PD_PEDID,6)})
			salvabd(RESTAURA)
			dbdelete()
		end
		dbskip()
	end
	pb_msg('Organizando Notas Fiscais - Saidas',NIL,.F.)
	pb_compac(.T.)
	select('PEDDET')
	pb_compac(.T.)
	dbcloseall()

return NIL
