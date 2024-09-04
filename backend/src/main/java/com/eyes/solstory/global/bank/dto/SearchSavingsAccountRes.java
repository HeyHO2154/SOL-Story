package com.eyes.solstory.global.bank.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class SearchSavingsAccountRes {
    private Header header;
    private RecDto rec;
    @Data
    public class Header {
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
    public static class RecDto {
        private String bankCode;
        private String bankName;
        private String userName;
        private String accountNo;
        private String accountName;
        private String accountDescription;
        private String withdrawalBankCode;
        private String withdrawalBankName;
        private String withdrawalAccountNo;
        private String subscriptionPeriod;
        private String depositBalance;
        private String interestRate;
        private String installmentNumber;
        private String totalBalance;
        private String accountCreateDate;
        private String accountExpiryDate;
    }
}
