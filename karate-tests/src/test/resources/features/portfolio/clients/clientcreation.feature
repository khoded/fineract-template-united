Feature: Test client apis
  Background:
    * callonce read('classpath:features/base.feature')
    * url baseUrl

    @createFetchUpdateEntityClient
    Scenario: Create fetch and update Entity client
    * def submittedOnDate = df.format(faker.date().past(30, 29, TimeUnit.DAYS))
    * def result = call read('classpath:features/portfolio/clients/clientsteps.feature@createEntityStep') { clientCreationDate : '#(submittedOnDate)'}
    * def createdClientId = result.clientId

    #activateclient
    * def activatedClient = call read('classpath:features/portfolio/clients/clientsteps.feature@activateClientStep') { clientId : '#(createdClientId)'}
    * assert createdClientId == activatedClient.res.clientId

    #fetch created client
    * def legalFormId = 2
    * def result = call read('classpath:features/portfolio/clients/clientsteps.feature@findbyclientid') { clientId : '#(createdClientId)'}
    * def client = result.client
    * match createdClientId == client.id
    * match legalFormId == client.legalForm.id

    #update fetched client
    * def accountNo = client.accountNo
    * def updatedClient = call read('classpath:features/portfolio/clients/clientsteps.feature@updateEntityStep') { clientId : '#(createdClientId)', accountNo : '#(accountNo)'}
    * assert createdClientId == updatedClient.res.resourceId


    @createFetchAndUpdatePersonClient
    Scenario: Create fetch and update Normal client
    * def submittedOnDate = df.format(faker.date().past(30, 29, TimeUnit.DAYS))
    * def result = call read('classpath:features/portfolio/clients/clientsteps.feature@create') { clientCreationDate : '#(submittedOnDate)'}
    * def createdClientId = result.clientId

    #fetch created client
    * def legalFormId = 1
    * def result = call read('classpath:features/portfolio/clients/clientsteps.feature@findbyclientid') { clientId : '#(createdClientId)'}
    * def client = result.client
    * match createdClientId == client.id
    * match legalFormId == client.legalForm.id

    #update fetched client
    * def updatedClient = call read('classpath:features/portfolio/clients/clientsteps.feature@update') { clientId : '#(createdClientId)'}
    * assert createdClientId == updatedClient.res.resourceId

