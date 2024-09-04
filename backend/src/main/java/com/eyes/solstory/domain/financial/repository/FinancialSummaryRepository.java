package com.eyes.solstory.domain.financial.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.eyes.solstory.domain.financial.dto.AccountKeyDTO;
import com.eyes.solstory.domain.financial.dto.CategorySpendingAvgDTO;
import com.eyes.solstory.domain.financial.dto.CategorySpendingSummaryDTO;
import com.eyes.solstory.domain.financial.dto.FinancialTrendDTO;
import com.eyes.solstory.domain.financial.dto.UserCategoryDTO;
import com.eyes.solstory.domain.financial.entity.DailyFinancialSummary;

@Repository
public interface FinancialSummaryRepository extends JpaRepository<DailyFinancialSummary, Integer> {

	@Query(value =  "SELECT * FROM (" + 
					"    SELECT d.category as category, SUM(d.total_amount) as total_amount " +
		            "    FROM daily_financial_summary d " +
		            "    WHERE user_no = :userNo AND financial_type = 2 " +
		            "    AND financial_date >= SYSDATE - 30 " +
		            "    GROUP BY d.category " +
		            "    ORDER BY SUM(d.total_amount) DESC " + 
		            ") " +
		            "WHERE ROWNUM <= 5 "
		   , nativeQuery = true)
	List<CategorySpendingSummaryDTO> findTop5Categories(@Param("userNo") int userNo);

	// 최근 한달 지출 상위 5개 카테고리의 동일 연령대 평균 지출 금액
	@Query(value = "WITH user_age_group AS ( "
				+ "    SELECT user_no, "
				+ "           CASE "
				+ "               WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM birth) + 1 BETWEEN 0 AND 9 THEN '10대 미만' "
				+ "               WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM birth) + 1 BETWEEN 10 AND 19 THEN '10대' "
				+ "               WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM birth) + 1 BETWEEN 20 AND 29 THEN '20대' "
				+ "               WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM birth) + 1 BETWEEN 30 AND 39 THEN '30대' "
				+ "               WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM birth) + 1 BETWEEN 40 AND 49 THEN '40대' "
				+ "               ELSE '50대 이상' "
				+ "           END AS age_group "
				+ "    FROM users "
				+ ") "

				+ "SELECT do.category AS category, uag.age_group, ROUND(AVG(do.total_amount)) AS avg_amount "
				+ "FROM daily_financial_summary do "
				+ "JOIN users uo ON uo.user_no = do.user_no "
				+ "JOIN user_age_group uag ON uo.user_no = uag.user_no "
				+ "WHERE uag.age_group = ( "
				+ "        SELECT u.age_group "
				+ "        FROM user_age_group u "
				+ "        WHERE u.user_no = :userNo "
				+ "    ) "
				+ "AND do.category IN ( "
				+ "                    SELECT category "
				+ "                    FROM ( SELECT a.category "
				+ "                            FROM ( "
				+ "                                SELECT d.category, SUM(d.total_amount) as total_amount "
				+ "                                FROM daily_financial_summary d "
				+ "                                WHERE d.user_no = :userNo AND d.financial_type = 2 "
				+ "                                AND d.financial_date >= SYSDATE - 30 "
				+ "                                GROUP BY d.category "
				+ "                                ORDER BY SUM(d.total_amount) DESC "
				+ "                            ) a "
				+ "                        ) "
				+ "                    WHERE ROWNUM <= 5 "
				+ "    ) "
				+ "GROUP BY do.category, uag.age_group ",
	        nativeQuery = true)
	List<CategorySpendingAvgDTO> findTop5CategoriesWithAvg(@Param("userNo") int userNo);
	
	
	// 최근 한달 소비 상위 10개 카테고리의 전월 대비 소비 트렌드 (증감 추이 - 증감률)
	@Query(value = "WITH recent_top10_spending_category AS (" +
					"SELECT *" +
					"FROM (" +
					"		SELECT d.category, SUM(d.total_amount) AS total_amount" +
					"		FROM daily_financial_summary d" +
					"		WHERE user_no = :userNo"+
					"		  AND financial_type = 2"+
					"		  AND financial_date >= sysdate-30" +
					"		GROUP BY category" +
					"		ORDER BY SUM(d.total_amount) DESC"+ 
					"		)" +
					"WHERE ROWNUM <= 10" +
					")" +
					
		            "SELECT r.category, " + 
		            "		r.total_amount AS total_amount, " +
		            "       n.total_amount_before, " +
		            "       r.total_amount - n.total_amount_before AS difference, " +
		            "       CASE WHEN n.total_amount_before = 0 THEN 0 " + 
		            "            ELSE ROUND(((r.total_amount - n.total_amount_before)/n.total_amount_before) * 100) " +
		            "       END AS percent_change " +
		            "FROM recent_top10_spending_category r, " +
		            "     ("+
		            "		SELECT b.category, " +
		            "             SUM(b.total_amount) AS total_amount_before " +
		            "      FROM daily_financial_summary b " +
		            "      WHERE b.user_no = :userNo " +
		            "        AND b.financial_type = 2 " +
		            "        AND b.financial_date >= SYSDATE - 60 " +
		            "        AND b.financial_date < SYSDATE - 30 " +
		            "        AND b.category IN (SELECT a.category " +
		            "                           FROM recent_top10_spending_category a "+
		            "							) " +
		            "      GROUP BY b.category"+
		            "	   ) n " +
		            "WHERE r.category = n.category " +
		            "ORDER BY r.total_amount DESC"
		            , nativeQuery = true)
	List<FinancialTrendDTO> getSpendingTrends(@Param("userNo") int userNo);
	
	
	// 최근 7일 카테고리별 소비금액
	@Query(value = "SELECT d.category as category, SUM(d.total_amount) as total_amount " +
		           "FROM daily_financial_summary d " +
		           "WHERE user_no = :userNo AND financial_type = 2 " +
		           "AND financial_date >= SYSDATE - 7 " +
		           "GROUP BY d.category " +
		           "ORDER BY SUM(d.total_amount) DESC" 
            , nativeQuery = true)
	List<CategorySpendingSummaryDTO> getLast7DaysSpending(@Param("userNo") int userNo);
	
