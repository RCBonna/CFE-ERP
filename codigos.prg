*-----------------------------------------------------------------------------*
 function CODIGOS()
*-----------------------------------------------------------------------------*
local CPO:={},X,Y

scroll(0,0,24,79,0)

@10,10 say 'Criando arquivo de CODIGOS.ARR-Saida '+time()

aadd(CPO,{'CODPR',      'pb_zer(PROD->PR_CODPR,len(masc(21)))'})
aadd(CPO,{'CODGRUPO',   'transform(PROD->PR_CODGR,masc(13))'  })
aadd(CPO,{'NOMEPRODUTO','PROD->PR_DESCR'                      })
aadd(CPO,{'COMPLEMENTO','PROD->PR_COMPL'                      })
aadd(CPO,{'LOCAL',      'PROD->PR_LOCAL'                      })
aadd(CPO,{'UNID',       'PROD->PR_UND'                        })
aadd(CPO,{'VLRVENDA',   'transform(PROD->PR_VLVEN,masc(2))'   })
aadd(CPO,{'VLRVPRAZO',  'transform(PROD->PR_VLVEN*(1+(PARAMETRO->PA_DESCV/100)),masc(2))'})
aadd(CPO,{'ESTMINIMO',  'transform(PROD->PR_ETMIN,masc(6))'               })
aadd(CPO,{'NOMEGRUPO',  'GRUPOS->GE_DESCR'                                })
aadd(CPO,{'BCONOME',    'if(PEDCAB->PC_FATUR>0,BANCO->BC_DESCR,space(30))'})
aadd(CPO,{'BCOAGEN',    'if(PEDCAB->PC_FATUR>0,BANCO->BC_AGENC,space(10))'})
aadd(CPO,{'BCOENDE',    'if(PEDCAB->PC_FATUR>0,BANCO->BC_ENDER,space(45))'})
aadd(CPO,{'BCOCIDA',    'if(PEDCAB->PC_FATUR>0,BANCO->BC_CIDAD,space(45))'})
aadd(CPO,{'BCOUF',      'if(PEDCAB->PC_FATUR>0,BANCO->BC_UF,   space(02))'})

aadd(CPO,{'CLICOD',     'pb_zer(CLIENTE->CL_CODCL,5)'})
aadd(CPO,{'CLINOME',    'CLIENTE->CL_RAZAO'})
aadd(CPO,{'CLIENDE',    'CLIENTE->CL_ENDER'})
aadd(CPO,{'CLIBAIR',    'CLIENTE->CL_BAIRRO'})
aadd(CPO,{'CLICIDA',    'CLIENTE->CL_CIDAD'})
aadd(CPO,{'CLICEP',     'transform(CLIENTE->CL_CEP,masc(10))'})
aadd(CPO,{'CLIUF',      'CLIENTE->CL_UF'})
aadd(CPO,{'CLICGC',     'padr(transform(CLIENTE->CL_CGC,masc(if(len(trim(CLIENTE->CL_CGC))>12,18,17))),18)'})
aadd(CPO,{'CLINSC',     'CLIENTE->CL_INSCR'})
aadd(CPO,{'CLIFONE',    'CLIENTE->CL_FONE'})
aadd(CPO,{'CLIOBS',     'CLIENTE->CL_OBS'})
aadd(CPO,{'CLIREF',     'CLIENTE->CL_REFER'})

//---------------------------------------Avalista--------------------------------
aadd(CPO,{'AVACOD',     'if(VM_AVAL[1]>0,pb_zer(VM_AVAL[1],5),space(5))'})
aadd(CPO,{'AVANOME',    'VM_AVAL[2]'})
aadd(CPO,{'AVACGC',     'VM_AVAL[4]'})
aadd(CPO,{'AVAENDE',    'VM_AVAL[3]'})
//------------------------------------Datas--------------------------------------
aadd(CPO,{'DPLEMI',     'transform(DPCLI->DR_DTEMI,masc(07))'})
aadd(CPO,{'DPLVEN',     'transform(DPCLI->DR_DTVEN,masc(07))'})
aadd(CPO,{'DPLVLR',     'transform(DPCLI->DR_VLRDP,masc(02))'})
aadd(CPO,{'DPLCOD',     'transform(DPCLI->DR_DUPLI,masc(16))'})

