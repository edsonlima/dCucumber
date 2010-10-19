Funcionalidade: Validar uma feature inválida
  Como Desenvolvedor
  Gostaria que o dCucumber me avisase onde estão os erros da minha feature
  Para que eu possa corrigi-los
  
  Cenário: Um passo inválido abaixo
    Dado que a linha abaixo está errada
    Essa linha não é correta
    Então devo ver a mensagem "A linha 8 começa com uma palavra chave desconhecida (Essa)."

  Cenário: Um passo com apenas uma palavra
    Dado que a linha abaixo contém apenas uma palavra
    Quando
    Então devo ver a mensagem "O passo da linha 13 deve conter mais do que apenas uma palavra."