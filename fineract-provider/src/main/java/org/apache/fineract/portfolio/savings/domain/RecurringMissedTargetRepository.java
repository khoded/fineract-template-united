/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.fineract.portfolio.savings.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

public interface RecurringMissedTargetRepository
        extends JpaRepository<RecurringMissedTargetData, Long>, JpaSpecificationExecutor<RecurringMissedTargetData> {

    String sql = "SELECT sa.id AS id, sa.account_no AS accountNo,sa.status_enum AS statusEnum, " +
            " sa.total_deposits_derived AS  totalDepositsDerived, sa.total_interest_earned_derived AS  totalInterestEarnedDerived " +
            " ,sa.total_interest_posted_derived AS totalInterestPostedDerived , " +
            " det.mandatory_recommended_deposit_amount AS recommendedDepositAmount,det.total_overdue_amount AS totalOverdueAmount, " +
            "       sp.add_penalty_on_missed_target_savings AS addPenaltyOnMissedTargetSavings " +
            " FROM m_savings_account sa " +
            " INNER JOIN m_deposit_account_recurring_detail det  ON sa.id = det.savings_account_id " +
            " INNER JOIN m_savings_product sp ON sa.product_id = sp.id " +
            " INNER JOIN  m_deposit_product_recurring_detail mdprd  ON sp.id = mdprd.savings_product_id WHERE sa.id = ?1 " +
            " AND sa.status_enum = 300 AND sp.add_penalty_on_missed_target_savings = true ";

    @Query(value = sql, nativeQuery = true)
    RecurringMissedTargetData findRecurringDepositAccountWithMissedTarget(Long savingsAccountId);
}