for X:=1 to 20
	Y:=pb_zer(X,2)
	aadd(CPO,{'XOBS'+Y, 'DevXObs('+Y+')'})
next

aadd(CPO,{'OBS1',       'left(VM_OBS,33)'})
aadd(CPO,{'OBS2',       'substr(VM_OBS,34,33)'})
aadd(CPO,{'OBS3',       'substr(VM_OBS,67,33)'})
aadd(CPO,{'OBS4',       'right(VM_OBS,33)'})

aadd(CPO,{'OBS_DES',    'OBS1[1]'})
aadd(CPO,{'OBS_COM',    'OBS1[2]'})

aadd(CPO,{'X_ENT',      'XENT'})
aadd(CPO,{'X_SAI',      'XSAI'})

aadd(CPO,{'VLREXT1',     'left(VM_EXT,50)'     })
aadd(CPO,{'VLREXT2',     'substr(VM_EXT,51,50)'})
aadd(CPO,{'VLREXT3',     'right(VM_EXT,50)'    })

for X:=1 to 20
	Y :=pb_zer(X,2)
	aadd(CPO,{'UNI'+Y,  'if(VM_DET['+Y+',2]>0,          VM_DET['+Y+',10],          space(05))'})
	aadd(CPO,{'UNX'+Y,  'if(VM_DET['+Y+',2]>0,     left(VM_DET['+Y+',10],3),       space(03))'})
	aadd(CPO,{'QTD'+Y,  'if(VM_DET['+Y+',2]>0,transform(VM_DET['+Y+',04],masc(6)), space(09))'})
	aadd(CPO,{'PRD'+Y,  'if(VM_DET['+Y+',2]>0,   pb_zer(VM_DET['+Y+',02],7),       space(07))'})
	aadd(CPO,{'DES'+Y,  'if(VM_DET['+Y+',2]>0,          VM_DET['+Y+',03],          space(40))'})
	aadd(CPO,{'CDT'+Y,  'if(VM_DET['+Y+',2]>0,          VM_DET['+Y+',08],          space(03))'})
	aadd(CPO,{'VLD'+Y,  'if(VM_DET['+Y+',2]>0,transform(VM_DET['+Y+',06],masc(32)),space(10))'})
	aadd(CPO,{'VLA'+Y,  'if(VM_DET['+Y+',2]>0,transform(VM_DET['+Y+',07],masc(02)),space(15))'})
	aadd(CPO,{'VLU'+Y,  'if(VM_DET['+Y+',2]>0,transform(VM_DET['+Y+',05],masc(45)),space(12))'})
	aadd(CPO,{'VLT'+Y,  'if(VM_DET['+Y+',2]>0,transform(trunca(VM_DET['+Y+',4]*VM_DET['+Y+',5],2)-VM_DET['+Y+',6]+VM_DET['+Y+',7],masc(25)),space(12))'})
	aadd(CPO,{'ALI'+Y,  'if(VM_DET['+Y+',2]>0,transform(VM_DET['+Y+',09],masc(12)),space(03))'})
	aadd(CPO,{'NOP'+Y,  'if(VM_DET['+Y+',2]>0, left(str(VM_DET['+Y+',17],5),3),    space(03))'})
	aadd(CPO,{'CFIPI'+Y,'if(VM_DET['+Y+',2]>0,          VM_DET['+Y+',20]      ,    space(10))'})
next

for X:=1 to 24
	Y :=pb_zer(X,2)
	aadd(CPO,{'DUPN'+Y,	'if(len(VM_FAT)>='+Y+',transform(VM_FAT['+Y+',1],masc(16)),space(10))'})
	aadd(CPO,{'DUPV'+Y,	'if(len(VM_FAT)>='+Y+',transform(VM_FAT['+Y+',3],masc(02)),space(15))'})
	aadd(CPO,{'DUPD'+Y,	'if(len(VM_FAT)>='+Y+',transform(VM_FAT['+Y+',2],masc(07)),space(08))'})
