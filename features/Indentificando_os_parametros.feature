Funcionalidade: Identificar os parâmetros dos steps
  Como Desenvolvedor
  Gostaria que o dCucumber encontrasse os parâmetros dos meus steps de teste
  Para que eu posso configurar e testar corretamente meus cenários.
  
  Cenário: Um step com apenas um parâmetro string
    Dado que tenho um parâmetro "teste" em meu step
	Quando eu carregar a feature
	Devo ver um parâmetro como o nome teste ligado ao cenário "Um step com apenas um parâmetro string"

  Cenário: Um step com vários parâmetros string
    Dado que tenho os parâmetros "Olá" "Mundo!"
	Quando eu carregar a feature
	Devo ver dois parâmtros ligados ao cenário "Um step com vários parâmetros string"

  Cenário: Um step com parâmetros inteiros
   Dado que eu tenho os parâmetros 1, 2, 3
   Quando eu carregar a feature
   Devo ver no mínimo 3 parâmetros ligados ao cenário "Um step com parâmetros inteiros"