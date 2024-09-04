package com.eyes.solstory.domain.userinfo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.eyes.solstory.domain.userinfo.dto.InterestDTO;
import com.eyes.solstory.domain.userinfo.entity.Interest;

@Repository
public interface InterestRepository extends JpaRepository<Interest, Integer> {
	@Query(value = "SELECT h.interest_no, h.user_no, h.interest_cate  FROM interests h WHERE h.user_no = :userNo", nativeQuery=true)
	List<InterestDTO> getInterestByUserNo(@Param("userNo") int userNo);
	
}
    // JpaRepository<EntityClass, ID타입>을 상속받음
    // 기본적으로 save(), findById(), findAll(), deleteById() 등의 메소드를 자동 제공함