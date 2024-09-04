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
@Table(name = "hobbies")
@SequenceGenerator(
	    name = "hobby_seq_generator",
	    sequenceName = "hobby_seq", 
	    allocationSize = 1  
	)
public class Hobby {
    
	@Id
    @Column(name="hobby_no")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "hobby_seq_generator")
    private int hobbyNo;
    
    @Column(name = "user_no", nullable = false, precision = 10)
    private int userNo;

    @Column(name = "hobby_cate", nullable = false, length = 50)
    private String hobbyCate;

}