next

//for X=1 to 9
//	Y=pb_zer(X,1)
//	aadd(CPO,{'ICMB'+Y, 'if(len(VM_ICMS)>='+Y+',transform(VM_ICMS['+Y+',2],                                 masc(02)),space(15))'})
//	aadd(CPO,{'ICMP'+Y, 'if(len(VM_ICMS)>='+Y+',transform(VM_ICMS['+Y+',1],                                 masc(14)),space(05))'})
//	aadd(CPO,{'ICMV'+Y, 'if(len(VM_ICMS)>='+Y+',transform(round(VM_ICMS['+Y+',2]*VM_ICMS['+Y+',1]/100.00,2),masc(02)),space(15))'})
//next

aadd(CPO,{'ICMBT',      'transform(VM_ICMT[2],masc(02))'})
aadd(CPO,{'ICMVT',      'transform(VM_ICMT[1],masc(02))'})

aadd(CPO,{'TNFSFU',     'transform(PEDCAB->PC_TOTAL-PEDCAB->PC_DESC,masc(2))'})
aadd(CPO,{'FUNRURAL',   'transform(0,masc(2))'})
aadd(CPO,{'PERFUN',     'space(3)'})

aadd(CPO,{'LOTE',       'if(PEDCAB->PC_LOTE>0,"Lote:"+str(PEDCAB->PC_LOTE,4),space(9))'})

aadd(CPO,{'DUPLI',      'if(len(VM_FAT)>0,transform(VM_ULTDP,masc(16)),space(9))'})
aadd(CPO,{'DESTX',      'if(PEDCAB->PC_DESC>0,"Desconto",space(8))'})
aadd(CPO,{'DESGR',      'if(PEDCAB->PC_DESC>0,transform(PEDCAB->PC_DESC,masc(2)),space(15))'})
aadd(CPO,{'VLRENT',     'if(PEDCAB->PC_VLRENT>0,transform(PEDCAB->PC_VLRENT,masc(2)),space(15))'})
aadd(CPO,{'TOTNF',      'transform(PEDCAB->PC_TOTAL-PEDCAB->PC_DESC,masc(2))'})
aadd(CPO,{'ENCFI',      'transform(PEDCAB->PC_ENCFI,                masc(2))'})
aadd(CPO,{'OBSNF',      'PEDCAB->PC_OBSER'})
aadd(CPO,{'DESCSVC',    'PEDCAB->PC_DESVC'})
aadd(CPO,{'DTEMS',      'transform(PEDCAB->PC_DTEMI,masc(07))'})
aadd(CPO,{'NRNF',       'pb_zer(VM_ULTNF,6)'})
aadd(CPO,{'NR_NSU',     'pb_zer(VM_NSU,10)'})
aadd(CPO,{'NRPED',      'pb_zer(PEDCAB->PC_PEDID,6)'})
aadd(CPO,{'VENCOD',     'pb_zer(PEDCAB->PC_VEND,3)'})
aadd(CPO,{'VENNOM',     'left(VENDEDOR->VE_NOME,15)'})
aadd(CPO,{'CODOP',      'left(str(PEDCAB->PC_CODOP,8),6)'})
aadd(CPO,{'DESNOP',     'NATOP->NO_DESCR'})
aadd(CPO,{'#C',         'impr(07)'})
aadd(CPO,{'#N',         'impr(10)+impr(08)'})
aadd(CPO,{'#S',         'impr(09)'})
aadd(CPO,{'#16',        'impr(15)'})
aadd(CPO,{'#18',        'impr(16)'})
aadd(CPO,{'I_HR',       'left(time(),5)'})

