package com.eyes.solstory.domain.userinfo.entity;

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
@Table(name = "interests")
@SequenceGenerator(
	    name = "interest_seq_generator",
	    sequenceName = "interest_seq", 
	    allocationSize = 1  
	)
public class Interest {
	@Id
    @Column(name="interest_no")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "interest_seq_generator")
	private int interestNo;

	@Column(name = "user_no", nullable = false, precision = 10)
    private int userNo;
	
	@Column(name="interest_cate", nullable = false, length = 50)
    private String interestCate;

}