Feature: Test savings account apis
  Background:
    * callonce read('classpath:features/base.feature')
    * url baseUrl




  @createandactivateaccount
  Scenario: Create and activate savings account
    * def savingsAccount = call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@create')
    * def savingsId = savingsAccount.savingsId
    * call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@approve') { var: { savingsId : savingsId } }
    * def activateSavings = call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@activate') { var: { savingsId : savingsId } }
    Then def activateSavings = activateSavings.activeSavingsId