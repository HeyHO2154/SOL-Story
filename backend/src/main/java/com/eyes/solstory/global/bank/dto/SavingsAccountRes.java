package com.eyes.solstory.global.bank.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class SavingsAccountRes {

    private Header header;
    private Rec rec;

    @Data
    public static class Header {
        private String responseCode;
        private String responseMessage;
        private String apiName;
        private String transmissionDate;
        private String transmissionTime;
        private String institutionCode;
        private String apiKey;
        private String apiServiceCode;
        private String institutionTransactionUniqueNo;
    }

    @Data
    public static class Rec {
        private String bankCode;
        private String bankName;
        private String accountNo;
        private String withdrawalBankCode;
        private String withdrawalAccountNo;
        private String accountName;
        private String interestRate;
        private String subscriptionPeriod;
        private String depositBalance;
        private String accountCreateDate;
        private String accountExpiryDate;
    }
}