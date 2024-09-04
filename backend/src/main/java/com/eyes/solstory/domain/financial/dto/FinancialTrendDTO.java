package com.eyes.solstory.domain.financial.dto;

public interface FinancialTrendDTO {
    String getCategory();
    int getTotalAmount();
    int getTotalAmountBefore();
    int getDifference();
    int getPercentChange();
}
