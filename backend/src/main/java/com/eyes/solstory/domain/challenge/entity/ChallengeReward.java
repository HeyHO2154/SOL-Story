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

@Getter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "challenge_rewards")
@SequenceGenerator(
	    name = "reward_seq_generator",
	    sequenceName = "reward_seq", // 오라클에 생성한 시퀀스 이름
	    allocationSize = 1  // 시퀀스 값을 하나씩 증가
	)
public class ChallengeReward {

	//사용자 리워드 일련번호
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "reward_seq_generator")
	@Column(name = "reward_no", precision = 10)
	private int rewardNo;

	// 사용자 번호 (사용자와 1대1 관계로 단순 번호만 필요)
    @Column(name = "user_no", nullable = false, precision = 10)
    private int userNo;

    // 사용자가 획득한 총 열쇠 수
    @Column(name = "keys", nullable = false, precision = 5)
    private int keys;

	public void updateKeys(int keys) {
		this.keys = keys;
	}
}
