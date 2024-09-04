package com.eyes.solstory.domain.challenge.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.eyes.solstory.domain.challenge.dto.UserChallengeRes;
import com.eyes.solstory.domain.challenge.entity.Challenge;
import com.eyes.solstory.domain.challenge.entity.UserChallenge;
import com.eyes.solstory.domain.challenge.service.ChallengeService;
import com.eyes.solstory.domain.challenge.service.UserChallengeService;
import com.eyes.solstory.domain.financial.service.FinancialSummaryAnalyzer;
import com.eyes.solstory.domain.user.entity.User;
import com.eyes.solstory.domain.user.repository.UserRepository;

import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/api/challenge")
@AllArgsConstructor
public class ChallengeController {

    private ChallengeService challengeService;
    private UserRepository userRepository;
    private UserChallengeService userChallengeService;
    private FinancialSummaryAnalyzer financialSummaryAnalyzer;
    private static final Logger logger = LoggerFactory.getLogger(ChallengeController.class.getSimpleName());

    @GetMapping("/list")
    public ResponseEntity<List<UserChallengeRes>> getChallengeList(@RequestParam("email") String email) {
        logger.info("getChallengeList()...email:{}", email);
        User user = userRepository.findUserByEmail(email);
        logger.error("foundUser: {}", user.toString());
        List<Challenge> allChallenges = new ArrayList<>();
        List<UserChallenge> userChallenges = userChallengeService.getAllUserChallengeByCompleteDate(
                LocalDate.now());

        //지출 제일 많은 카테고리 3개
        String[] top3CategoriesArr= financialSummaryAnalyzer.getTop3Categories(user.getUserNo());
        
        List<String> top3Categories = Arrays.asList(top3CategoriesArr);

        if (userChallenges.isEmpty()) {
            //기본 챌린지
            List<Challenge> savingChallenges = challengeService.getRandomSavingChallenges(2);

            //지출 챌린지
            List<Challenge> spendingChallenges = challengeService.getSpendingChallengesForTop3Category(
            		top3CategoriesArr, 3);

            //List<Challenge> spendingChallenges = challengeService.getRandomSpendingChallenges(6);

            allChallenges.addAll(savingChallenges);
            allChallenges.addAll(spendingChallenges);
            userChallenges = challengeService.assignChallengesToUser(user, allChallenges);
        }
        logger.error("userChallenges: {}", userChallenges);

        List<UserChallengeRes> response = new ArrayList<>();
        for (UserChallenge u : userChallenges) {
            UserChallengeRes userChallengeRes = UserChallengeRes.builder()
                    .challengeType(u.getChallenge().getChallengeType())
                    .category(u.getChallenge().getCategory())
                    .days(u.getChallenge().getDays())
                    .challengeName(u.getChallenge().getChallengeName())
                    .rewardKeys(u.getChallenge().getRewardKeys())
                    .assignedDate(u.getAssignedDate())
                    .completeDate(u.getCompleteDate())
                    .top3Category(top3Categories)
                    .build();
            response.add(userChallengeRes);
        }
        return ResponseEntity.ok(response);
    }
}