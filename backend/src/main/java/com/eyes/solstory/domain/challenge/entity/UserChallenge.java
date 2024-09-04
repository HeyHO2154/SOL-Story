package com.eyes.solstory.domain.challenge.entity;

import java.time.LocalDate;

import com.eyes.solstory.domain.user.entity.User;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name = "user_challenges")
@SequenceGenerator(
	    name = "user_challenge_seq_generator",
	    sequenceName = "user_challenge_seq", // 오라클에 생성한 시퀀스 이름
	    allocationSize = 1  // 시퀀스 값을 하나씩 증가
	)
public class UserChallenge {

	// 제시된 도전과제 일련번호
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_challenge_seq_generator")
    @Column(name = "assignment_no", precision = 10)
    private int assignmentNo;

    // 사용자 객체
    @ManyToOne
    @JoinColumn(name = "user_no", nullable = false)
    private User user;

    // 도전과제 일련번호
    @ManyToOne
    @JoinColumn(name = "challenge_no", nullable = false)
    private Challenge challenge;

    // 도전과제가 사용자에게 할당된 날짜
    @Column(name = "assigned_date", nullable = false)
    private LocalDate assignedDate;

    // 도전과제 완료일자
    @Column(name = "complete_date")
    private LocalDate completeDate;
}