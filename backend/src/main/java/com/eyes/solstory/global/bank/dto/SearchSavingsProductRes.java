package com.eyes.solstory.global.bank.dto;

import java.util.List;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Data
public class SearchSavingsProductRes {
    private HeaderDTO Header;
    private List<Rec> REC;

    public static class HeaderDTO {
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

    public static class Rec {
        private String accountTypeUniqueNo;
        private String bankCode;
        private String bankName;
        private String accountTypeCode;
        private String accountTypeName;
        private String accountName;
        private String accountDescription;
        private String subscriptionPeriod;
        private String minSubscriptionBalance;
        private String maxSubscriptionBalance;
        private String interestRate;
        private String rateDescription;
    }
}