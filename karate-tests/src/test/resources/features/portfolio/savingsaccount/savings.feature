Feature: Test savings account apis
  Background:
    * callonce read('classpath:features/base.feature')
    * url baseUrl
    * def savingsData = read('classpath:templates/savings.json')



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
    And request
            """
                {
                    "productId": "#(savingsProductId)",
                    "nominalAnnualInterestRate": 0,
                    "withdrawalFeeForTransfers": false,
                    "allowOverdraft": false,
                    "enforceMinRequiredBalance": false,
                    "withHoldTax": false,
                    "interestCompoundingPeriodType": 1,
                    "interestPostingPeriodType": 4,
                    "interestCalculationType": 1,
                    "interestCalculationDaysInYearType": 365,
                    "submittedOnDate": "#(df.format(calendar.getTime()))",
                    "locale": "en",
                    "dateFormat": "#(format)",
                    "monthDayFormat": "dd MMM",
                    "charges": [],
                    "clientId": "#(clientId)"
                }
            """
    When method POST
    Then status 200
    Then match $ contains { resourceId: '#notnull' }
    Then def savingsId = response.resourceId