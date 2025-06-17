% https://swish.swi-prolog.org/
% ===============================================
% SISTEMA DE RELACIONAMENTOS FAMILIARES - PROLOG
% ===============================================

% FATOS BÁSICOS DA FAMÍLIA
% ========================

% Definindo pessoas (nome, sexo)
pessoa(joao, masculino).
pessoa(maria, feminino).
pessoa(pedro, masculino).
pessoa(ana, feminino).
pessoa(carlos, masculino).
pessoa(lucia, feminino).
pessoa(marcos, masculino).
pessoa(julia, feminino).
pessoa(bruno, masculino).
pessoa(carla, feminino).
pessoa(diego, masculino).
pessoa(sofia, feminino).

% Relacionamentos de parentesco direto
% pai(Pai, Filho)
pai(joao, pedro).
pai(joao, ana).
pai(pedro, marcos).
pai(pedro, julia).
pai(carlos, bruno).
pai(carlos, carla).
pai(marcos, diego).
pai(marcos, sofia).

% mae(Mae, Filho)
mae(maria, pedro).
mae(maria, ana).
mae(ana, marcos).
mae(ana, julia).
mae(lucia, bruno).
mae(lucia, carla).
mae(julia, diego).
mae(julia, sofia).

% casado(Pessoa1, Pessoa2)
casado(joao, maria).
casado(pedro, ana).
casado(carlos, lucia).
casado(marcos, julia).

% REGRAS DE RELACIONAMENTO
% ========================

% Regra básica: se A é pai de B, então A é genitor de B
genitor(X, Y) :- pai(X, Y).
genitor(X, Y) :- mae(X, Y).

% Filho/Filha
filho(X, Y) :- genitor(Y, X), pessoa(X, masculino).
filha(X, Y) :- genitor(Y, X), pessoa(X, feminino).

% Irmãos (mesmo pai E mesma mãe)
irmao(X, Y) :- 
    genitor(P, X), 
    genitor(P, Y), 
    genitor(M, X), 
    genitor(M, Y),
    P \= M,
    X \= Y,
    pessoa(X, masculino).

irma(X, Y) :- 
    genitor(P, X), 
    genitor(P, Y), 
    genitor(M, X), 
    genitor(M, Y),
    P \= M,
    X \= Y,
    pessoa(X, feminino).

% Irmãos em geral (masculino ou feminino)
irmãos(X, Y) :- irmao(X, Y).
irmãos(X, Y) :- irma(X, Y).
irmãos(X, Y) :- irmao(Y, X).
irmãos(X, Y) :- irma(Y, X).

% Avô/Avó
avo(X, Z) :- genitor(X, Y), genitor(Y, Z), pessoa(X, masculino).
ava(X, Z) :- genitor(X, Y), genitor(Y, Z), pessoa(X, feminino).

% Neto/Neta
neto(X, Y) :- avo(Y, X), pessoa(X, masculino).
neto(X, Y) :- ava(Y, X), pessoa(X, masculino).
neta(X, Y) :- ava(Y, X), pessoa(X, feminino).
neta(X, Y) :- avo(Y, X), pessoa(X, feminino).

% Tio/Tia
tio(X, Z) :- 
    irmao(X, Y), 
    genitor(Y, Z).

tia(X, Z) :- 
    irma(X, Y), 
    genitor(Y, Z).

% Sobrinho/Sobrinha
sobrinho(X, Y) :- 
    tio(Y, X), 
    pessoa(X, masculino).
sobrinho(X, Y) :- 
    tia(Y, X), 
    pessoa(X, masculino).

sobrinha(X, Y) :- 
    tio(Y, X), 
    pessoa(X, feminino).
sobrinha(X, Y) :- 
    tia(Y, X), 
    pessoa(X, feminino).

% Primo/Prima
primo(X, Y) :- 
    genitor(P1, X), 
    genitor(P2, Y), 
    irmãos(P1, P2),
    pessoa(X, masculino).

prima(X, Y) :- 
    genitor(P1, X), 
    genitor(P2, Y), 
    irmãos(P1, P2),
    pessoa(X, feminino).

% Cônjuge/Esposo/Esposa
conjuge(X, Y) :- casado(X, Y).
conjuge(X, Y) :- casado(Y, X).

