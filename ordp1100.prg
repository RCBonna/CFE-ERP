*-----------------------------------------------------------------------------*
function ORDP1100()	// Parametro															*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X,X1
pb_lin4(_MSG_,ProcName())
if !abre({	'E->PARAMETRO',;
				'E->PARAMORD'})
	return NIL
end

DbGoTop()
for X:=1 to fcount()
	X1='VM'+substr(fieldname(X),3)
	&X1=fieldget(X)
end
VM_INTFAT:=if(VM_INTFAT,'S','N')
X        :=MaxRow()-12

pb_box(X++,40,,,,'Informe')
@X++,42 say 'Data Movto.: '+dtoc(PARAMETRO->PA_DATA)
@X++,42 say 'Vlr US$....:'+transform(PARAMETRO->PA_VALOR,masc(2))
@X++,42 say 'Seq Or‡amen:' get VM_ORCAM  picture MASC(4) valid VM_ORCAM>0
@X++,42 say 'Seq Ordem..:' get VM_SEQ    picture MASC(4) valid VM_SEQ>0
@X++,42 say 'Tipo(E/C/P):' get VM_TIPO   picture MASC(1) valid VM_TIPO$'ECP' when pb_msg('Tipos OS - <E>letrodomesticos   <C>arros     <P>roducao')
@X++,42 say 'Base Horas.:' get VM_DESCR1 picture MASC(1) when pb_msg('Nome do agente usado para ser base de horas (Mecanico, Maquina, Tecnico')
@X++,42 say 'Objeto.....:' get VM_DESCR2 picture MASC(1) when pb_msg('Objeto que trabalha-se ( Veiculo, Eletrodomestico, PECA, Desenho,... ')
@X++,42 say 'Ordem de...:' get VM_DESCR3 picture MASC(1)
@X++,42 say 'Integra Faturamento?' Get  VM_INTFAT pict mUUU valid VM_INTFAT$'SN' when pb_msg('Integracao do sistema de OS com Faturamento?')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	VM_INTFAT:=(VM_INTFAT=='S')
	for X:=1 to fcount()
		X1:='VM'+substr(fieldname(X),3)
		fieldput(X,&X1)
	end
	// dbcommitall()
end
dbcloseall()
return NIL
*---------------------------------------EOF------------------------
