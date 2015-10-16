#   **************************************************************************************************
#
#   Fellipe Souto Sampaio           - 7990422
#   Pedro Alves de Medeiros Scocco  - 755883
# 
#   Computer Science Undergraduate - University of São Paulo (IME/USP)
#   Operational Systems - Program Exercise II - README
#   Prof: Daniel M. Batista
#
#   October, 2015
#
#   **************************************************************************************************

############################################################################################################
                                          Como Compilar?
############################################################################################################
  O programa não precisa ser compilado, está escrito inteiramente na linguagem de script Ruby (https://www.ruby-lang.org/). 
  Para executar basta ter o ruby instalado, via binário ou RVM (https://rvm.io/), recomendamos uma versão >= 2.0

############################################################################################################
                                        Como executar?
############################################################################################################
  Para executar o programa pode-se executar o comando : 

$ ./run-ep2

  Ou direto na pasta 'src/' o comando:

$ ruby simulator.rb
    
############################################################################################################
                                        Comandos do EP2
############################################################################################################

espaco    <n>   - Carrega um algoritmo de gerenciamento de espaço livre 
substitui <n>   - Carrega um algoritmo de substituição de páginas
carregar  <txt> - Carrega um arquivo de trace para ser simulado
executa   <t>   - Executa a simulação com eventos de impressão a cada intervalo de t segundos
sai             - Encerra a execução
verbose         - Ativa o modo de verbosidade da simulação, imprimindo todas as estruturas de dados utilizadas.

Para executar a simulação uma segunda vez é necessário que o arquivo de trace seja carregado novamente, utilizando o comando
'carrega'.

############################################################################################################