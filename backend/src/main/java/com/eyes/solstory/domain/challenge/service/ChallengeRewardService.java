package com.eyes.solstory.domain.challenge.service;

import com.eyes.solstory.domain.challenge.repository.ChallengeRewardRepository;
import com.eyes.solstory.domain.user.entity.User;
import com.eyes.solstory.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ChallengeRewardService {
    private ChallengeRewardRepository challengeRewardRepository;
    private UserRepository userRepository;

    private static final Logger logger = LoggerFactory.getLogger(ChallengeRewardService.class.getSimpleName());

    //현재 수집한 열쇠 조회
    public int findChallengeKey(String email) {
        logger.info("findChallengeKey()...email:{}", email);
        User user = userRepository.findUserByEmail(email);
        return challengeRewardRepository.
                findChallengeRewardByUserNo(user.getUserNo())
                .getKeys();
    }
    //챌린지 점수 조회
    public int calScore(String email) {
        logger.info("calScore()...email:{}", email);
        User user = userRepository.findUserByEmail(email);
        logger.error("foundUser:{}", user.toString());
        int key = challengeRewardRepository.findChallengeRewardByUserNo(user.getUserNo()).getKeys();
        logger.error("foundKey:{}", key);
        if(key >= 10) {
            return 70;
        } else if (10 > key && key >= 5) {
            return 60;
        } else if (5 > key && key >= 3) {
            return 50;
        } else {
            return 30;
        }
    }
}