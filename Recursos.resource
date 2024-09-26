*** Settings ***
Documentation        Armazenar recursos para os testes
Library    RequestsLibrary
Library    String
Library    Collections
Library    FakerLibrary    locale=pt_BR
Resource  ../Projeto_Academy_Suits - Copia/variaveis.robot
Resource  ../Projeto_Academy_Suits - Copia/Recursos.resource

*** Keywords ***

Create API Session
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session     alias=APISuits      url=https://suits.qacoders-academy.com.br  
    ...   headers=${headers}
  
Login de acesso  
   ${body}    Create Dictionary       mail=${Emaillogin}     password=${Passwordlogin} 
   Log  ${body}
   Create API Session    # Chamando a keyword diretamente
   ${response}=    POST On Session  alias=APISuits  url=/api/login   json=${body}
   Log  ${response.json()}
   Set Test Variable    ${TOKEN}     ${response.json()["token"]}
Validar o token e gravar em um headers de autorização
   ${headers}  Create Dictionary  Authorization=Bearer ${TOKEN}
   ${response}  GET On Session   alias=APISuits   url=/api/validateToken  headers=${headers}
    Log    ${response.content}
    Log   ${TOKEN}
    
    
Cadastrar um usuário 

    ${palavra_rondomica}=    Generate Random String    chars=[LETTERS]
    ${palavra_rondomica}=    Convert To Lower Case     ${palavra_rondomica}
    ${cpf_randomico}=        Generate Random String    11    chars=[NUMBERS] 
    Set Test Variable        ${CPF}                    ${cpf_randomico}
    Set Test Variable        ${EMAIL_TEST}             ${palavra_rondomica}@gmail.com


    ${headers}     Create Dictionary    Authorization=${TOKEN} 
    ${body}        Create Dictionary    fullName=Fulano da Silva      mail=${EMAIL_TEST}      
    ...                                 password=${Passwordlogin}     confirmPassword=${Passwordlogin}     
    ...                                 accessProfile=ADMIN           cpf=${CPF}
    Log    ${body}
    Create API Session
    ${response}    POST On Session      alias=APISuits   url=/api/user    json=${body}   expected_status=201   headers=${headers}
    Log                  ${response.json()}
    Set Test Variable    ${ID_USUARIO}        ${response.json()['user']['_id']}
     
  

Cadastrar Compania
    ${cnpj}        FakerLibrary.cnpj    
    ${cnpj}=       Remove String    ${cnpj}    .    /    -
    ${headers}     Create Dictionary    Authorization=${TOKEN}
    ${address}     Create Dictionary    zipCode=08663080
    ...    city=São Paulo
    ...    state=SP
    ...    district=Rua Joaquim de Macedo
    ...    street=Casa Branca
    ...    number=850
    ...    complement=bloco B numero 30
    ...    country=Brasil

    ${address}   Create List     ${address}
    ${body}    Create Dictionary
    ...    corporateName=Tabajara Organização
    ...    registerCompany=${cnpj}
    ...    mail=test@test.com
    ...    matriz=Tabajara 1
    ...    responsibleContact=Luciana
    ...    telephone=11234567895632
    ...    serviceDescription=Teste2 
    ...    address=${address}
          
    
    ${resposta}=    POST On Session     alias=APISuits    url=/api/company    headers=${headers}
    ...    json=${body}     expected_status=201
    Log   ${resposta.json()}
    Set Test Variable    ${COMPANY_ID}    ${resposta.json()['newCompany']['_id']}
    Log   ${COMPANY_ID}
    


Validar campo corporateName Cem caracteres
    
    ${cemcaracteres}    Retorna cem caracteres    
    ${headers}     Create Dictionary    Authorization=${TOKEN}
    ${address}     Create Dictionary   zipCode=08663080
    ...    city=São Paulo
    ...    state=SP
    ...    district=Rua Joaquim de Macedo
    ...    street=Casa Branca
    ...    number=850
    ...    complement=bloco B numero 30
    ...    country=Brasil

    ${address}   Create List     ${address}
    ${body}      Create Dictionary    corporateName=${cemcaracteres}
    ...    registerCompany=456987123666555
    ...    mail=test@test.com
    ...    matriz=Tabajara 1
    ...    responsibleContact=Luciana
    ...    telephone=11234567895632
    ...    serviceDescription=Teste2 
    ...    address=${address}
          
      
    ${resposta}=    POST On Session     alias=APISuits    url=/api/company    headers=${headers}
    ...    json=${body}     expected_status=400
    Log   ${resposta.json()}

Retorna cem caracteres
    ${numeros}    Generate Random String    101    LETTERS
    RETURN    ${numeros}    

Update Company
    [Documentation]  Este teste faz uma requisição PUT para atualizar os dados de uma empresa.
   
    ${headers}   Create Dictionary    Authorization=${TOKEN} 
    ${address}   Create Dictionary   
    ${address}   Create List     ${address}
    ${body}      Create Dictionary    
    ...  corporateName=Teste do Teste
    ...  registerCompany=12726456000171
    ...  mail=test@test.com
    ...  matriz=Teste
    ...  responsibleContact=Marcio
    ...  telephone=99999999999999
    ...  serviceDescription=Testes

    ${resposta}=    PUT On Session    alias=APISuits    url=/api/company/${COMPANY_ID}  headers=${headers}  
    ...    json=${body}     expected_status=201
    Log   ${resposta.json()}
   

