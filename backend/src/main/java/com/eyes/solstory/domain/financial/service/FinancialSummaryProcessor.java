package com.eyes.solstory.domain.financial.service;

import java.net.URISyntaxException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.eyes.solstory.domain.financial.dto.ActiveAccountDTO;
import com.eyes.solstory.domain.financial.dto.TransactionDTO;
import com.eyes.solstory.domain.financial.entity.DailyFinancialSummary;
import com.eyes.solstory.domain.financial.repository.FinancialSummaryRepository;
import com.eyes.solstory.util.OpenApiUtil;
import com.eyes.solstory.util.TransactionCategoryClassifier;

import lombok.AllArgsConstructor;

/**
 * 금융 정보 생성 및 저장
 */
@Service
@AllArgsConstructor
public class FinancialSummaryProcessor {

	static final DateTimeFormatter DATE_FORMATTER= DateTimeFormatter.ofPattern("yyyyMMdd");
    static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HHmmss");
    
    private UserAccountService userAccountService;
    private DemandDepositCollector demandDepositCollector;
    private SavingsCollector savingsCollector;
    private FinancialSummaryRepository summaryRepository;
	private static final Logger logger = LoggerFactory.getLogger(FinancialSummaryProcessor.class.getSimpleName());
    
	/**
	 * 자정마다 모든 활성화 된 계좌의 전날 지출/수익/저축 내역을 받아 summary
	 * 시스템 시간 고려해서 5분에 실행 
	 * @throws URISyntaxException
	 */
    @Scheduled(cron = "0 5 0 * * *")
	public void fetchAndStoreFinancialData() throws URISyntaxException {
		logger.info("Scheduler : fetchAndStoreFinancialData() 시작");
	    String yesterday = LocalDate.now().minusDays(1).format(OpenApiUtil.DATE_FORMATTER);//1일전
	    
	    List<ActiveAccountDTO> userAccounts = userAccountService.findActiveAccounts();
	    for(ActiveAccountDTO userAccount : userAccounts) {
	    	if(userAccount.getAccountType() == 1) { //저축
	    		fetchSavingsData(userAccount, yesterday); // 저축 계산
	    		
	    	}else if(userAccount.getAccountType() == 2) { //입출금
	    		fetchTransactionData(userAccount, yesterday); // 입출금 계좌 지출/수익 계산
	    	}
	    }
	}
	
	/**
	 * 입출금 계좌 내역 처리
	 * 
	 * @param userAccount
	 * @param date
	 * @throws URISyntaxException
	 */
	private void fetchTransactionData(ActiveAccountDTO userAccount, String date) throws URISyntaxException {
		logger.info("fetchTransactionData()...userAccount:{}, date:{}", userAccount.toString(), date);
    	int userNo = userAccount.getUserNo();
    	Map<String, List<TransactionDTO>> transactionMap = demandDepositCollector.fetchTransactions(userAccount, date);// 거래 내역 받아오기
    	logger.error("transactionMap:{}", transactionMap.toString());
		categorizeSpending(userNo,  transactionMap.get("spendingList")); // 지출 카테고리 분류
    	categorizeIncome(userNo,  transactionMap.get("incomeList")); // 수입 카테고리
	}
	
