package com.eyes.solstory.domain.challenge.service;

import java.time.LocalDate;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eyes.solstory.domain.challenge.entity.Challenge;
import com.eyes.solstory.domain.challenge.entity.ChallengeReward;
import com.eyes.solstory.domain.challenge.entity.UserChallenge;
import com.eyes.solstory.domain.challenge.repository.ChallengeRepository;
import com.eyes.solstory.domain.challenge.repository.ChallengeRewardRepository;
import com.eyes.solstory.domain.challenge.repository.UserChallengeRepository;
import com.eyes.solstory.domain.financial.repository.FinancialSummaryRepository;
import com.eyes.solstory.global.exception.UserChallengeNotFoundException;

import lombok.RequiredArgsConstructor;
	
@Service
@RequiredArgsConstructor
public class UserChallengeService {

	@Autowired
    private ChallengeRepository ChallengeRepository;
	@Autowired
    private UserChallengeRepository userChallengeRepository;
	@Autowired
    private ChallengeRewardRepository challengeRewardRepository;
	@Autowired
    private FinancialSummaryRepository financialSummaryRepository;
    private static final Logger logger = LoggerFactory.getLogger(UserChallengeScheduler.class.getSimpleName());
    

    // 매일 자정에 전달이 만료일인 챌린지 달성 여부 확인
    public void checkAndRewardExpiredChallenges() {
        logger.info("checkAndRewardExpiredChallenges()");
        LocalDate yesterday = LocalDate.now().minusDays(1);
        List<UserChallenge> expiredChallenges = userChallengeRepository.findAllByCompleteDate(yesterday);
        logger.error("expiredChallenges:{}", expiredChallenges);
        for (UserChallenge userChallenge : expiredChallenges) {
            boolean isCompleted = checkChallengeCompletion(userChallenge);

            if (isCompleted) {
            	
            	Challenge challenge = ChallengeRepository.findByChallengeNo(userChallenge.getChallenge().getChallengeNo());
            	
                rewardUser(userChallenge.getUser().getUserNo(), challenge.getRewardKeys());
            }
            userChallengeRepository.delete(userChallenge);
        }
    }

    // 챌린지 달성 여부 확인
    private boolean checkChallengeCompletion(UserChallenge userChallenge) {
        logger.info("checkChallengeCompletion()...userChallenge:{}", userChallenge);
        
        
        Challenge challenge = userChallenge.getChallenge();
        String category = challenge.getCategory();
        int userNo = userChallenge.getUser().getUserNo();

        // 현재 달의 시작일과 종료일
        LocalDate startDateCurrent = LocalDate.now().minusDays(challenge.getDays());
        LocalDate endDateCurrent = LocalDate.now();

        // 이전 달의 시작일과 종료일
        LocalDate startDatePrevious = startDateCurrent.minusDays(challenge.getDays());
        LocalDate endDatePrevious = startDatePrevious.minusDays(challenge.getDays());

        // 현재 달의 총액
        Integer totalAmountCurrent = financialSummaryRepository.findTotalAmountByCategoryInLast30Days(
                userNo, category, startDateCurrent, endDateCurrent);

        // 이전 달의 총액
        Integer totalAmountPrevious = financialSummaryRepository.findTotalAmountByCategoryInLast30Days(
                userNo, category, startDatePrevious, endDatePrevious);

        totalAmountCurrent = totalAmountCurrent != null ? totalAmountCurrent : 0;
        totalAmountPrevious = totalAmountPrevious != null ? totalAmountPrevious : 0;
        logger.error("totalAmountCurrent:{}", totalAmountCurrent);
        logger.error("totalAmountCurrent:{}", totalAmountCurrent);

        // 저축 챌린지: 현재 달이 목표 금액 이상 저축했는지 확인
        if (challenge.getChallengeType() == 1) {
            return totalAmountCurrent >= (totalAmountPrevious + challenge.getTargetAmount());
        }
        // 절약 챌린지: 현재 달 지출이 이전 달보다 줄었는지 확인
        if (challenge.getChallengeType() == 2) {
            return totalAmountCurrent <= (totalAmountPrevious - challenge.getTargetAmount());
        }
        return false;
    }

    private void rewardUser(int userNo, int rewardKeys) {
        logger.info("rewardUser()...userNo:{}, rewardKeys:{}", userNo, rewardKeys);
        ChallengeReward challengeReward = challengeRewardRepository.findChallengeRewardByUserNo(userNo);
        logger.error("challengeReward:{}", challengeReward);
        if (challengeReward != null) {
            challengeReward.updateKeys(challengeReward.getKeys() + rewardKeys);
            challengeRewardRepository.save(challengeReward);
        }
    }

    /////////////////////////////// 수정
    public UserChallenge getUserChallengesStatus(int userNo) {
        logger.info("getUserChallengesStatus()...userNo:{}", userNo);
        UserChallenge userChallenge = userChallengeRepository.findByUser_UserNo(userNo);
        logger.error("userChallenge:{}", userChallenge);
        if(userChallenge == null) {
            throw new UserChallengeNotFoundException("해당하는 챌린지가 없습니다.");
        }
        // 오늘 날짜와 도전 과제의 할당 날짜 및 종료 날짜를 비교
        LocalDate today = LocalDate.now();
        //LocalDate endDate = userChallenge.getAssignedDate().plusDays(userChallenge.getChallenge().getDays() - 1);
        LocalDate endDate = userChallenge.getCompleteDate();

        if (!today.isBefore(userChallenge.getAssignedDate()) && !today.isAfter(endDate)) {
            return userChallenge;
        } else {
            return null;
        }
    }

    public List<UserChallenge> getAllUserChallengeByCompleteDate(LocalDate completeDate) {
        logger.info("getAllUserChallengeByCompleteDat()...completeDate:{}", completeDate);
        return userChallengeRepository.findAllByCompleteDate(LocalDate.now());
    }
}
