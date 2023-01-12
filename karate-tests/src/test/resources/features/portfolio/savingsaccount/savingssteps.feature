@ignore
Feature: Savings Creation Steps
  Background:
    * callonce read('classpath:features/base.feature')
    * url baseUrl

  @ignore
  @create
  Scenario: Create savings accounts
    * def savingsProduct = call read('classpath:features/portfolio/products/savingsproduct.feature@fetchdefaultproduct')
    * def result = call read('classpath:features/portfolio/clients/clientcreation.feature@create')
    Given configure ssl = true
    Given path 'savingsaccounts'
    And header Accept = 'application/json'
    And header Authorization = authToken
    And header fineract-platform-tenantid = tenantId
    * def clientId = result.clientId
    * def savingsProductId = savingsProduct.savingsProductId
    * def savingsData = read('classpath:templates/savings.json')
    And request savingsData.savingsAccount
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#notnull' }
    Then def savingsId = response.resourceId

  @ignore
  @approve
  Scenario: Approve savings account
    Given configure ssl = true
    * def savingsData = read('classpath:templates/savings.json')
    Given path 'savingsaccounts',savingsId
    And params {command:'approve'}
    And header Accept = 'application/json'
    And header Authorization = authToken
    And header fineract-platform-tenantid = tenantId
    And request savingsData.approve
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#(savingsId)' }



  @ignore
  @activate
  Scenario: Activate savings account
    Given configure ssl = true
    * def savingsData = read('classpath:templates/savings.json')
    Given path 'savingsaccounts',savingsId
    And params {command:'activate'}
    And header Accept = 'application/json'
    And header Authorization = authToken
    And header fineract-platform-tenantid = tenantId
    And request savingsData.activate
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#(savingsId)' }
    Then def activeSavingsId = response.resourceId