package com.eyes.solstory.domain.financial.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.eyes.solstory.domain.financial.dto.ActiveAccountDTO;
import com.eyes.solstory.domain.financial.entity.UserAccount;

@Repository
public interface UserAccountRepository extends JpaRepository<UserAccount, String> {

	@Query("SELECT a.user.userNo, a.accountNo, a.accountType, u.userKey FROM UserAccount a JOIN a.user u WHERE a.isActive = 1")
    List<ActiveAccountDTO> findActiveAccounts(); //활성화된 계좌번호 조회
	
}