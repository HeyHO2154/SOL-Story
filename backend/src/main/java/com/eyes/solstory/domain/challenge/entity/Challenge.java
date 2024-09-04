package com.eyes.solstory.domain.challenge.entity;

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
import lombok.ToString;

@ToString
@Getter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "challenges")
@SequenceGenerator(
        name = "challenge_seq_generator",
        sequenceName = "challenge_seq", // 새 시퀀스 이름
        allocationSize = 1
)
public class Challenge {

	// 챌린지 일련번호
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "challenge_seq_generator")
    @Column(name = "challenge_no", precision = 10)
    private int challengeNo;

    // 챌린지 유형(1:저축 , 2:지출)
    @Column(name = "challenge_type", nullable = false, precision = 1)
    private int challengeType;

    @Column(name = "category", nullable = true, length = 50)
    private String category;

    //챌린지 기간 (한달: 30, 일주일: 7, 하루: 1)
    @Column(name = "days", nullable = false, precision = 2)
    private int days;

    // 챌린지 이름
    @Column(name = "challenge_name", nullable = false, length = 255)
    private String challengeName;

    // 챌린지 과제 완료 시 획득할 포인트
    @Column(name = "reward_keys", nullable = false, precision = 5)
    private int rewardKeys;
    @Column(name = "target_amount", nullable = false, precision = 5)
    private int targetAmount;

    public Challenge(int challengeType, String category, int days, String challengeName, int rewardKeys, int targetAmount) {
        this.challengeType = challengeType;
        this.category = category;
        this.days = days;
        this.challengeName = challengeName;
        this.rewardKeys = rewardKeys;
        this.targetAmount = targetAmount;
    }
}