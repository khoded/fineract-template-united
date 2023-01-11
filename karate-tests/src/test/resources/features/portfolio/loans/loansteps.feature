@ignore
Feature: Create loan stapes
  Background:
    * callonce read('classpath:features/base.feature')
    * url baseUrl
    * def productsData = read('classpath:templates/savings.json')

  @ignore
  @createloan
  Scenario: Create loan accounts
    * def loanProduct = call read('classpath:features/portfolio/products/loanproduct.feature@fetchdefaultproduct')
    * def loanProductId = loanProduct.loanProductId
    * def result = call read('classpath:features/portfolio/clients/clientcreation.feature@create')
    * def clientId = result.response.resourceId
    Given configure ssl = true
    Given path 'loans'
    And header Accept = 'application/json'
    And header Authorization = authToken
    And header fineract-platform-tenantid = tenantId
    And request
            """
              {
                "clientId": "#(clientId)",
                "productId": "#(loanProductId)",
                "disbursementData": [],
                "principal": 1000,
                "loanTermFrequency": 12,
                "loanTermFrequencyType": 2,
                "numberOfRepayments": 12,
                "repaymentEvery": 1,
                "repaymentFrequencyType": 2,
                "interestRatePerPeriod": 3,
                "amortizationType": 1,
                "isEqualAmortization": false,
                "interestType": 0,
                "interestCalculationPeriodType": 1,
                "allowPartialPeriodInterestCalcualtion": false,
                "transactionProcessingStrategyId": 1,
                "rates": [],
                "linkAccountId": null,
                "locale": "en",
                "dateFormat": "#(format)",
                "loanType": "individual",
                "expectedDisbursementDate": "#(df.format(calendar.getTime()))",
                "submittedOnDate": "#(df.format(calendar.getTime()))"
              }
            """
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#notnull' }
    Then def loanId = response.resourceId


  @ignore
  @approveloan
  Scenario: Approve loan accounts
    Given configure ssl = true
    * print loanId
    Given path 'loans',loanId
    And params {command:'approve'}
    And header Accept = 'application/json'
    And header Authorization = authToken
    And header fineract-platform-tenantid = tenantId
    And request
            """
              {
                  "approvedOnDate": "#(df.format(calendar.getTime()))",
                  "approvedLoanAmount": 1000,
                  "expectedDisbursementDate": "#(df.format(calendar.getTime()))",
                  "disbursementData": [],
                  "locale": "en",
                  "dateFormat": "#(format)"
              }
            """
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#notnull' }

  @ignore
  @disburse
  Scenario: Disburse loans account
    Given configure ssl = true
    Given path 'loans',loanId
    And params {command:'disburse'}
    And header Accept = 'application/json'
    And header Authorization = authToken
    And header fineract-platform-tenantid = tenantId
    And request
            """
              {
                  "paymentTypeId": 1,
                  "transactionAmount": 1000,
                  "actualDisbursementDate": "#(df.format(calendar.getTime()))",
                  "locale": "en",
                  "dateFormat": "#(format)"
              }
            """
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#notnull' }
    Then def loanId = response.resourceId