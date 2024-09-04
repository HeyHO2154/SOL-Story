package com.eyes.solstory.domain.financial.service;

import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.eyes.solstory.domain.financial.dto.StoreSpendingSummary;
import com.eyes.solstory.domain.financial.dto.TransactionDTO;
import com.eyes.solstory.domain.financial.dto.UserCategoryDTO;
import com.eyes.solstory.util.TransactionCategoryClassifier;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class SpendingSummaryProcessor {
	
	private DemandDepositCollector demandDepositCollector;
	private static final Logger logger = LoggerFactory.getLogger(SpendingSummaryProcessor.class.getSimpleName());
	
	/**
	 * // 특정 카테고리의 지출처별 가게별 방문 정보 반환
	 * @param categoryDTO
	 * @return 
	 * @throws URISyntaxException
	 */
	public List<StoreSpendingSummary> fetchTransactionDataForMonth(UserCategoryDTO categoryDTO) throws URISyntaxException {
		logger.info("fetchTransactionDataForMonth()...categoryDTO:{}", categoryDTO);
		// 한달 간의 지출 내역을 받아옴
		List<TransactionDTO> transactions = demandDepositCollector.fetchTransactionsForMonth(categoryDTO);
		return processSpendingStoreByCategory(categoryDTO.getCategory(), transactions);
	}
	
	/*private String category; // 지출 카테고리
	private String storeName; // 지출처
	private int visitCount; //  한달간 지출처 방문 횟수
	private int totalAmount; // 한달간 지출처에서 소비한 금액
	 */
	
	/**
	 * 가게별 소비 정보 
	 * @param category
	 * @param transactions
	 * @return
	 */
	private List<StoreSpendingSummary> processSpendingStoreByCategory(String category, List<TransactionDTO> transactions) {
		logger.info("processSpendingStoreByCategory()...category:{}, transactions:{}", category, transactions);
		List<StoreSpendingSummary> visitedStores = new ArrayList<>();
		// 지출처, 지출정보
		Map<String, StoreSpendingSummary> map = new HashMap<>();
		for(TransactionDTO transaction : transactions) {
			// 이 지출 내역이 카테고리에 포함 돼
			String storeName = transaction.getTransactionSummary();
			int amount = transaction.getTransactionBalance();
			if(TransactionCategoryClassifier.isCategory(storeName, category)) {
				if(!map.containsKey(storeName)) {
					map.put(storeName, new StoreSpendingSummary(storeName, 1, amount));
				}else {
					StoreSpendingSummary store = map.get(storeName);
					store.setVisitCount(store.getVisitCount()+1);
					store.setTotalAmount(store.getTotalAmount() + amount);
				}
			}
		}
		
		visitedStores.addAll(map.values());
		// 지출이 큰 순으로 정렬
		Collections.sort(visitedStores, (store1, store2) -> store2.getTotalAmount() - store1.getTotalAmount());
		
		return visitedStores;
	}
	
	/**
	 * 키워드별 소비 정리
	 * // 특정 카테고리의 가장 지출이 많은 키워드 반환
	 * @param categoryDTO
	 * @return 
	 * @throws URISyntaxException
	 */
	public String getKeywordWithCategoryForMonth(UserCategoryDTO categoryDTO) throws URISyntaxException {
		logger.info("getKeywordWithCategoryForMonth()...categoryDTO:{}", categoryDTO);
		// 한달 간의 저축 내역을 받아옴
		List<TransactionDTO> transactions = demandDepositCollector.fetchTransactionsForMonth(categoryDTO);
		return processSpendingKeywordByCategory(categoryDTO.getCategory(), transactions);
	}
	
	/**
	 * 키워드별 소비 정보 
	 * @param category
	 * @param transactions
	 * @return
	 */
	private String processSpendingKeywordByCategory(String category, List<TransactionDTO> transactions) {
		logger.info("processSpendingKeywordByCategory()...category:{}, transactions:{}", category, transactions);
		List<StoreSpendingSummary> list = new ArrayList<>();
		// 지출처, 지출정보
		Map<String, StoreSpendingSummary> map = new HashMap<>();
		// 지출처, 지출정보
		for(TransactionDTO transaction : transactions) {
			String storeName = transaction.getTransactionSummary();
			int amount = transaction.getTransactionBalance();
			String keyword = TransactionCategoryClassifier.keyword(storeName, category);
			// 이 지출 내역이 카테고리에 포함 돼
			if(keyword != null) {
				if(!map.containsKey(keyword)) {
					map.put(keyword, StoreSpendingSummary.builder()
										.storeName(keyword) //키워드로 써먹음
										.totalAmount(amount)
										.build()); 
				} else {
					StoreSpendingSummary store = map.get(keyword);
					store.setTotalAmount(store.getTotalAmount()+amount);
				}
			}
		}
		
		list.addAll(map.values());
		// 지출이 큰 순으로 정렬
		Collections.sort(list, (store1, store2) -> store2.getTotalAmount() - store1.getTotalAmount());
		if(list.isEmpty()) {
			return null;
		}
		
		StoreSpendingSummary store = list.get(0);
		return store.getStoreName(); //키워드
	}
}
