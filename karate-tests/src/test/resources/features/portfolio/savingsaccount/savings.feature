Feature: Test savings account apis
  Background:
    * callonce read('classpath:features/base.feature')
    * url baseUrl




  @createandactivateaccount
  Scenario: Create and activate savings account
    #create savings account step
    * def savingsAccount = call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@create')
    * def savingsId = savingsAccount.savingsId
    #approve savings account step
    * call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@approve') { var: { savingsId : savingsId } }
    #activate savings account step
    * def activateSavings = call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@activate') { var: { savingsId : savingsId } }
    Then def activeSavingsId = activateSavings.activeSavingsId
    # Test deposit to savings account
    * def transactionAmount = 1000
    * def transactionDate = df.format(calendar.getTime())
    * def command = 'deposit'
    * def requestVariables = { var: {savingsId : activeSavingsId }, var: {transactionAmount : transactionAmount}, var: {transactionDate:transactionDate}, var:{command:command } }
    * call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@transaction') requestVariables
    * def savingsResponse = call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@findsavingsbyid') { var: { savingsId : savingsId } }
    * assert transactionAmount == savingsResponse.savingsAccount.summary.availableBalance