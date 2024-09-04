package com.eyes.solstory.domain.financial.entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "daily_financial_summary")
@SequenceGenerator(
	    name = "summary_seq_generator",
	    sequenceName = "summary_seq", // 오라클에 생성한 시퀀스 이름
	    allocationSize = 1  // 시퀀스 값을 하나씩 증가
	)
public class DailyFinancialSummary {

	// summary 일련번호
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "summary_seq_generator")
    @Column(name = "summary_no", precision = 10)
    private int summaryNo;

    // 사용자 일련번호
    @Column(name = "user_no", nullable = false)
    private int userNo;

    // 지출 날짜 
    @Column(name = "financial_date", nullable = false)
    private LocalDate financialDate;

    // 산출 유형(1: 저축 , 2:소비, 3:수익)
    @Column(name = "financial_type", nullable = false, precision = 1)
    private int financialType;

    // 지출 카테고리
    @Column(name = "category", length = 50)
    private String category;

    // 총액(저축/지출 카테고리별)
    @Column(name = "total_amount", precision = 15, nullable = false)
    private int totalAmount;
}
