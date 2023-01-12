@ignore
Feature: Create loan stapes
  Background:
    * callonce read('classpath:features/base.feature')
    * url baseUrl
    * def productsData = read('classpath:templates/savings.json')


  @ignore
  @createloan
  Scenario: Create loan accounts
    Given configure ssl = true
    * def loanProduct = call read('classpath:features/portfolio/products/loanproduct.feature@fetchdefaultproduct')
    * def loanProductId = loanProduct.loanProductId
    * def result = call read('classpath:features/portfolio/clients/clientcreation.feature@create')
    * def clientId = result.response.resourceId
    * def loanAmount = 1000
    * def loansData = read('classpath:templates/loans.json')
    Given path 'loans'
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And header Authorization = authToken
    And header fineract-platform-tenantid = tenantId
    And request loansData.loan1
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#notnull' }
    Then def loanId = response.resourceId


  @ignore
  @approveloan
  Scenario: Approve loan accounts
    Given configure ssl = true
    * def loanAmount = 1000
    * def loansData = read('classpath:templates/loans.json')
    Given path 'loans',loanId
    And params {command:'approve'}
    And header Accept = 'application/json'
    And header Authorization = authToken
    And header fineract-platform-tenantid = tenantId
    And request loansData.approve
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#notnull' }

  @ignore
  @disburse
  Scenario: Disburse loans account
    Given configure ssl = true
    * def loanAmount = 1000
    * def loansData = read('classpath:templates/loans.json')
    Given path 'loans',loanId
    And params {command:'disburse'}
    And header Accept = 'application/json'
    And header Authorization = authToken
    And header fineract-platform-tenantid = tenantId
    And request loansData.disburse
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#notnull' }
    Then def loanId = response.resourceId