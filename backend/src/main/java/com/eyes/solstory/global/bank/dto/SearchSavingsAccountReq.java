package com.eyes.solstory.global.bank.dto;

import lombok.Data;

@Data
public class SearchSavingsAccountReq {
    private Header header;
    private String accountNo;

    @Data
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
}