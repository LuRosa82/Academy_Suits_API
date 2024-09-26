*** Settings ***
Resource  ../Projeto_Academy_Suits/Recursos.resource

*** Test Cases ***
Cenário com POST: Cadastrar um novo usuário com sucesso
    Create API Session
    Login de acesso
    Cadastrar um usuário