	/**
	 * 저축 계좌 내역 처리 
	 * 
	 * @param userAccount
	 * @param date
	 * @throws URISyntaxException
	 */
	private void fetchSavingsData(ActiveAccountDTO userAccount, String date) throws URISyntaxException {
		logger.info("fetchSavingsData()...userAccount:{}, date:{}", userAccount.toString(), date);
		int amount = savingsCollector.fetchSavings(userAccount, date);// 저축 금액 받기
		if(amount != 0) {
			createSummary(userAccount.getUserNo(), amount);
		}
	}
	
	
	/**
	 * 카테고리별 지출금액 분류
	 * @param userNo 지출 사용자 일련번호
	 * @param transactions 어제 지출 내역(상호명 포함)
	 */
	private void categorizeSpending(int userNo, List<TransactionDTO> transactions) {
		logger.info("categorizeSpending()...userNo:{}, transactions:{}", userNo, transactions.toString());
	    // 카테고리, 카테고리 지출 금액합
		Map<String, Integer> categoryTotals = new HashMap<>();

	    // 거래 내역별 카테고리 분류, 카테고리 별 금액 합산
	    for (TransactionDTO transaction : transactions) {
	        String category = TransactionCategoryClassifier.spendingClassify(transaction.getTransactionSummary());
	        int amount = transaction.getTransactionBalance();
	        
	        categoryTotals.put(category, categoryTotals.getOrDefault(category, 0) + amount);
	    }
	    // 2 지출
	    createSummaries(userNo, categoryTotals, 0);
	}
	
	
	/**
	 * 당근 수익 분류
	 * @param userNo 사용자 일련번호
	 * @param transactions 어제 수익 내역
	 */
	private void categorizeIncome(int userNo, List<TransactionDTO> transactions) {
		logger.info("categorizeIncome()...userNo:{}, transactions:{}", userNo, transactions.toString());
		int income = 0;
	    // 중고 수익만 체크
	    for (TransactionDTO transaction : transactions) {
	        String category = TransactionCategoryClassifier.incomeClassify(transaction.getTransactionSummary());
	        if(category.equals("당근수익")) income += transaction.getTransactionBalance();
	    }
	    // 3 수익
	    createSummaries(userNo, null, income);
	}
	
	/**
	 * 
	 * @param userNo
	 * @param spendingCategoryTotals
	 * @param income
	 */
	private void createSummaries(int userNo, Map<String, Integer> spendingCategoryTotals, int income) {
		logger.info("createSummaries()...userNo:{}, spendingCategoryTotals:{}, income:{}", userNo, spendingCategoryTotals.toString(), income);
	    // 카테고리별 요약 정보를 DailyFinancialSummary 객체로 변환
	    List<DailyFinancialSummary> summaries = new ArrayList<>();
	    if(spendingCategoryTotals == null) { // income
	    	addSummary(summaries, userNo, 3, "당근수익", income);
	    }else { //spending
	    	for (Map.Entry<String, Integer> entry : spendingCategoryTotals.entrySet()) {
	    		if(entry.getValue() == 0) {
	    			continue;
	    		}
	    		addSummary(summaries, userNo, 2, entry.getKey(), entry.getValue());
	    	}
	    }
	    storeSummaries(summaries);
	}
	
	/**
	 * 
	 * @param userNo
	 * @param income
	 */
	private void createSummary(int userNo, int amount) {
		logger.info("createSummary()...userNo:{}, amount:{}", userNo, amount);
		DailyFinancialSummary summary = DailyFinancialSummary.builder()
				.userNo(userNo)
				.financialDate(LocalDate.now().minusDays(1)) 
				.financialType(1)
				.category(null)
				.totalAmount(amount)
				.build();
		storeSummary(summary);
	}
	
	/**
	 * 
	 * @param summaries
	 * @param userNo
	 * @param financialType
	 * @param category
	 * @param amount
	 */
	private void addSummary(List<DailyFinancialSummary> summaries, int userNo, int financialType, String category, int amount) {
		logger.info("addSummary()...summaries:{}, userNo:{}, financialType:{}, category:{}, amount:{}", summaries.toString(), userNo, financialType, category, amount);
		DailyFinancialSummary summary = DailyFinancialSummary.builder()
				.userNo(userNo)
				.financialDate(LocalDate.now().minusDays(1)) 
				.financialType(financialType)
				.category(category)
				.totalAmount(amount)
				.build();
		summaries.add(summary);
	}


	// add summaries data to daily_financial_summary
	private void storeSummaries(List<DailyFinancialSummary> summaries) {
		logger.info("storeSummaries()...summaries:{}", summaries.toArray());
        summaryRepository.saveAll(summaries);
    }
	
	// add summary data to daily_financial_summary
	private void storeSummary(DailyFinancialSummary summary) {
        summaryRepository.save(summary);
    }
}