aadd(CPO,{'TRNOME',    'I_TRANS[1]'})
aadd(CPO,{'TRENDE',    'I_TRANS[2]'})
aadd(CPO,{'TRMUNI',    'I_TRANS[3]'})
aadd(CPO,{'TRUFTR',    'I_TRANS[4]'})
aadd(CPO,{'TRTIPO',    'str(I_TRANS[5],1)'})
aadd(CPO,{'TRPLACA',   'I_TRANS[6]'})
aadd(CPO,{'TRUFVE',    'I_TRANS[7]'})
aadd(CPO,{'TRCGC',     'I_TRANS[8]'})
aadd(CPO,{'TRINSC',    'I_TRANS[9]'})
aadd(CPO,{'TRQTDE',    'transform(I_TRANS[10],masc(6))'})
aadd(CPO,{'TRESPE',    'I_TRANS[11]'})
aadd(CPO,{'TRMARC',    'I_TRANS[12]'})
aadd(CPO,{'TRPBRU',    'transform(I_TRANS[13],masc(6))'})
aadd(CPO,{'TRPLIQ',    'transform(I_TRANS[14],masc(6))'})

@11,10 say 'Ordenado arquivo de CODIGOS.ARR '+time()
CPO:=asort(CPO,,,{|X,Y|X[1]<Y[1]})

@12,10 say 'Gravando arquivo de CODIGOS.ARR '+time()
savearray(CPO,'CODIGOS.ARR')

******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************

CPO:={}

@14,10 say 'Criando arquivo de CODIGOE.ARR '+time()

aadd(CPO,{'CODPR',      'pb_zer(PROD->PR_CODPR,len(masc(21)))'})
aadd(CPO,{'CODGRUPO',   'transform(PROD->PR_CODGR,masc(13))'})
aadd(CPO,{'NOMEPRODUTO','PROD->PR_DESCR'})
aadd(CPO,{'COMPLEMENTO','PROD->PR_COMPL'})
aadd(CPO,{'LOCAL',      'PROD->PR_LOCAL'})
aadd(CPO,{'UNID',       'PROD->PR_UND'})
aadd(CPO,{'VLRVENDA',   'transform(PROD->PR_VLVEN,masc(2))'})
aadd(CPO,{'ESTMINIMO',  'transform(PROD->PR_ETMIN,masc(6))'})
aadd(CPO,{'NOMEGRUPO',  'GRUPOS->GE_DESCR'})
aadd(CPO,{'BCONOME',    'if(ENTCAB->EC_FATUR>0,BANCO->BC_DESCR,space(30))'})
aadd(CPO,{'BCOAGEN',    'if(ENTCAB->EC_FATUR>0,BANCO->BC_AGENC,space(10))'})
aadd(CPO,{'BCOENDE',    'if(ENTCAB->EC_FATUR>0,BANCO->BC_ENDER,space(45))'})
aadd(CPO,{'BCOCIDA',    'if(ENTCAB->EC_FATUR>0,BANCO->BC_CIDAD,space(45))'})
aadd(CPO,{'BCOUF',      'if(ENTCAB->EC_FATUR>0,BANCO->BC_UF,space(2))'})

aadd(CPO,{'CLICOD',     'pb_zer(CLIENTE->CL_CODCL,5)'})
aadd(CPO,{'CLINOME',    'CLIENTE->CL_RAZAO'})
aadd(CPO,{'CLIENDE',    'CLIENTE->CL_ENDER'})
aadd(CPO,{'CLIBAIR',    'CLIENTE->CL_BAIRRO'})
aadd(CPO,{'CLICIDA',    'CLIENTE->CL_CIDAD'})
aadd(CPO,{'CLICEP',     'transform(CLIENTE->CL_CEP,masc(10))'})
aadd(CPO,{'CLICGC',     'padr(transform(CLIENTE->CL_CGC,masc(if(len(trim(CLIENTE->CL_CGC))>12,18,17))),18)'})
aadd(CPO,{'CLINSC',     'CLIENTE->CL_INSCR'})
aadd(CPO,{'CLIUF',      'CLIENTE->CL_UF'})
aadd(CPO,{'CLIFONE',    'CLIENTE->CL_FONE'})
aadd(CPO,{'CLIOBS',     'space(50)'})
aadd(CPO,{'CLIREF',     'space(50)'})

