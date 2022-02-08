*-----------------------------------------------------------------------------*
 static aVariav:= {'','','','', 0, '', '','','','','','','', 0,'',{},{},''}
 //.................1. 2..3..4..5...6...7..8..9.10.11.12.13.14.15.16.17.18
*-----------------------------------------------------------------------------*
#xtranslate dData      => aVariav\[  1 \]
#xtranslate cArq       => aVariav\[  2 \]
#xtranslate cDirExpo   => aVariav\[  3 \]
#xtranslate cCmd       => aVariav\[  4 \]
#xtranslate nX         => aVariav\[  5 \]
#xtranslate cArqDR     => aVariav\[  6 \]
#xtranslate cArqDP     => aVariav\[  7 \]
#xtranslate cArqEC     => aVariav\[  8 \]
#xtranslate cArqED     => aVariav\[  9 \]
#xtranslate cArqPC     => aVariav\[ 10 \]
#xtranslate cArqPD     => aVariav\[ 11 \]
#xtranslate cArqCT     => aVariav\[ 12 \]
#xtranslate cArqCTc    => aVariav\[ 13 \]
#xtranslate nErrDir    => aVariav\[ 14 \]
#xtranslate cArqZip    => aVariav\[ 15 \]
#xtranslate aFileGra   => aVariav\[ 16 \]
#xtranslate aFileDir   => aVariav\[ 17 \]
#xtranslate cDirDest   => aVariav\[ 18 \]

*-----------------------------------------------------------------------------*
 function EXPCFE()	// EXPORTA DADOS CFE -> CFE
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'R->PARAMETRO',;
				'R->DPFOR',;
				'R->DPCLI',;
				'E->DIARIO',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->ENTCAB',;
				'R->ENTDET'})
	return NIL
end
pb_lin4(_MSG_,ProcName())

alert('RECOMENDACAO;Antes de usar esta rotina;FAZER BACK-UP')

