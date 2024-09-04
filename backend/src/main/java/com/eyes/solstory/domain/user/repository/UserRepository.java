package com.eyes.solstory.domain.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.eyes.solstory.domain.user.dto.LoginUser;
import com.eyes.solstory.domain.user.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
	User findUserByUserId(@Param("userId")String userId);

	User findUserByEmail(@Param("email") String email);

	User findUserByUserNo(@Param("userNo") int userNo);
	
	@Modifying
    @Transactional
	@Query("UPDATE User SET mbti = :mbti WHERE userNo = :userNo")
	void updateUserByMbti(@Param("mbti") String mbti, @Param("userNo") int userNo);
	
	//gabin
	//계정 찾기 - 해당 이메일을 가진 회원이 존재하는지 확인
	@Query("SELECT u.userId FROM User u WHERE u.email = :email")
	String findIdByEmail(@Param("email") String email);
	
	//gabinId, 1234 로 테스트
	//로그인하기 - 로그인할 때, user_no랑 user_name을 메인화면에 전달하기
	@Query("SELECT u FROM User u WHERE u.userId = :userId AND u.password = :password")
	LoginUser login(@Param("userId") String userId, @Param("password") String password); 
	
	//아이디 중복확인
	@Query("SELECT COUNT(u) > 0 FROM User u WHERE u.userId = :userId")
	boolean existsByUserId(@Param("userId") String userId);
	
	//이메일 중복확인
	@Query("SELECT COUNT(u) > 0 FROM User u WHERE u.email = :email")
	boolean existsByEmail(@Param("email") String email);
	
	//회원가입 페이지에서 유저디테일화면으로 넘어갈 때, 유저의 넘버를 함께 넘겨주기 위해 만듦
	@Query("SELECT u FROM User u WHERE u.userId = :userId")
	User findByUserId(@Param("userId") String userId);
	
	//비밀번호 변경하기
	@Modifying
    @Transactional
    @Query("UPDATE User u SET u.password = :password WHERE u.userId = :userId")
	int changePassword(@Param("userId") String userId, @Param("password") String password); 
}