aadd(CPO,{'DPLEMI',     'transform(DPFOR->DP_DTEMI,masc(07))'})
aadd(CPO,{'DPLVEN',     'transform(DPFOR->DP_DTVEN,masc(07))'})
aadd(CPO,{'DPLVLR',     'transform(DPFOR->DP_VLRDP,masc(02))'})
aadd(CPO,{'DPLCOD',     'transform(DPFOR->DP_DUPLI,masc(16))'})

aadd(CPO,{'OBS1',       'left(VM_OBS,33)'})
aadd(CPO,{'OBS2',       'substr(VM_OBS,34,33)'})
aadd(CPO,{'OBS3',       'substr(VM_OBS,67,33)'})
aadd(CPO,{'OBS4',       'right(VM_OBS,33)'})

for X:=1 to 20
	Y:=pb_zer(X,2)
	aadd(CPO,{'XOBS'+Y, 'DevXObs('+Y+')'})
next

aadd(CPO,{'X_ENT',      'XENT'})
aadd(CPO,{'X_SAI',      'XSAI'})

for X:=1 to 30
	 Y:=pb_zer(X,2)
	aadd(CPO,{'UNI'+Y,  'if(PRODUTOS['+Y+',2]>0,          PRODUTOS['+Y+',13],          space(05))'})
	aadd(CPO,{'QTD'+Y,  'if(PRODUTOS['+Y+',2]>0,transform(PRODUTOS['+Y+',04],masc(6)), space(09))'})
	aadd(CPO,{'PRD'+Y,  'if(PRODUTOS['+Y+',2]>0,   pb_zer(PRODUTOS['+Y+',02],7),       space(07))'})
	aadd(CPO,{'DES'+Y,  'if(PRODUTOS['+Y+',2]>0,          PRODUTOS['+Y+',03],          space(40))'})
	aadd(CPO,{'CDT'+Y,  'if(PRODUTOS['+Y+',2]>0,          PRODUTOS['+Y+',14],          space(03))'})
	aadd(CPO,{'VLD'+Y,  'if(PRODUTOS['+Y+',2]>0,transform(0                 ,masc(32)),space(10))'})
	aadd(CPO,{'VLA'+Y,  'if(PRODUTOS['+Y+',2]>0,transform(0                 ,masc(02)),space(15))'})
	aadd(CPO,{'VLT'+Y,  'if(PRODUTOS['+Y+',2]>0,transform( PRODUTOS['+Y+',05],masc(25)),space(12))'})
	aadd(CPO,{'VLU'+Y,  'if(PRODUTOS['+Y+',2]>0.and.!empty(PRODUTOS['+Y+',05]),transform(round(PRODUTOS['+Y+',5]/PRODUTOS['+Y+',4],3),masc(45)),space(12))'})
	aadd(CPO,{'ALI'+Y,  'if(PRODUTOS['+Y+',2]>0,transform(PRODUTOS['+Y+',09],masc(12)),space(03))'})
	aadd(CPO,{'NOP'+Y,  'if(PRODUTOS['+Y+',2]>0, left(str(PRODUTOS['+Y+',18],5),3),    space(03))'})
	aadd(CPO,{'CFIPI'+Y,'if(PRODUTOS['+Y+',2]>0,          PRODUTOS['+Y+',26]      ,    space(10))'})
next
for X:=1 to 9
	 Y:=pb_zer(X,2)
	aadd(CPO,{'DUPN'+Y,	'if(len(DADOPC)>='+Y+',transform(DADOPC['+Y+',1],masc(16)),space(10))'})
	aadd(CPO,{'DUPV'+Y,	'if(len(DADOPC)>='+Y+',transform(DADOPC['+Y+',3],masc(02)),space(15))'})
	aadd(CPO,{'DUPD'+Y,	'if(len(DADOPC)>='+Y+',transform(DADOPC['+Y+',2],masc(07)),space(08))'})
next

for X:=1 to 9
	Y:=pb_zer(X,1)
	aadd(CPO,{'ICMB'+Y, 'space(15)'})
	aadd(CPO,{'ICMP'+Y, 'space(05)'})
	aadd(CPO,{'ICMV'+Y, 'space(15)'})
