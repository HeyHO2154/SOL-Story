package com.eyes.solstory.domain.challenge.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class UserChallengeScheduler {
    private final UserChallengeService userChallengeService;
    private static final Logger logger = LoggerFactory.getLogger(UserChallengeScheduler.class.getSimpleName());

    @Scheduled(cron = "30 43 0 * * ?")
    public void checkAndRewardExpiredChallengesForAllUsers() {
        logger.info("Scheduler : checkAndRewardExpiredChallengesForAllUsers() 시작");
        userChallengeService.checkAndRewardExpiredChallenges();
    }
}
