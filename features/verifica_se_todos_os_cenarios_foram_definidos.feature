Funcionalidade: Verificar se todos os cenários da feature foram definidos
  Como desenvolvedor
  Gostaria que o dCucumber me informasse caso deixe de definir algum cenário
  Para que todos os cenários sejam cobertos por testes
  
  Cenário: Comparando a feature com a classe de teste
    Dado que tenho a feature "cenario_simples.feature"
	E que não implementei o cenário "primeiros passos"
	Quando eu tentar executar meus testes
	Então devo ver a mensagem de erro "O cenário 'primeiros passos' não foi definido"