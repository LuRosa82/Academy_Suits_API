*** Settings ***

Resource  ../Projeto_Academy_Suits - Copia/variaveis.robot
Resource  ../Projeto_Academy_Suits - Copia/Recursos.resource

*** Test Cases ***

Cenário com Post:Cadastrar Compania
    Create API Session
    Login de acesso
    Cadastrar Compania

Validar campo corporateName Cem caracteres
    Create API Session
    Login de acesso
    Validar campo corporateName Cem caracteres

Update Company
    Create API Session
    Login de acesso
    Cadastrar Compania
    Update Company