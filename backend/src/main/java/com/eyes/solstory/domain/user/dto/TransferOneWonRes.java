package com.eyes.solstory.domain.user.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class TransferOneWonRes {
    private Header header;
    private REC rec;

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
    public static class REC {
        private Long transactionUniqueNo;
        private String accountNo;
    }
}
