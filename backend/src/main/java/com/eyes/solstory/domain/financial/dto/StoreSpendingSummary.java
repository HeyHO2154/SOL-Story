package com.eyes.solstory.domain.financial.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StoreSpendingSummary implements StoreSpendingSummaryDTO {
	private String storeName;
    private int visitCount;
    private int totalAmount;
}
