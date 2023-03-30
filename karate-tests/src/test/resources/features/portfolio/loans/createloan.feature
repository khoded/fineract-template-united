Feature: Test loan account apis
  Background:
    * callonce read('classpath:features/base.feature')
    * url baseUrl

  @createanddisburseloan
  Scenario: Create approve and disburse loan
      #to choose an earlier date use faker.date().past(20, TimeUnit.DAYS)
      #loan creation made 30 days back
    * def submittedOnDate = df.format(faker.date().past(370, 369, TimeUnit.DAYS))
    * def loanAmount = 1000
    * def loan = call read('classpath:features/portfolio/loans/loansteps.feature@createloan') { submittedOnDate : '#(submittedOnDate)', loanAmount : '#(loanAmount)', clientCreationDate : '#(submittedOnDate)' }
    * def loanId = loan.loanId
      #approval
    * def approvalDate = submittedOnDate
    * call read('classpath:features/portfolio/loans/loansteps.feature@approveloan') { approvalDate : '#(approvalDate)', loanAmount : '#(loanAmount)', loanId : '#(loanId)' }

      #disbursal
    * def disbursementDate = submittedOnDate
    * def disburseloan = call read('classpath:features/portfolio/loans/loansteps.feature@disburse') { loanAmount : '#(loanAmount)', disbursementDate : '#(disbursementDate)', loanId : '#(loanId)' }
     #fetch loan details here
    * def loanResponse = call read('classpath:features/portfolio/loans/loansteps.feature@findloanbyid') { loanId : '#(loanId)' }
    * def outstandingBalance = loanResponse.loanAccount.summary.totalExpectedRepayment
    * def maturityDate = loanResponse.loanAccount.timeline.expectedMaturityDate
    * print maturityDate
    * def expectedRepaymentDate = calendar
    * print maturityDate[0]+"-"+maturityDate[1]+"-"+maturityDate[2]
    * expectedRepaymentDate.set(maturityDate[0], maturityDate[1] - 1, maturityDate[2])
    * print expectedRepaymentDate
    * def repaymentDate = df.format(expectedRepaymentDate.getTime())
     #make payment repaymentDate, repaymentAmount
    * def repayment = call read('classpath:features/portfolio/loans/loansteps.feature@loanRepayment') { loanId : '#(loanId)', repaymentDate :  '#(repaymentDate)', dateFormat : '#(dateFormat)', repaymentAmount : '#(outstandingBalance)' }
    * def loanResponse = call read('classpath:features/portfolio/loans/loansteps.feature@findloanbyid') { loanId : '#(loanId)' }
    * assert outstandingBalance == loanResponse.loanAccount.summary.totalRepayment
    * assert loanResponse.loanAccount.status.closed == true
    * assert loanResponse.loanAccount.status.overpaid == false
    * assert loanResponse.loanAccount.status.closedObligationsMet == true



  @createanddisburseloanToSavingsAccount
  Scenario: Create approve and disburse loan to a savings account
    Then print 'JB Disburse to Savings'
    * def loanProduct = call read('classpath:features/portfolio/products/loanproduct.feature@fetchdefaultproduct')
    * def loanProductId = loanProduct.loanProductId
    #create savings account with clientCreationDate
    * def submittedOnDate = df.format(faker.date().past(30, 29, TimeUnit.DAYS))

    * def result = call read('classpath:features/portfolio/clients/clientsteps.feature@create') { clientCreationDate : '#(submittedOnDate)' }
    * def clientId = result.response.resourceId
    #Create Savings Account Product and Savings Account
    Then print 'Client With Savings Account is ID =  : ', clientId
        #create savings account step

    * def savingsAccount = call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@createSavingsAccountStep') { submittedOnDate : '#(submittedOnDate)', clientId : '#(clientId)'}
    * def savingsId = savingsAccount.savingsId
    #approve savings account step setup approval Date

    * call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@approve') { savingsId : '#(savingsId)', approvalDate : '#(submittedOnDate)' }
    #activate savings account step activation Date
    * def activateSavings = call read('classpath:features/portfolio/savingsaccount/savingssteps.feature@activate') { savingsId : '#(savingsId)', activationDate : '#(submittedOnDate)' }
    Then def activeSavingsId = activateSavings.activeSavingsId

      #loan creation made 30 days back
    * def loanAmount = 1000
    * def loan = call read('classpath:features/portfolio/loans/loansteps.feature@createLoanWithSavingsAccountStep') { submittedOnDate : '#(submittedOnDate)', loanAmount : '#(loanAmount)', clientCreationDate : '#(submittedOnDate)', loanProductId : '#(loanProductId)', clientId : '#(clientId)', savingsAccountId : '#(savingsId)' }
    * def loanId = loan.loanId

      #approval
    * def approvalDate = submittedOnDate
    * call read('classpath:features/portfolio/loans/loansteps.feature@approveloan') { approvalDate : '#(approvalDate)', loanAmount : '#(loanAmount)', loanId : '#(loanId)' }

      #disbursal
    * def disbursementDate = submittedOnDate
    * def disburseloan = call read('classpath:features/portfolio/loans/loansteps.feature@disburse') { loanAmount : '#(loanAmount)', disbursementDate : '#(disbursementDate)', loanId : '#(loanId)' }
     #fetch loan details here
    * def loanResponse = call read('classpath:features/portfolio/loans/loansteps.feature@findloanbyid') { loanId : '#(loanId)' }



