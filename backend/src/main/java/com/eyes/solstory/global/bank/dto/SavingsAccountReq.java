package com.eyes.solstory.global.bank.dto;

import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
@Builder
public class SavingsAccountReq {
    private Header header;
    private String accountTypeUniqueNo;

    private String withdrawalAccountNo;
    private long depositBalance;
    @Data
    @Builder
    public static class Header {
        private String apiName;
        private String transmissionDate;
        private String transmissionTime;
        private String institutionCode;
        private String fintechAppNo;
        private String apiServiceCode;
        private String institutionTransactionUniqueNo;
        private String apiKey;
        private String userKey;
    }

    @Override
    public String toString() {
        return "SavingsAccountReq{" +
                "header=" + header +
                ", accountTypeUniqueNo='" + accountTypeUniqueNo + '\'' +
                ", withdrawalAccountNo='" + withdrawalAccountNo + '\'' +
                ", depositBalance=" + depositBalance +
                '}';
    }
}