	// 최근 7일 소비 최상위 카테고리
	@Query(value = "SELECT u.user_key, a.account_no, dr.category "
				 + "FROM users u, user_accounts a, ( "
				 + "                                SELECT do.user_no, do.category "
				 + "                                FROM ("
				 + "                                        SELECT d.user_no as user_no "
				 + "                                                ,d.category as category "
				 + "                                        FROM daily_financial_summary d "
				 + "                                        WHERE user_no = :userNo "
				 + "                                        AND financial_type = 2 "
				 + "                                        AND financial_date >= SYSDATE - 7 "
				 + "                                        GROUP BY d.user_no, d.category "
				 + "                                        ORDER BY SUM(d.total_amount) DESC "
				 + "                                    ) do "
				 + "                                WHERE ROWNUM = 1 "
				 + "                                ) dr "
				 + "WHERE u.user_no = dr.user_no "
				 + "AND   u.user_no = a.user_no  "
				 + "AND   a.is_active = 1 "
				 + "AND   a.account_type = 2 "
			, nativeQuery = true)
	UserCategoryDTO getMostSpendingCategory(@Param("userNo") int userNo);
	
	
	//최근 한달 전월 대비 지출 증감이 가장 큰 카테고리
	@Query(value = "WITH "
				+ "recent_spending_category AS "
				+ "("
				+ "    SELECT user_no, category, SUM(total_amount) AS total_amount "
				+ "    FROM daily_financial_summary "
				+ "    WHERE financial_type = 2 "
				+ "      AND financial_date >= SYSDATE - 30 "
				+ "    GROUP BY user_no, category "
				+ "),"
				+ "before_spending_category AS "
				+ "("
				+ "    SELECT user_no, category, SUM(total_amount) AS total_amount "
				+ "    FROM daily_financial_summary "
				+ "    WHERE financial_type = 2 "
				+ "      AND financial_date >= SYSDATE - 60 "
				+ "      AND financial_date < SYSDATE - 30 "
				+ "    GROUP BY user_no, category "
				+ ")"
				+ ""
				+ "SELECT u.user_key, a.account_no, t.category "
				+ "FROM  "
				+ "("
				+ "    SELECT r.user_no, r.category, "
				+ "           CASE WHEN NVL(b.total_amount, 0) = 0 THEN 999 "
				+ "                ELSE (r.total_amount - b.total_amount) * 100 / b.total_amount "
				+ "           END AS growth_rate "
				+ "    FROM recent_spending_category r "
				+ "    JOIN before_spending_category b ON r.user_no = b.user_no AND r.category = b.category "
				+ "    ORDER BY growth_rate DESC "
				+ ") t "
				+ "JOIN user_accounts a ON t.user_no = a.user_no "
				+ "JOIN users u ON t.user_no = u.user_no "
				+ "WHERE a.is_active = 1 "
				+ "  AND a.account_type = 2 "
				+ "  AND ROWNUM = 1 "
			, nativeQuery = true)
	UserCategoryDTO getCategoryWithHighestSpendingGrowth(@Param("userNo") int userNo);
	
	
	// 최근 한달 지출이 가장 많은 카테고리 (1위)
	@Query(value = "SELECT ot.category "
				+ " FROM ( "
				+ "         SELECT d.category "
				+ "         FROM daily_financial_summary d "
				+ "         WHERE d.user_no = :userNo "
				+ "         AND   financial_type = 2  "
				+ "         AND   financial_date >= SYSDATE -30 "
				+ "         GROUP BY d.category "
				+ "         ORDER BY NVL(SUM(d.total_amount), 0) DESC "
				+ "      ) ot"
				+ " WHERE ROWNUM = 1 "
			, nativeQuery = true)
	String findTopCategoryForMonth(@Param("userNo") int userNo);
	
