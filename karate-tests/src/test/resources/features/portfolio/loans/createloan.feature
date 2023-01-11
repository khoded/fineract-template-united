Feature: Test loan account apis
  Background:
    * callonce read('classpath:features/base.feature')
    * url baseUrl

  @createanddisburseloan
  Scenario: Create approve and disburse loan
    * def loan = call read('classpath:features/portfolio/loans/loansteps.feature@createloan')
    * def loanId = loan.loanId
    * call read('classpath:features/portfolio/loans/loansteps.feature@approveloan') { var: { loanId : loanId} }
    * def disburseloan = call read('classpath:features/portfolio/loans/loansteps.feature@disburse') { var: { loanId : loanId} }
    Then def disburseloanId = disburseloan.loanId

