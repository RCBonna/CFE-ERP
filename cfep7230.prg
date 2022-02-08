*-----------------------------------------------------------------------------*
function CFEP7230()	//	Parametros Cupon Fiscal											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
local Y
local ALIQ:=array(10,3)
pb_lin4('Altera dados basicos',ProcName())

if !abre({'E->ALIQUOTAS','E->PARAMETRO'})
	return NIL
end
select ALIQUOTAS
DbGoTop()
X:=1
if lastrec()=0
	ALIQ[1,1]:='II'
	ALIQ[1,2]:=padr('Isento',15)
	ALIQ[1,3]:=0

	ALIQ[2,1]:='NN'
	ALIQ[2,2]:=padr('Nao Tributado',15)
	ALIQ[2,3]:=0

	ALIQ[2,1]:='FF'
	ALIQ[2,2]:=padr('Nao Tributado',15)
	ALIQ[2,3]:=0
	X:=4
end
while !eof()
	ALIQ[X,1]:=AF_CODIGO
	ALIQ[X,2]:=AF_DESCR
	ALIQ[X,3]:=AF_ALIQUO
	X++
	skip
end

while X<10
	ALIQ[X,1]:='  '
	ALIQ[X,2]:=space(15)
	ALIQ[X,3]:=0
	X++
end
select PARAMETRO
for X:=1 to fcount()
	Y :="VM"+substr(fieldname(X),3)
	&Y:=&(fieldname(X))
end
VM_EDQCUP :=if(PA_EDQCUP, 'S','N')
VM_EDVCUP :=if(PA_EDVCUP, 'S','N')
VM_EMCUFI :=if(PA_EMCUFI, 'S','N')
VM_EFINCUP:=if(PA_EFINCUP,'S','N')
VM_EDESCUP:=if(PA_EDESCUP,'S','N')
VM_CONVEN :=if(PA_CONVEN,'S','N')
VM_OBS1   :=left (PA_OBSCUP,40)
VM_OBS2   :=right(PA_OBSCUP,40)
pb_box(,,21,79,,'Altera dados B sicos-Cupon Fiscal')
@06,01 say 'Empresa..........: '+VM_EMPR
@08,01 say 'Impr Fiscal......:' get VM_EMCUFI  pict mUUU		valid VM_EMCUFI$'SN'		when pb_msg('Emite Cupom em Impressora Fiscal').and..F.
@09,01 say 'Tipo Impressora..:' get VM_TIPOCUP pict mI2		valid VM_TIPOCUP==1.or.VM_TIPOCUP==50 when pb_msg('1-Bematch (v3.0)               50-Schalter(v3.1)')
@10,01 say 'Tem Convenio ?...:' get VM_CONVEN  pict mUUU		valid VM_CONVEN$'SN'		when pb_msg('Empresa possui Clientes com Convenios para Funcionarios')
@11,01 say 'Pular Nr Linhas..:' get VM_NRLCUP  pict mI2		valid VM_NRLCUP>=0		when pb_msg('')
@12,01 say 'Editar Qtdade....:' get VM_EDQCUP  pict mUUU		valid VM_EDVCUP$'SN'		when pb_msg('')
@13,01 say 'Editar Valor.....:' get VM_EDVCUP  pict mUUU		valid VM_EDVCUP$'SN'		when pb_msg('')
@14,01 say 'Tipo Fechamento..:' get VM_CFTIPOF pict mI1		valid VM_CFTIPOF<3		when pb_msg('<0> Normal      <1> com Parcelamento(1)        <2> Condicao Pgto')
@15,01 say 'Dig.Vlr Financiam:' get VM_EFINCUP pict mUUU		valid VM_EFINCUP$'SN'	when pb_msg('Entrar com Vlr de Financiamento na Venda')
@16,01 say 'Dig.Vlr Desconto.:' get VM_EDESCUP pict mUUU		valid VM_EDESCUP$'SN'	when pb_msg('Entrar com Vlr de Desconto na Venda')
@17,01 say 'Arred Parcelas...:' get VM_PARCINT pict mI1		valid VM_PARCINT>=0.and.VM_PARCINT<4   when pb_msg('Arredondamento 1...4 casas decimais')
@18,01 say 'OBS-1............:' get VM_OBS1    pict mXXX										when pb_msg('')
@19,01 say 'OBS-2............:' get VM_OBS2    pict mXXX										when pb_msg('')
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	VM_EDQCUP :=(VM_EDVCUP =='S')
	VM_EDVCUP :=(VM_EDVCUP =='S')
	VM_EMCUFI :=(VM_EMCUFI =='S')
	VM_EFINCUP:=(VM_EFINCUP=='S')
	VM_EDESCUP:=(VM_EDESCUP=='S')
	VM_CONVEN :=(VM_CONVEN =='S')
	VM_OBSCUP :=VM_OBS1+VM_OBS2
	for X:=1 to fcount()
		Y:="VM"+substr(fieldname(X),3)
		replace &(fieldname(X)) with &Y
	end
	
	if pb_sn('Alterar aliquotas Impressora Fiscal?')
		select ALIQUOTAS
		@7,40 say 'Cod   Descricao           %'
		for X:=1 to 10
			@X+7,41 get ALIQ[X,1] pict mUUU
			@X+7,49 get ALIQ[X,2] pict mUUU
			@X+7,70 get ALIQ[X,3] pict mI62
		next
		read
		if pb_sn('Gravar Aliquotas?')
			while !eof()
				delete
				skip
			end
			for X:=1 to len(ALIQ)
				if !empty(ALIQ[X,1])
					if !dbseek(ALIQ[X,1])
						AddRec()
						replace AF_CODIGO with ALIQ[X,1]
					end
					replace 	AF_DESCR with ALIQ[X,2],;
								AF_ALIQUO with ALIQ[X,3]
				end
			next
		end
	end
end
dbcloseall()
return NIL
//------------------------------------EOF----------------------------------------------