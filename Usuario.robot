*** Settings ***
Resource  ../Projeto_Academy_Suits - Copia/variaveis.robot
Resource  ../Projeto_Academy_Suits - Copia/Recursos.resource

*** Test Cases ***
Cenário com POST: Cadastrar um novo usuário com sucesso
    Create API Session
    Login de acesso
    Cadastrar um usuário




