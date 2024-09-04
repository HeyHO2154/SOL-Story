package com.eyes.solstory.domain.challenge.repository;

import com.eyes.solstory.domain.challenge.entity.ChallengeReward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChallengeRewardRepository extends JpaRepository<ChallengeReward, Integer> {
    ChallengeReward findChallengeRewardByUserNo(int userNo);
}
