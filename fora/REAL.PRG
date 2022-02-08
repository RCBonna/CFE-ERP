function REAL()
pb_msg('Convertendo DPL A PAGAR',NIL,.F.)

ABRE('FO')
ABRE('DP');set relation to str(DP_CODFO,5) into CLIENTE
replace all DP_VLRDP with DP_VLRDP,DP_VLRPG with DP_VLRPG for DP_MOEDA=0 // CRUZEIRO
replace all DP_MOEDA with 1 // REAL
close
select('FORNEC')
close

pb_msg('Convertendo DPL A RECEBER',NIL,.F.)
ABRE('CL')
ABRE('DR');set relation to str(DR_CODCL,5) into CLIENTE
replace all DR_VLRDP with DR_VLRDP,DR_VLRPG with DR_VLRPG for DR_MOEDA=0 // CRUZEIRO
replace all DR_MOEDA with 1 // REAL
close
select('CLIENTE')
close

pb_msg('Convertendo ESTOQUE',NIL,.F.)
ABRE('PR')
replace all PR_VLATU with PR_VLATU,PR_VLVEN with PR_VLVEN,;
				PR_SLDVL with PR_SLDVL // CRUZEIRO

replace all PR_VLATU with PR_QTATU/100 for PR_QTATU>PR_VLATU*100
close

VM_URV = 1
return NIL