esposo(X, Y) :- casado(X, Y), pessoa(X, masculino).
esposa(X, Y) :- casado(X, Y), pessoa(X, feminino).

% Sogro/Sogra
sogro(X, Y) :- 
    conjuge(Y, Z), 
    genitor(X, Z), 
    pessoa(X, masculino).

sogra(X, Y) :- 
    conjuge(Y, Z), 
    genitor(X, Z), 
    pessoa(X, feminino).

% Genro/Nora
genro(X, Y) :- 
    sogro(Y, X), 
    pessoa(X, masculino).
genro(X, Y) :- 
    sogra(Y, X), 
    pessoa(X, masculino).

nora(X, Y) :- 
    sogro(Y, X), 
    pessoa(X, feminino).
nora(X, Y) :- 
    sogra(Y, X), 
    pessoa(X, feminino).

% Cunhado/Cunhada
cunhado(X, Y) :- 
    conjuge(X, Z), 
    irmao(Z, Y).
cunhado(X, Y) :- 
    conjuge(X, Z), 
    irma(Z, Y).

cunhada(X, Y) :- 
    conjuge(X, Z), 
    irmao(Z, Y).
cunhada(X, Y) :- 
    conjuge(X, Z), 
    irma(Z, Y).

% REGRAS AUXILIARES
% =================

% Ancestral (avô, bisavô, etc.)
ancestral(X, Y) :- genitor(X, Y).
ancestral(X, Y) :- genitor(X, Z), ancestral(Z, Y).

% Descendente
descendente(X, Y) :- ancestral(Y, X).

% Família nuclear (pais e filhos)
familia_nuclear(Pai, Mae, Filhos) :-
    casado(Pai, Mae),
    findall(F, genitor(Pai, F), Filhos1),
    findall(F, genitor(Mae, F), Filhos2),
    intersection(Filhos1, Filhos2, Filhos).

% Parente (qualquer tipo de parentesco)
parente(X, Y) :- ancestral(X, Y).
parente(X, Y) :- descendente(X, Y).
parente(X, Y) :- irmãos(X, Y).
parente(X, Y) :- tio(X, Y).
parente(X, Y) :- tia(X, Y).
parente(X, Y) :- sobrinho(X, Y).
parente(X, Y) :- sobrinha(X, Y).
parente(X, Y) :- primo(X, Y).
parente(X, Y) :- prima(X, Y).

% CONSULTAS ÚTEIS
% ===============

% Listar todos os filhos de uma pessoa
filhos_de(Pai, Filhos) :-
    findall(F, genitor(Pai, F), Filhos).

% Contar número de filhos
num_filhos(Pessoa, N) :-
    filhos_de(Pessoa, Filhos),
    length(Filhos, N).

% Verificar se alguém tem filhos
tem_filhos(X) :- genitor(X, _).

% Listar todos os irmãos de uma pessoa
irmaos_de(Pessoa, Irmaos) :-
    findall(I, irmãos(Pessoa, I), Irmaos).

% Verificar se duas pessoas são parentes
sao_parentes(X, Y) :- parente(X, Y).
sao_parentes(X, Y) :- parente(Y, X).

% EXEMPLOS DE USO
% ===============

/*
Consultas que você pode fazer:

1. Quem são os filhos de João?
   ?- filhos_de(joao, Filhos).

2. Pedro é pai de quem?
   ?- pai(pedro, X).

3. Quem são os avós de Marcos?
   ?- avo(X, marcos); ava(X, marcos).

4. Ana e Pedro são irmãos?
   ?- irmãos(ana, pedro).

5. Quantos filhos João tem?
   ?- num_filhos(joao, N).

6. Quem são os primos de Diego?
   ?- primo(diego, X); prima(diego, X).

7. Listar toda a família nuclear de Pedro e Ana:
   ?- familia_nuclear(pedro, ana, Filhos).

8. Carlos é parente de Sofia?
   ?- sao_parentes(carlos, sofia).

9. Quem são os descendentes de João?
   ?- descendente(X, joao).

10. Encontrar todos os tios de Julia:
    ?- tio(X, julia); tia(X, julia).
*/



