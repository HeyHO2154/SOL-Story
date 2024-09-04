package com.eyes.solstory.domain.challenge.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Random;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.eyes.solstory.domain.challenge.ChallengeDataInitializer;
import com.eyes.solstory.domain.challenge.entity.Challenge;
import com.eyes.solstory.domain.challenge.entity.UserChallenge;
import com.eyes.solstory.domain.challenge.repository.UserChallengeRepository;
import com.eyes.solstory.domain.user.entity.User;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ChallengeService {
    private ChallengeDataInitializer challengeDataInitializer;
    private final UserChallengeRepository userChallengeRepository;

    private static final Logger logger = LoggerFactory.getLogger(ChallengeRewardService.class.getSimpleName());

    public List<Challenge> getSpendingChallengesForTop3Category(String[] top3Category, int count) {
        logger.info("getSpendingChallengesForTop3Category()...top3Category:{}, count:{}", top3Category, count);
        List<Challenge> spendingChallenges = challengeDataInitializer.getSpendingChallenges();

        Collections.sort(spendingChallenges, new Comparator<Challenge>() {
            @Override
            public int compare(Challenge c1, Challenge c2) {
                boolean c1InTop3 = isInTop3(c1.getCategory(), top3Category);
                boolean c2InTop3 = isInTop3(c2.getCategory(), top3Category);

                // c1이 top3에 있고 c2가 top3에 없으면 c1이 앞
                if (c1InTop3 && !c2InTop3) {
                    return -1;
                }
                // c2가 top3에 있고 c1이 top3에 없으면 c2가 앞
                else if (!c1InTop3 && c2InTop3) {
                    return 1;
                }
                // 둘 다 top3에 있거나, 둘 다 top3에 없으면 순서 변경하지 않음
                else {
                    return 0;
                }
            }
        });
        logger.error("spendingChallenges:{}", spendingChallenges);
        return spendingChallenges.subList(0, Math.min(count, spendingChallenges.size()));
    }

    private boolean isInTop3(String category, String[] top3Category) {
        for (String topCategory : top3Category) {
            if (category.equals(topCategory)) {
                return true;
            }
        }
        return false;
    }

    public List<Challenge> getRandomSavingChallenges(int count) {
        logger.info("getRandomSavingChallenges()...count:{}", count);
    	Random random = new Random();
        List<Challenge> savingChallenges = challengeDataInitializer.getSavingChallenges();
        Collections.shuffle(savingChallenges, random);
        return savingChallenges.subList(0, Math.min(count, savingChallenges.size()));
    }

    public List<Challenge> getRandomSpendingChallenges(int count) {
        logger.info("getRandomSpendingChallenges()...count:{}", count);
    	Random random = new Random();
        List<Challenge> spendingChallenges = challengeDataInitializer.getSpendingChallenges();
        Collections.shuffle(spendingChallenges, random);
        return spendingChallenges.subList(0, Math.min(count, spendingChallenges.size()));
    }

    public List<UserChallenge> assignChallengesToUser(User user, List<Challenge> challenges) {
        logger.info("assignChallengesToUser()...user:{}, challenges:{}", user, challenges);
        List<UserChallenge> userChallenges = new ArrayList<>();
        LocalDate today = LocalDate.now();
        
        for (Challenge challenge : challenges) {
            LocalDate completeDate = today.plusDays(challenge.getDays());
            UserChallenge userChallenge = UserChallenge.builder()
                    .user(user)
                    .challenge(challenge)
                    .assignedDate(today)
                    .completeDate(completeDate)
                    .build();

            userChallengeRepository.save(userChallenge);
            userChallenges.add(userChallenge);
        }

        return userChallenges;
    }
}