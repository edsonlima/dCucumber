
Funcionalidade: Validar uma feature que não começa com a palavra funcionalidade ou linha em branco
  Como Desenvolvedor
  Gostaria que o dCucumber me avisase onde estão os erros da minha feature
  Para que eu possa corrigi-los
  
  Cenário: Uma feature sem funcionalidade
    Dado que feature "feture_sem_funcionalidade.feature" não contém uma funcionalidade
    Então devo ver a mensagem "A feature 'feture_com_primeira_linha_em_branco.feature' não começa com a palavra Funcionalidade: seguida de seu título na primeira linha."
