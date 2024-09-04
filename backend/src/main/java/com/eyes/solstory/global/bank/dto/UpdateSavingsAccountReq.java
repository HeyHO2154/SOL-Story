package com.eyes.solstory.global.bank.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class UpdateSavingsAccountReq {
    private Header header;
    private String accountNo;
    private long transactionBalance;
    private String transactionSummary;
}
