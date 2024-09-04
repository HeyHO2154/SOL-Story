package com.eyes.solstory.domain.userinfo.repository;


import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.eyes.solstory.domain.userinfo.dto.HobbyDTO;
import com.eyes.solstory.domain.userinfo.entity.Hobby;

@Repository
public interface HobbyRepository extends JpaRepository<Hobby, Integer> {
	@Query(value = "SELECT h.hobby_no, h.user_no, h.hobby_cate  FROM hobbies h WHERE h.user_no = :userNo", nativeQuery=true)
	List<HobbyDTO> getHobbyUserNo(@Param("userNo") int userNo);
}