	// 최근 한달 지출 상위 3개 카테고리 
	@Query(value = "SELECT ot.category"
				+ " FROM ("
				+ "         SELECT d.category"
				+ "         FROM daily_financial_summary d"
				+ "         WHERE d.user_no = :userNo"
				+ "         AND   financial_type = 2 "
				+ "         AND   financial_date >= SYSDATE -30"
				+ "         GROUP BY d.category"
				+ "         ORDER BY NVL(SUM(d.total_amount), 0) DESC"
				+ "      ) ot"
				+ " WHERE ROWNUM <= 3"
			, nativeQuery = true)
	String[] findTop3Categories(@Param("userNo") int userNo);
	
	
	
	// 최근 한달 총 소비 금액
	@Query(value = "SELECT NVL(SUM(total_amount), 0) AS toal_amount"
				+ " FROM daily_financial_summary "
				+ " WHERE financial_date >= SYSDATE - 30 "
				+ " AND user_no = :userNo"
			, nativeQuery = true)
	int deriveTotalSpendingForMonth(@Param("userNo") int userNo);
	
	
	// 금융점수
	@Query(value = "SELECT 50 + (( CASE WHEN r.savings_total_before = 0 THEN 0 "
				+ "                    ELSE ROUND (100 * (r.savings_total_after - r.savings_total_before) / r.savings_total_before) "
				+ "               END ) "
				+ "          +  ( CASE WHEN r.spending_total_before = 0 THEN 0"
				+ "                    ELSE ROUND (100 * (r.spending_total_after - r.spending_total_before) / r.spending_total_before) "
				+ "               END ) "
				+ "             )/4 AS financial_score "
				+ "FROM( "
				+ "    SELECT SUM( "
				+ "                CASE WHEN (financial_type = 1 AND financial_date >= SYSDATE - 30) THEN NVL(total_amount, 0) "
				+ "                     ELSE 0 "
				+ "                END "
				+ "          ) AS savings_total_after "
				+ "        , SUM( "
				+ "                CASE WHEN (financial_type = 1 AND financial_date >= SYSDATE - 60 AND financial_date < SYSDATE - 30) THEN NVL(total_amount, 0) "
				+ "                     ELSE 0 "
				+ "                END "
				+ "          ) AS savings_total_before "
				+ "        , SUM( "
				+ "                CASE WHEN (financial_type = 2 AND financial_date >= SYSDATE - 30) THEN NVL(total_amount, 0) "
				+ "                     ELSE 0 "
				+ "                END "
				+ "          ) AS spending_total_after "
				+ "        , SUM( "
				+ "                CASE WHEN (financial_type = 2 AND financial_date >= SYSDATE - 60 AND financial_date < SYSDATE - 30) THEN NVL(total_amount, 0) "
				+ "                     ELSE 0 "
				+ "                END "
				+ "          ) AS spending_total_before "
				+ "    FROM daily_financial_summary "
				+ "    WHERE user_no = :userNo "
				+ ") r "
			, nativeQuery = true)
	int deriveFinancialScore(@Param("userNo") int userNo);
	
	
	
	// for 지출 총액
	@Query(value = "SELECT u.user_key, a.account_no "
			+ "FROM user_accounts a, users u "
			+ "WHERE a.user_no = u.user_no "
			+ "AND u.user_no = :userNo "
			+ "AND is_active = 1 "
			+ "AND account_type = 1 -- 저축계좌"
			, nativeQuery = true)
	AccountKeyDTO findActiveSavingsAccounts(@Param("userNo") int userNo);

	// 현재 날짜로부터 7일 이내에 같은 카테고리 총액을 구하는 메서드
	@Query("SELECT SUM(d.totalAmount) FROM DailyFinancialSummary d WHERE d.userNo = :userNo AND d.category = :category AND d.financialDate BETWEEN :startDate AND :endDate")
	Integer findTotalAmountByCategoryInLast7Days(@Param("userNo") int userNo, @Param("category") String category, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

	// 현재 날짜로부터 30일 이내에 같은 카테고리 총액을 구하는 메서드
	@Query("SELECT SUM(d.totalAmount) FROM DailyFinancialSummary d WHERE d.userNo = :userNo AND d.category = :category AND d.financialDate BETWEEN :startDate AND :endDate")
	Integer findTotalAmountByCategoryInLast30Days(@Param("userNo") int userNo, @Param("category") String category, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

	// 현재 날짜로부터 1일 이내에 같은 카테고리 총액을 구하는 메서드
	@Query("SELECT SUM(d.totalAmount) FROM DailyFinancialSummary d WHERE d.userNo = :userNo AND d.category = :category AND d.financialDate BETWEEN :startDate AND :endDate")
	Integer findTotalAmountByCategoryInLast1Day(@Param("userNo") int userNo, @Param("category") String category, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);
}


