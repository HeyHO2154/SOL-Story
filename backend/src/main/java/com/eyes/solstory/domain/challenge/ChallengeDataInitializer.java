package com.eyes.solstory.domain.challenge;

import com.eyes.solstory.domain.challenge.entity.Challenge;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class ChallengeDataInitializer implements ApplicationRunner {

    private List<Challenge> savingChallenges = new ArrayList<>();
    private List<Challenge> spendingChallenges = new ArrayList<>();
    
    public ChallengeDataInitializer() {
    	initializeChallengeData();
    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        initializeChallengeData();
    }

    private void initializeChallengeData() {
        // 저축 챌린지 데이터
        savingChallenges.add(new Challenge(1, 1, "저축", 30, "이번 달 5만원 더 저축하기", 3, 5));
        savingChallenges.add(new Challenge(2, 1, "저축", 7, "이번 주 3만원 더 저축하기", 5, 3));
        savingChallenges.add(new Challenge(3, 1, "저축", 30, "이번 달 7만원 더 저축하기", 4, 7));
        savingChallenges.add(new Challenge(4, 1, "저축", 30, "이번 달 10만원 더 저축하기", 6, 10));
        savingChallenges.add(new Challenge(5, 1, "저축", 30, "이번 달 50만원 더 저축하기", 10, 50));

        // 절약 챌린지 데이터
        spendingChallenges.add(new Challenge(6, 2, "식비", 7, "일주일 동안 전주 대비 식비 3만원 줄이기", 4, 3));
        spendingChallenges.add(new Challenge(7, 2, "식비", 30, "한 달 동안 전달 대비 식비 7만원 줄이기", 6, 3));
        //spendingChallenges.add(new Challenge(2, "배달음식", 7, "일주일 동안 배달 음식 먹지 않기", 4, 3));
        //spendingChallenges.add(new Challenge(2, "배달음식", 30, "한 달 동안 배달 음식 횟수 2회로 줄이기", 4));
        //spendingChallenges.add(new Challenge(2, "배달음식", 30, "한 달 동안 배달 음식 없이 생활하기", 8));
        //spendingChallenges.add(new Challenge(2, "음료", 7, "일주일 동안 커피숍 방문 2회 이하로 줄이기", 4));
        spendingChallenges.add(new Challenge(8, 2, "음료", 7, "일주일 동안 커피숍 대신 집에서 커피값 1만원 줄이기", 2, 1));
        spendingChallenges.add(new Challenge(9, 2, "교통비", 30, "한 달 동안 전달 대비 주유비 5만원 줄이기", 4, 5));
        spendingChallenges.add(new Challenge(10, 2, "교통비", 7, "일주일 동안 주유비 3만원 줄이기", 4, 3));
        //spendingChallenges.add(new Challenge(2, "구독서비스", 30, "사용하지 않는 구독 서비스 1개 취소하기", 6));
        spendingChallenges.add(new Challenge(11, 2, "쇼핑", 30, "한 달 동안 전달 대비 온라인 쇼핑 지출 5만원 줄이기", 4, 5));
        spendingChallenges.add(new Challenge(12, 2, "생활비", 30, "한 달 동안 전달 대비 전기 요금 3만원 줄이기", 6, 3));
        spendingChallenges.add(new Challenge(13, 2, "생활비", 30, "한 달 동안 전달 대비 수도 요금 2만원 줄이기", 4, 2));
        //spendingChallenges.add(new Challenge(2, "물건정리", 30, "한 달 동안 사용하지 않는 물건 2개 중고 마켓으로 판매하기", 6));
        spendingChallenges.add(new Challenge(14, 2, "카드", 30, "전달 대비 카드 값 10만원 줄이기", 7, 10));
        spendingChallenges.add(new Challenge(15, 2, "카드", 30, "전달 대비 카드 값 3만원 줄이기", 3, 3));
        //spendingChallenges.add(new Challenge(2, "무지출", 1, "하루 만원으로 생활하기", 15));
    }

    public List<Challenge> getSavingChallenges() {
        return savingChallenges;
    }

    public List<Challenge> getSpendingChallenges() {
        return spendingChallenges;
    }
}
