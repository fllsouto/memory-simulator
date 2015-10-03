# PROPOSTA DE ESTRUTURA DO EP

## Simulação:

### Todos os processos já dentro:
- Um processo faz um acesso à memória
- Checa se a a pagina está na mem fisica
- Se não: Pergunta qual espaço vai liberar
- Copia da fisica para virtual (se estiver modificada)
- Copia a Da virtual para o espaço liberado da fisica
- Espera proximo uso da memoria


### Main:  
- Lê entrada e saida
- Configura outras classes
- Inicia execução

### ProcessManager  
- Interpreta o trace
- Sabe quando aconteçe o proximo evento (Novo processo, acesso)
- Envia eventos para MMU na hora certa

### MMU 
- Recebe eventos de novo processo e acessos à memória
- Cuida de toda a memória (alocação, paginação, substituição e acessos)


## TODO

#### LinkedList
- colocar um ponteiro para o cara anterior
- acertar o tipo de dado que o val irá receber

#### ProcessManager
- definir como singleton    
- criar estrutura de dados para salvar dados do trace

### RubyBasicApp
- alterar da aplicação

### MemoryManager
- Tudo ?!?!