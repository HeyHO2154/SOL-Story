package com.eyes.solstory.domain.financial.entity;

import java.time.LocalDate;

import com.eyes.solstory.domain.user.entity.User;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "user_accounts")
public class UserAccount {

    // 계좌번호 PK 
	@Id
    @Column(name = "account_no", nullable = false, length = 34)
    private String accountNo;

	// 사용자 객체 - user_key 쓸까봐 변경
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_no", nullable = false)
    private User user;

    // 계좌 유형(1:저축 2:입출금)
    @Column(name = "account_type", precision = 1, nullable = false)
    private int accountType;

    // 계좌 이름
    @Column(name = "account_name", nullable = false, length = 100)
    private String accountName;

    // 저축 목표 금액
    @Column(name = "target_amount", precision = 10)
    private int targetAmount;

    // 시작 일자
    @Column(name = "reg_date", nullable = false)
    private LocalDate regDate;

    // 종료 일자
    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;

    // 계좌 활성화 여부(0: 비활성화, 1:활성화)
    @Column(name = "is_active", nullable = false, precision = 1)
    private int isActive;

}