package com.eyes.solstory.domain.financial.service;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.eyes.solstory.constants.OpenApiUrls;
import com.eyes.solstory.domain.financial.dto.AccountKeyDTO;
import com.eyes.solstory.domain.financial.dto.ActiveAccountDTO;
import com.eyes.solstory.util.OpenApiUtil;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 저축 계좌 거래 내역 수집 및 처리
 */
@Service
public class SavingsCollector {

	private static final Logger logger = LoggerFactory.getLogger(SavingsCollector.class);	

	/**
	 * 해당 계좌의 저축 내역 불러오기 -- 저축 용도로 개설한 입출금 계좌 사용
	 * 
	 * @param accountNo 조회할 계좌번호
	 * @param date 조회할 날짜
	 * @return 입금 총액(저축)
	 * @throws URISyntaxException
	 */
	public int fetchSavings(ActiveAccountDTO userAccount, String date) throws URISyntaxException {
        logger.info("fetchSavings()...userAccount:{}, date:{}", userAccount, date);
        Map<String, String> headerMap = OpenApiUtil.createHeaders(userAccount.getUserKey(), OpenApiUrls.INQUIRE_TRANSACTION_HISTORY_LIST);
        Map<String, Object> requestMap = OpenApiUtil.createTransactionHistoryRequestData(userAccount.getAccountNo(), date, "M", headerMap);

        ResponseEntity<String> response = OpenApiUtil.callApi(new URI(OpenApiUrls.DEMAND_DEPOSIT_URL + OpenApiUrls.INQUIRE_TRANSACTION_HISTORY_LIST), requestMap);
        logger.error("response:{}", response);
        ObjectMapper objectMapper = new ObjectMapper();
        
        try {
            JsonNode rootNode = objectMapper.readTree(response.getBody());
            JsonNode listNode = rootNode.path("REC").path("list");
            return parseTransactionList(listNode);
        } catch (Exception e) {
        	logger.error("저축 내역 추출 중 오류 발생");
            throw new RuntimeException("저축 내역 추출 중 오류 발생", e);
        }

    }
	
	 /**
	 * 응답데이터 parsing - 저축계좌에 입금한 총액 구해서 반환
	 * @param listNode
	 * @return
	 */
    private int parseTransactionList(JsonNode listNode) {
        logger.info("parseTransactionList()...listNode:{}", listNode);
        int savings = 0;
        if (listNode.isArray()) {
            for (JsonNode item : listNode) {
            	savings += item.path("transactionBalance").asInt();
            }
        }
        return savings;
    }
    
    
    /**
     * 저축 계좌 잔액 반환
     * 저축 용도로만 사용되기 때문에 잔액 = 그동안 저축한 총액
     * @param account
     * @return 
     * @throws URISyntaxException 
     */
    public int fetchSavingsTotal(AccountKeyDTO userAccount) throws URISyntaxException {
        logger.info("fetchSavingsTotal()...userAccount:{}", userAccount);
    	//계좌 잔액 조회
    	Map<String, String> headerMap = OpenApiUtil.createHeaders(userAccount.getUserKey(), OpenApiUrls.INQUIRE_DEMAND_DEPOSIT_ACCOUNT_BALANCE);
        Map<String, Object> requestMap = OpenApiUtil.createAccountBalanceRequestData(userAccount.getAccountNo(), headerMap);

        ResponseEntity<String> response = OpenApiUtil.callApi(new URI(OpenApiUrls.DEMAND_DEPOSIT_URL + OpenApiUrls.INQUIRE_DEMAND_DEPOSIT_ACCOUNT_BALANCE), requestMap);
        logger.error("response:{}", response);
        ObjectMapper objectMapper = new ObjectMapper();
        
        try {
            JsonNode rootNode = objectMapper.readTree(response.getBody());
            return rootNode.path("REC").path("accountBalance").asInt();
        } catch (Exception e) {
        	logger.error("저축 내역 추출 중 오류 발생");
            throw new RuntimeException("저축 내역 추출 중 오류 발생", e);
        }
    }

}