dDATA  :=PARAMETRO->PA_DATA
cDirDest :='C:\TEMP\INTEGR'
cDirExpo :='C:\TEMP\EXPORT'
cArqZip	:=''
pb_box(15,20,,,,'Selecao Exportacao')
@16,22 say 'Diretorio de Trabalho: '+diskName()+':'+DirName()
@17,22 say 'Diretorio de Exportar: '+cDirExpo //when pb_msg('Diretorio para gerar arquivos de Exportacao-DBF')
@18,22 say 'Diretorio de Destino.: '+cDirDest //when pb_msg('Diretorio para gerar arquivos de Compactado-ZIP')
@19,22 say 'Data Exportar........:' get dData  pict mDT  //valid dData > PARAMETRO->PA_DATA-30
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	nErrDir:=DirMake(cDirExpo+ '\')
	nErrDir:=DirMake(cDirDest+ '\')
	
	FileDelete (cDirExpo+'\*.DBF') //.........................Limpar Diretório
		
		cArqDP :=cDirExpo+'\EX'+ right(dtos(dData),4) +'DP.DBF'
		cArqDR :=cDirExpo+'\EX'+ right(dtos(dData),4) +'DR.DBF'
		cArqCT :=cDirExpo+'\EX'+ right(dtos(dData),4) +'CT.DBF'
		cArqCTc:=  'C:\TEMP\EX'+ right(dtos(dData),4) +'CT.DBF'
		
		pb_msg('Exportando dados dos Fornecedores',1)
		select('DPFOR')
		set order to 0
		go top
		copy to (cArqDP) for DPFOR->DP_DTEMI == dData

		pb_msg('Exportando dados dos Clientes',1)
		select('DPCLI')
		set order to 0
		go top
		copy to (cArqDR) for DPCLI->DR_DTEMI == dData

		// Lançamentos da Contabilidade
		pb_msg('Exportando dados da Contabilidade',1)
		select('DIARIO')
		set order to 0
		go top
		copy to (cArqCT)
		go top
		if !file(cArqCTc)
			copy to (cArqCTc) // Cópia dos lancamentos contábeis em temp
		else
			for nX:=1 to 20
				cArqCTc:=substr(cArqCTc,1,len(cArqCTc)-1)+chr(70+nX)
				alert('Novo Arq='+cArqCTc)
				if !file(cArqCTc)
					copy to (cArqCTc) // Cópia dos lancamentos contábeis em temp
					nX:=1000
				end
			next
		end
		zap
		
		if pb_sn('Iniciar Compactacao de Dados em '+cDirDest+ ' ?')
			cArqZip:=cDirDest + '\CFE_'+right(dtos(dData),4)+'.ZIP'
			FileDelete (cArqZip)
			aFileDir:=Directory(cDirExpo+'\*.*')
			aFileGra:={}
			if len(aFileDir)>0
				AEval(aFileDir,{|DET|aadd(aFileGra,cDirExpo+'\'+DET[1])})
				hb_zipfile(cArqZip,aFileGra,9,,.T.,'[EXPO]',.T.,.F.)
			else
				Alert('Arquivos nao encontrados em '+cDirExpo)
			end
		end

end
dbcloseall()
return NIL
*----------------------------------------------------------Pgto Clientes/Fornec

*-----------------------------------------------------------------------------*
 function IMPCFE()	// IMPORTA DADOS CFE -> CFE
*-----------------------------------------------------------------------------*
if !abre({	'C->PARAMETRO',;
				'C->DPFOR',;
				'C->HISFOR',;
				'C->DPCLI',;
				'C->HISCLI',;
				'C->PEDCAB',;
				'C->PEDDET',;
				'C->ENTCAB',;
				'C->ENTDET'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
select 'DPFOR'
ORDEM DLPDTV

select 'DPCLI'
ORDEM DPLDTV

select 'HISCLI'
ORDEM NNFSER

dDATA :=PARAMETRO->PA_DATA
cDirExpo :='C:\TEMP\EXPORT'
cDirDest :='C:\TEMP\INTEGR'
cArqZip:=''
cDest1 :={'',''}


pb_box(16,20,,,,'Selecao')
@18,22 say 'Data a Importar.......:' get dData  pict mDT  // valid dData > PARAMETRO->PA_DATA-15
@19,22 say 'Diretorio de Importar.: '+cDirDest
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	nErrDir:=DirMake(cDirExpo)
	cArqZip:=cDirDest + '\CFE_'+right(DtoS(dData),4)+'.ZIP'	// CFE_mmdd.ZIP
	if pb_sn('Importar Arquivos: '+cArqZip+ ' ?')
		if file(cArqZip)
			FileDelete (cDirExpo+'\*.DBF') //.........................Limpar Diretório
			aExtract := hb_GetFilesInZip( cArqZip ) // Lista dos arquivos a serem descompactados
			cDest1[1]:= DiskName()
			cDest1[2]:= DirName()
			if !hb_UnZipFile(cArqZip,,.T.,'[EXPO]','C:\',aExtract)
				Alert('Arquivo nao foram descompactados')
				dbcloseall()
				return NIL
			end
			// .........................Será dentro de export pois esta embutido no zip
			DiskChange(cDest1[1]) //....Voltar Drive
			DirChange (cDest1[2])	//..Voltar Path
			
			cArqDR:=cDirExpo+'\EX'+ right(dtos(dData),4) +'DR.DBF'
			cArqDP:=cDirExpo+'\EX'+ right(dtos(dData),4) +'DP.DBF'
			cArqCT:=cDirExpo+'\EX'+ right(dtos(dData),4) +'CT.DBF'
	
			//-----------------------------------------------------------DUP RECEBER
			//-----------------------------------------------------------DUP RECEBER
			pb_msg('Atualizando arquivos de Duplicatas a Receber....',1)
			if file (cArqDR)
				use (cArqDR) Alias WORK New
				DbGoTop()
				while !eof()
					select('DPCLI')
					DbGoTop()
					if !dbseek(str(WORK->DR_DUPLI,8)+dtos(WORK->DR_DTVEN)) // Não tem ESTA Duplicatas Pendentes (Gravar)
						if !HISCLI->(dbseek(str(WORK->DR_NRNF,9)+WORK->DR_SERIE)) // Não tem no Histórico/Pago (Gravar)
							AddRec()
							for nX:=1 to FCount()
								DPCLI->(FieldPut(nX,WORK->(fieldGet(nX))))
							next
							DBCommit()
						end
					end
					select('WORK')
					skip
				end
				select('WORK')
				close
//				FileDelete (cArqDR)
			else
				Alert('Arquivo de Duplicatas a RECEBER do dia '+DTOC(dData)+';Verifique Arquivo '+cArqDR+' que nao foi encontrado')
			end

			//----------------------------------------------------------DUP PAGAR
			//----------------------------------------------------------DUP PAGAR
			pb_msg('Atualizando arquivos de Duplicatas a pagar....',1)
			if file (cArqDP)
				use (cArqDP) Alias WORK New
				DbGoTop()
				while !eof()
					select('DPFOR')
					if !dbseek(str(WORK->DP_DUPLI,8)+dtos(WORK->DP_DTVEN))
						AddRec()
						for nX:=1 to FCount()
							DPFOR->(FieldPut(nX,WORK->(fieldGet(nX))))
						next
						DBCommit()
					end
					select('WORK')
					skip
				end
				select('WORK')
				close
			else
				Alert('Arquivo de Duplicatas a PAGAR do dia '+DTOC(dData)+';Nao Encontrado')
			end

			//----------------------------------------------------------CONTABILZADO
			//----------------------------------------------------------CONTABILZADO
			pb_msg('Atualizando arquivo lancamentos contabeis....',1)
			if file (cArqCT)
//				cDest  :=strtran(diskName()+':'+DirName()+'\CTBADI'+pb_zer(Day(dData),2)+'.'+substr(Dtos(dData),4,3),'\\','\')

				cDest  :=strtran(diskName()+ ":" +chr(92)+ CurDir()+"\CTBADI"+pb_zer(Day(dData),2)+'.'+substr(Dtos(dData),4,3),'\\','\')
				Alert('Arquivo Destino CTB;'+cDest,,'N/BG,W+/B')
				nErrDir:=FileCopy(cArqCT,cDest)
				if nErrDir == 0
					alert('Erro ao copiar arquivo contabil...'+cArqCT+';Para '+cDest)
				end
			else
				Alert('Arquivo de Lancamentos Contabeis dia '+DTOC(dData)+';Arquivo Nao Encontrado '+cArqCT+' Nao encontrado.')
			end
			FileDelete (cArqDR) // Eliminar arquivo descompactado
			FileDelete (cArqDP) // Eliminar arquivo descompactado
			FileDelete (cArqCT) // Eliminar arquivo descompactado
		else
			Alert('Arquivo '+cArqZip+' nao encontrado.')
		end
				
	end
end
DbCloseAll()
return NIL
*-------------------------------------------EOF---------------------------*