package com.eyes.solstory.domain.financial.controller;

import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.eyes.solstory.domain.financial.dto.CategorySpendingAvgDTO;
import com.eyes.solstory.domain.financial.dto.CategorySpendingSummaryDTO;
import com.eyes.solstory.domain.financial.dto.FinancialTrendDTO;
import com.eyes.solstory.domain.financial.dto.StoreSpendingSummary;
import com.eyes.solstory.domain.financial.service.FinancialSummaryAnalyzer;
import com.eyes.solstory.util.generator.DataGenerator;

import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/api/financial")
@AllArgsConstructor
public class FinancialSummaryController {

    private FinancialSummaryAnalyzer summaryAnalyzer;
    private static final Logger logger = LoggerFactory.getLogger(FinancialSummaryController.class.getSimpleName());

    /**
     * 최근 30일 지출 상위 카테고리 5개의 지출 합계
     * @param userNo
     * @return
     */
    @GetMapping(value = "/top5-categories-amount", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<CategorySpendingSummaryDTO>> getTop5Categories(@RequestParam("userNo") int userNo) {
        logger.info("getTop5Categories()...userNo:{}", userNo);
        List<CategorySpendingSummaryDTO> list = summaryAnalyzer.getTop5Categories(userNo);
        if(!list.isEmpty()) {
        	for (CategorySpendingSummaryDTO categorySpendingSummaryDTO : list) {
        		System.out.println(categorySpendingSummaryDTO.getCategory());
			}
        }else {
        	System.out.println("empty");
        }
        
        return ResponseEntity.ok(list);
    }
    
    /**
     * 최근 30일 지출 상위 카테고리 5개의 동일 연령대 평균 지출 금액
     * @param userNo
     * @return
     */
    @GetMapping(value = "/top5-categories-with-avg", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, CategorySpendingAvgDTO>> getTop5CategoriesWithAvg(@RequestParam("userNo") int userNo) {
        logger.info("getTop5CategoriesWithAvg()...userNo:{}", userNo);
        return ResponseEntity.ok(summaryAnalyzer.getTop5CategoriesWithAvg(userNo));
    }
    
    /**
     * 최근 30일의 이전 30일 대비 지출 증감 (지출 상위 10개 카테고리)
     * @param userNo
     * @return
     */
    @GetMapping(value = "/spending-trends", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<FinancialTrendDTO>> getSpendingTrends(@RequestParam("userNo") int userNo) {
        logger.info("getSpendingTrends()...userNo:{}", userNo);
        return ResponseEntity.ok(summaryAnalyzer.getSpendingTrends(userNo));
    }
    
    /**
     * 최근 7일 카테고리별 지출 합계
     * @param userNo
     * @return
     */
    @GetMapping(value = "/last7-days-spending", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<CategorySpendingSummaryDTO>> getLast7DaysSpending(@RequestParam("userNo") int userNo) {
        logger.info("getLast7DaysSpending()...userNo:{}", userNo);
        return ResponseEntity.ok(summaryAnalyzer.getLast7DaysSpending(userNo));
    }
    
    /**
     * 최근 7일간 가장 지출이 많았던 카테고리 소비 요약 정보
     * @param userNo
     * @return
     * @throws URISyntaxException
     */
    @GetMapping(value = "/highest-spending-details", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<StoreSpendingSummary>> getCategoryDetails(@RequestParam("userNo") int userNo) throws URISyntaxException{
        logger.info("getCategoryDetails()...userNo:{}", userNo);
        //return ResponseEntity.ok(summaryAnalyzer.getCategoryDetails(userNo));
        return ResponseEntity.ok(DataGenerator.cafesIn());
    }
    
    /** 미사용 - 
     * 최근 한달, 전월 대비 소비 증가율이 가장 높은 카테고리 중 가장 지출이 높은 keyword
     * @param userNo
     * @return
     * @throws URISyntaxException
     */
    @GetMapping(value = "/highest-spending-growth-keyword", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> getKeywordWithHighestSpendingGrowth(@RequestParam("userNo") int userNo) throws URISyntaxException{
        logger.info("getKeywordWithHighestSpendingGrowth()...userNo:{}", userNo);
        return ResponseEntity.ok(summaryAnalyzer.getKeywordWithHighestSpendingGrowth(userNo));
    }
    
    /**
     * 최근 한달, 전월 대비 소비 증가율이 가장 높은 카테고리
     * @param userNo
     * @return
     * @throws URISyntaxException
     */
    @GetMapping(value = "highest-spending-growth-category", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> getCategoryWithHighestSpendingGrowth(@RequestParam("userNo") int userNo) throws URISyntaxException{
        logger.info("getCategoryWithHighestSpendingGrowth()...userNo:{}", userNo);
        return ResponseEntity.ok(summaryAnalyzer.getCategoryWithHighestSpendingGrowth(userNo));
    }
    
    /**
     * 최근 한달 지출 총액
     * @param userNo
     * @return
     */
    @GetMapping(value = "/total-spending", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Integer> getTotalSpendingForMonth(@RequestParam("userNo") int userNo){
        logger.info("getTotalSpendingForMonth()...userNo:{}", userNo);
    	return ResponseEntity.ok(summaryAnalyzer.getTotalSpendingForMonth(userNo));
    }
    
    /**
     * 저축 계좌 잔액 (총 저축액)
     * @param userNo
     * @return
     * @throws URISyntaxException
     */
    @GetMapping(value = "/total-savings-amount", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Integer> getTotalSavingsAmount(@RequestParam("userNo") int userNo) throws URISyntaxException{
        logger.info("getTotalSavingsAmount()...userNo:{}", userNo);
    	//return ResponseEntity.ok(summaryAnalyzer.getTotalSavingsAmount(userNo));
        int order = userNo%10;
    	return ResponseEntity.ok(DataGenerator.getSavingsBalane(order));
    }
    
    
    /**
     * 사용자 금융 상태 분석 점수
     * 저축 점수 : 기본 100 + 지난 달 대비 이번 달 저축 증감률 (0 ~ 200)  
     * 지출 점수 : 기본 100 - 지난 달 대비 이번 달 소비 증감률 (0 ~ 200)
     * >> 분석 점수 : (저축 + 지출)/4 > 0 ~ 100점까지 (소수점 두자리 수까지 반환)
     *  = 기본 50 + (저축 점수 + 지출 점수)/4 
     * @param userNo
     * @return
     */
    @GetMapping(value = "/financial-score", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Integer> getFinancialScore(@RequestParam("userNo") int userNo) {
        logger.info("getFinancialScore()...userNo:{}", userNo);
    	return ResponseEntity.ok(summaryAnalyzer.getFinancialScore(userNo));
    }
    
    
    /**
     * 최근 한달 지출 상위 3개 카테고리
     * @param userNo
     * @return
     */
    @GetMapping(value = "/top3-categories", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String[]> getTop3Categories(@RequestParam("userNo") int userNo){
        logger.info("getTop3Categories()...userNo:{}", userNo);
    	return ResponseEntity.ok(summaryAnalyzer.getTop3Categories(userNo));
    }
}