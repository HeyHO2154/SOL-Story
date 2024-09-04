package com.eyes.solstory.util.generator;

import java.util.ArrayList;
import java.util.List;

import com.eyes.solstory.domain.financial.dto.StoreSpendingSummary;

public class DataGenerator {
	
	static public List<StoreSpendingSummary> cafesIn(){
		 List<StoreSpendingSummary> list = new ArrayList<>();
		 list.add(StoreSpendingSummary.builder().storeName("투썸플레이스").visitCount(3).totalAmount(72000).build());
		 list.add(StoreSpendingSummary.builder().storeName("스타벅스").visitCount(5).totalAmount(58000).build());
		 list.add(StoreSpendingSummary.builder().storeName("바나프레소").visitCount(15).totalAmount(52000).build());
		 list.add(StoreSpendingSummary.builder().storeName("커피빈").visitCount(2).totalAmount(24000).build());
		 list.add(StoreSpendingSummary.builder().storeName("메가커피").visitCount(5).totalAmount(9000).build());
		 return list;
	}
	
	static public int getSavingsBalane(int order) {
		List<Integer> list = new ArrayList<>();
		list.add(0); //0
		list.add(2700000);
		list.add(3500000);
		list.add(1200000);
		list.add(8500000);
		list.add(440000);
		list.add(500000);
		list.add(750000);
		list.add(200000);
		list.add(9000000);
		list.add(12000000);
		return list.get(order);
	}
}
