package com.eyes.solstory.global.bank.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
@Data
@Getter
@Setter
public class UpdateSavingsAccountRes {
    private Header header;
    private Rec rec;

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
    public static class Rec {
        private String transactionUniqueNo;
        private String transactionDate;
    }
}