next

aadd(CPO,{'ICMBT',      'transform(DADOC[17],masc(02))'})
aadd(CPO,{'ICMVT',      'transform(DADOC[07],masc(02))'})

aadd(CPO,{'DESCSVC',    'space(80)'})
aadd(CPO,{'DUPLI',      'if(len(VM_FAT)>0,transform(VM_ULTDP,masc(16)),space(9))'})
aadd(CPO,{'DESTX',      'if(DADOC[8]>0,"Desconto",space(8))'})
aadd(CPO,{'DESGR',      'if(DADOC[8]>0,transform(DADOC[8],masc(2)),space(15))'})
aadd(CPO,{'TOTNF',      'transform(DADOC[4]-DADOC[8],masc(2))'})
aadd(CPO,{'ENCFI',      'space(15)'})

aadd(CPO,{'LOTE',       'space(9)'})

aadd(CPO,{'TNFSFU',     'transform(DADOC[4]-DADOC[8]-DADOC[6],masc(2))'})
aadd(CPO,{'FUNRURAL',   'transform(DADOC[6],masc(2))'})
aadd(CPO,{'PERFUN',     'if(DADOC[6]>0,transform(PARAMETRO->PA_FUNRUR,masc(14)),"     ")'})
aadd(CPO,{'OBSNF',      'PEDCAB->PC_OBSER'})
aadd(CPO,{'DTEMS',      'transform(DADOC[1],masc(07))'})
aadd(CPO,{'NRNF',       'pb_zer(DADOC[2],6)'})
aadd(CPO,{'NR_NSU',     'pb_zer(VM_NSU,10)'})
aadd(CPO,{'NRPED',      'pb_zer(DADOC[2],6)'})
aadd(CPO,{'VENCOD',     'pb_zer(0,3)'})
aadd(CPO,{'CODOP',      'left(str(DADOC[3],8),6)'})
aadd(CPO,{'DESNOP',     'NATOP->NO_DESCR'})
aadd(CPO,{'#C',         'impr(07)'})
aadd(CPO,{'#N',         'impr(10)+impr(08)'})
aadd(CPO,{'#S',         'impr(09)'})
aadd(CPO,{'#16',        'impr(15)'})
aadd(CPO,{'#18',        'impr(16)'})
aadd(CPO,{'AVACOD',     'space(05)'})
aadd(CPO,{'AVANOME',    'space(45)'})
aadd(CPO,{'AVACGC',     'space(18)'})
aadd(CPO,{'AVAENDE',    'space(45)'})

aadd(CPO,{'TRNOME',    'I_TRANS[1]'})
aadd(CPO,{'TRENDE',    'I_TRANS[2]'})
aadd(CPO,{'TRMUNI',    'I_TRANS[3]'})
aadd(CPO,{'TRUFTR',    'I_TRANS[4]'})
aadd(CPO,{'TRTIPO',    'str(I_TRANS[5],1)'})
aadd(CPO,{'TRPLACA',   'I_TRANS[6]'})
aadd(CPO,{'TRUFVE',    'I_TRANS[7]'})
aadd(CPO,{'TRCGC',     'I_TRANS[8]'})
aadd(CPO,{'TRINSC',    'I_TRANS[9]'})
aadd(CPO,{'TRQTDE',    'transform(I_TRANS[10],masc(6))'})
aadd(CPO,{'TRESPE',    'I_TRANS[11]'})
aadd(CPO,{'TRMARC',    'I_TRANS[12]'})
aadd(CPO,{'TRPBRU',    'transform(I_TRANS[13],masc(6))'})
aadd(CPO,{'TRPLIQ',    'transform(I_TRANS[14],masc(6))'})

@16,10 say 'Ordenado arquivo de CODIGOE.ARR '+time()
CPO:=asort(CPO,,,{|X,Y|X[1]<Y[1]})

@17,10 say 'Gravando arquivo de CODIGOE.ARR '+time()
savearray(CPO,'CODIGOE.ARR')

return NIL
