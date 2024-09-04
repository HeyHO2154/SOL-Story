package com.eyes.solstory.domain.challenge.dto;

import java.time.LocalDate;
import java.util.List;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Builder
public class UserChallengeRes {
    private int challengeType;
    private String category;
    private int days;
    private String challengeName;
    private int rewardKeys;
    private LocalDate assignedDate;
    private LocalDate completeDate;
    private List<String> top3Category;
}
