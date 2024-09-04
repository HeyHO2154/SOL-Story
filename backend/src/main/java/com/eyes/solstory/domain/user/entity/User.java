package com.eyes.solstory.domain.user.entity;

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
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "users")
@SequenceGenerator(
	    name = "user_seq_generator",
	    sequenceName = "user_seq", // 오라클에 생성한 시퀀스 이름
	    allocationSize = 1  // 시퀀스 값을 하나씩 증가
	)
public class User {

	// 사용자 일련번호
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_seq_generator")
    @Column(name = "user_no", precision = 10)
    private int userNo;

    // 사용자 ID
    @Column(name = "user_id", nullable = false, length = 50)
    private String userId;

    // 사용자 비밀번호
    @Column(name = "password", nullable = false, length = 64)
    private String password;

    // 사용자 이름
    @Column(name = "user_name", nullable = false, length = 100)
    private String userName;

    // 사용자 이메일
    @Column(name = "email", nullable = false, length = 254)
    private String email;
    
    // 사용자 성별(MALE/FEMALE)
    @Column(name = "gender", nullable = false, length = 10)
    private String gender;
    
    // 사용자 생년월일
    @Column(name = "birth", nullable = false)
    private LocalDate birth;

    // 사용자 가입일자
    @Column(name = "join_date", nullable = false)
    private LocalDate joinDate;

    // 사용자 API KEY
    @Column(name = "user_key", length = 125)
    private String userKey;
    
    // MBTI
    @Column(name = "mbti", length = 15)
    private String mbti;

    public void updateUserKey(String userKey) {
        this.userKey = userKey;
    }
}