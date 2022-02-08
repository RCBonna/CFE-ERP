*-----------------------------------------------------------------------------*
 function CXAPINTC()	//	Integracao com o Caixa(CP/CR/FAT/TRANSF
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local Hist:=''
if !abre({	'R->PARAMETRO',;
				'C->CAIXAMC',;
				'C->CAIXAMB',;
				'C->PEDCAB',;
				'C->PEDDET',;
				'C->COTAMV',;
				'E->CAIXAPA',;
				'C->HISFOR',;
				'R->CLIENTE',;
				'C->HISCLI'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if !Cxa_Cont() // Liberado para usar Caixa
	dbcloseall()
	return NIL
end
DATA   :={CAIXAPA->PA_DTINTC+1,eom(CAIXAPA->PA_DTINTC+1)}
DATA[1]:=if(empty(DATA[1]),boy(date()),       DATA[1])
DATA[2]:=if(empty(DATA[2]),addmonth(date())-1,DATA[2])

pb_box(17,18,,,,'Selecione Periodo')
@19,20 say 'Data Inicial:' get DATA[1] pict masc(7) valid DATA[1]>CAIXAPA->PA_DTFECC
@20,20 say 'Data Final..:' get DATA[2] pict masc(7) valid DATA[2]>=DATA[1]
read
if if(lastkey()#K_ESC,pb_sn('Processar Integracao Caixa ?'),.F.)
	*---------------------------------------------------------------------------Pagamentos
	pb_msg('Processando Pagamentos...')
	*---------------------------------------------------------------------------Pagamentos
	select('HISFOR')
	ordem DTPGTO
	dbseek(dtos(DATA[1]),.T.)
	while !eof().and.HF_DTPGT<=DATA[2]
		CLIENTE->(dbseek(str(HISFOR->HF_CODFO,5)))
		if !HF_FLCXA
			if reclock()
				CLIENTE->(dbseek(str(HISFOR->HF_CODFO,5)))
				Grav_Cxa(HF_CXACG,;
							HF_DTPGT,;
							(HF_VLRPG+HF_VLRJU-HF_VLRDE-HF_VLRET+HF_VLBON),;
							CLIENTE->CL_RAZAO,;
							HF_DUPLI,;
							'CP')
				replace HF_FLCXA with .T.
				dbrunlock(recno())
			end
		end
		if !HF_FLBCO
			if reclock()
				Grav_Bco(HF_CDCXA,;
							HF_DTPGT,;
							HF_DUPLI,;
							'Pago Doc.'+alltrim(str(HF_DUPLI))+' a '+CLIENTE->CL_RAZAO,;
							-(HF_VLRPG+HF_VLRJU-HF_VLRDE-HF_VLRET+HF_VLBON),;
							'EN')
				replace HF_FLBCO with .T.
				dbrunlock(recno())
			end
		end
		dbskip()
	end

//--------------------------------------------------------------------------Recebimentos
	pb_msg('Processando Recebimentos...')
//--------------------------------------------------------------------------Recebimentos
	select('HISCLI')
	ORDEM DTPGTO
	dbseek(dtos(DATA[1]),.T.)
	while !eof().and.HC_DTPGT<=DATA[2]
		if !HC_FLCXA
			if reclock()
				CLIENTE->(dbseek(str(HISCLI->HC_CODCL,5)))
				Grav_Cxa(HC_CXACG,;
							HC_DTPGT,;
							HC_VLRPG+HC_VLRJU-HC_VLRDE-HC_VLRET+HC_VLBON,;
							CLIENTE->CL_RAZAO,;
							HC_DUPLI,;
							'CR')
				replace HC_FLCXA with .T.
				dbrunlock(recno())
			end
		end
		if !HC_FLBCO
			if reclock()
				CLIENTE->(dbseek(str(HISCLI->HC_CODCL,5)))
				Grav_Bco(HC_CDCXA,;
							HC_DTPGT,;
							HC_DUPLI,;
							'Receb Doc.'+alltrim(str(HC_DUPLI,9))+' de '+CLIENTE->CL_RAZAO,;
							HC_VLRPG+HC_VLRJU-HC_VLRDE-HC_VLRET+HC_VLBON,;
							'FT')
				replace HC_FLBCO with .T.
				dbrunlock(recno())
			end
		end
		pb_brake()
	end

*--------------------------------------------------------------------------cota-parte
	pb_msg('Processando Cota-Parte')
*--------------------------------------------------------------------------cota-parte
	select COTAMV
	ORDEM DTASS
	pb_msg('Processando Cota-Parte')
	dbseek(dtos(DATA[1]),.T.)
	while !eof().and.COTAMV->MV_DATA<=DATA[2]
		if !COTAMV->MV_FLCXA
			if reclock()
				CLIENTE->(dbseek(str(COTAMV->MV_CODCL,5)))
				Hist:=iif(COTAMV->MV_TPMOV=='R','Receb Doc.','Pago Doc.')

				Grav_Cxa( COTAMV->MV_CODCX,;
							 COTAMV->MV_DATA,;
							 COTAMV->MV_VALOR,;
							 CLIENTE->CL_RAZAO,;
							 COTAMV->MV_NRDOC,;
							if(COTAMV->MV_TPMOV=='R','CR','CP')) // Contas a Pagar ou Contas Receber

				Grav_Bco(COTAMV->MV_CODBC,;
							COTAMV->MV_DATA,;
							COTAMV->MV_NRDOC,;
							Hist+alltrim(str(COTAMV->MV_NRDOC,9))+' '+CLIENTE->CL_RAZAO,;
							COTAMV->MV_VALOR*if(COTAMV->MV_TPMOV=='R',+1,-1),;
							'CP')

				replace COTAMV->MV_FLCXA with .T.
				DbrunLock(recno())
			end
		end
		DbSkip()
	end

*--------------------------------------------------------------------*
*	pb_msg('Processando Faturamento')
*--------------------------------------------------------------------*
*	select('PEDCAB')
*	ordem DTEPED
*	dbseek(dtos(DATA[1]),.T.)
*	while !eof().and.PC_DTEMI<=DATA[2]
*		if PC_FLAG.and.!PC_FLCAN.and.!PC_FLCXA.and.PC_CODCG>0
*			if reclock()
*				CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
*				Grav_Cxa(PC_CODCG,;
*							PC_DTEMI,;
*							PC_TOTAL,;
*							CLIENTE->CL_RAZAO,;
*							PC_NRNF,'FT')
*				replace PC_FLCXA with .T.
*				dbrunlock(recno())
*			end
*		end
*		dbskip()
*	end
*---------------------------------------------------------------------*
	select('CAIXAPA')
	replace PA_DTINTC with DATA[2]
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function GRAV_CXA(CODCG,DT,VLR,NOME,DOCTO,ORIG,CDCXA)
*-----------------------------------------------------------------------------*
if CDCXA==NIL
	CDCXA:=NUM_CXA
end
if str(VLR,15,2)#str(0,15,2)
	salvabd(SALVA)
	select CAIXAMC
	while !AddRec();end
	replace 	MC_DATA   with DT
	replace	MC_CODCG  with CODCG
	replace	MC_HISTO  with if(ORIG=='CP','Pago','Receb')+' Doc.'+ltrim(str(DOCTO))+' '+;
 									if(ORIG=='CP','a','de')+' '+;
 									trim(NOME)
	replace 	MC_VALOR  with abs(VLR)
	replace 	MC_TIPO   with if(ORIG=='CP',"-","+")
	replace 	MC_CODCXA with CDCXA
	replace 	MC_ORIG   with ORIG
	replace 	MC_NRODOC with DOCTO
	salvabd(RESTAURA)
end
return NIL

*-----------------------------------------------------------------------------*
 function GravMvCxa(CODCG,DT,VLR,HIST,DOCTO,ORIG,CDCXA)
*-----------------------------------------------------------------------------*
if CDCXA==NIL
	CDCXA:=NUM_CXA
end
if str(VLR,15,2)#str(0,15,2)
	salvabd(SALVA)
	select ('CAIXAMC')
	while !AddRec();end
	replace 	MC_DATA   with DT,;
				MC_CODCG  with CODCG,;
				MC_HISTO  with HIST,;
				MC_VALOR  with abs(VLR),;
				MC_TIPO   with if(VLR>0,'+','-'),;
				MC_CODCXA with CDCXA,;
				MC_ORIG   with ORIG,;
				MC_NRODOC with DOCTO
	salvabd(RESTAURA)
end
return NIL

*-----------------------------------------------------------------------------*
 function GRAV_BCO(CODBC,DT,DOC,HIST,VLR,ORIG)
*-----------------------------------------------------------------------------*
if str(VLR,15,2)#str(0,15,2).and.CODBC > 0
	salvabd(SALVA)
	select('CAIXAMB')
	if AddRec(30)
		replace 	MB_CODBC  with CODBC,;
					MB_DATA   with DT,;
					MB_DOCTO  with DOC,;
					MB_HISTO  with HIST,;
					MB_VALOR  with abs(VLR),;
					MB_TIPO   with if(VLR>0,"+","-"),;
					MB_ORIG   with ORIG,;
					MB_FLCXA  with if(ORIG=='CP',.T.,.F.)
	end
	salvabd(RESTAURA)
end
return NIL
*------------------------------------------eof---------------------------------*
