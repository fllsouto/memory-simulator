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
- [X] Lê entrada e saida
- [X] Configura outras classes
- [x]  Inicia execução

### ProcessManager  
- Interpreta o trace
- Sabe quando aconteçe o proximo evento (Novo processo, acesso)
- Envia eventos para MMU na hora certa

### MMU 
- Recebe eventos de novo processo e acessos à memória
- Cuida de toda a memória (alocação, paginação, substituição e acessos)


## TODO

#### LinkedList
- [X] colocar um ponteiro para o cara anterior
- [X] acertar o tipo de dado que o val irá receber

#### ProcessManager
- [X] definir como singleton    
- [X] criar estrutura de dados para salvar dados do trace
- [ ] criar eventos de impressão
- [ ] medir o tempo em que um evento começa a ser executado e comparar com o tempo em que ele deveria ter começado. Avaliar esse delta


### RubyBasicApp
- alterar da aplicação

### MemoryManager
- Tudo ?!?!