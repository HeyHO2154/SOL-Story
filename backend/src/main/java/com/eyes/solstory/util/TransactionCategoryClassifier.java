package com.eyes.solstory.util;

import java.util.HashMap;
import java.util.Map;

public class TransactionCategoryClassifier {
    
	private static final Map<String, String> keywordToSpendingCategory = new HashMap<>();
    static {
        // 카테고리 키워드 맵핑
    	// 식사 (Dining Out) (마트 식비 포함)
        keywordToSpendingCategory.put("마트", "외식/식사");
        keywordToSpendingCategory.put("식품", "외식/식사");
        keywordToSpendingCategory.put("채소", "외식/식사");
        keywordToSpendingCategory.put("생선", "외식/식사");
        keywordToSpendingCategory.put("신선", "외식/식사");
        keywordToSpendingCategory.put("식당", "외식/식사");
        keywordToSpendingCategory.put("김치", "외식/식사");
        keywordToSpendingCategory.put("그릴", "외식/식사");
        keywordToSpendingCategory.put("도시락", "외식/식사");
        keywordToSpendingCategory.put("피자", "외식/식사");
        keywordToSpendingCategory.put("치킨", "외식/식사");
        keywordToSpendingCategory.put("국밥", "외식/식사");
        keywordToSpendingCategory.put("냉면", "외식/식사");
        keywordToSpendingCategory.put("샌드위치", "외식/식사");
        keywordToSpendingCategory.put("레스토랑", "외식/식사");
        keywordToSpendingCategory.put("파스타", "외식/식사");
        keywordToSpendingCategory.put("마켓컬리", "외식/식사");
        
        // 배달
        keywordToSpendingCategory.put("배달", "배달");
        keywordToSpendingCategory.put("요기요", "배달");
        keywordToSpendingCategory.put("배달의민족", "배달");
        keywordToSpendingCategory.put("쿠팡잇츠", "배달");
        
        // 카페/디저트
        keywordToSpendingCategory.put("카페", "카페/디저트");
        keywordToSpendingCategory.put("투썸", "카페/디저트");
        keywordToSpendingCategory.put("스타벅스", "카페/디저트");
        keywordToSpendingCategory.put("커피", "카페/디저트");
        keywordToSpendingCategory.put("디저트", "카페/디저트");
        keywordToSpendingCategory.put("설빙", "카페/디저트");

        // 주유 (Fuel/Gasoline)
        keywordToSpendingCategory.put("주유소"  , "주유");
        keywordToSpendingCategory.put("오일"   , "주유");
        keywordToSpendingCategory.put("고속도로", "주유");

        // 교통비 (Transportation)
        keywordToSpendingCategory.put("버스", "교통비");
        keywordToSpendingCategory.put("지하철", "교통비");
        keywordToSpendingCategory.put("택시", "교통비");
        keywordToSpendingCategory.put("기차", "교통비");
        keywordToSpendingCategory.put("KTX", "교통비");
        keywordToSpendingCategory.put("GTX", "교통비");
        keywordToSpendingCategory.put("ITX", "교통비");
        keywordToSpendingCategory.put("공항", "교통비");

        // 쇼핑 (Shopping - General)
        keywordToSpendingCategory.put("쇼핑몰", "쇼핑");
        keywordToSpendingCategory.put("패션", "쇼핑");
        keywordToSpendingCategory.put("백화점", "쇼핑");
        keywordToSpendingCategory.put("이커머스", "쇼핑");
        keywordToSpendingCategory.put("쿠팡", "쇼핑");

        // 패션/의류 (Clothing & Accessories)
        keywordToSpendingCategory.put("패션", "패션/의류");
        keywordToSpendingCategory.put("의류", "패션/의류");
        keywordToSpendingCategory.put("트렌드", "패션/의류");
        keywordToSpendingCategory.put("잡화", "패션/의류");
        keywordToSpendingCategory.put("쥬얼리", "패션/의류");
        keywordToSpendingCategory.put("모자", "패션/의류");

        // 가전/전자제품 (Electronics & Appliances)
        keywordToSpendingCategory.put("전자", "가전/전자제품");
        keywordToSpendingCategory.put("디지털", "가전/전자제품");
        keywordToSpendingCategory.put("가전제품", "가전/전자제품");
        keywordToSpendingCategory.put("컴퓨터", "가전/전자제품");
        keywordToSpendingCategory.put("스마트기기", "가전/전자제품");

        // 여행/휴가 (Travel & Vacation)
        keywordToSpendingCategory.put("트래블", "여행/휴가");
        keywordToSpendingCategory.put("휴가", "여행/휴가");
        keywordToSpendingCategory.put("항공", "여행/휴가");
        keywordToSpendingCategory.put("여행", "여행/휴가");
        keywordToSpendingCategory.put("투어", "여행/휴가");
        keywordToSpendingCategory.put("숙박", "여행/휴가");
        keywordToSpendingCategory.put("호텔", "여행/휴가");

        // 건강/의료비 (Healthcare & Medical)
        keywordToSpendingCategory.put("메디컬", "건강/의료비");
        keywordToSpendingCategory.put("병원", "건강/의료비");
        keywordToSpendingCategory.put("약국", "건강/의료비");
        keywordToSpendingCategory.put("검진", "건강/의료비");
        keywordToSpendingCategory.put("의료기기", "건강/의료비");
        keywordToSpendingCategory.put("영양제", "건강/의료비");

        // 주거비 (Housing/Rent/Mortgage)
        keywordToSpendingCategory.put("부동산", "주거비");
        keywordToSpendingCategory.put("월세", "주거비");
        keywordToSpendingCategory.put("아파트", "주거비");
        keywordToSpendingCategory.put("주택", "주거비");

        // 통신비 (Phone & Internet)
        keywordToSpendingCategory.put("통신", "통신비");
        keywordToSpendingCategory.put("핸드폰", "통신비");
        keywordToSpendingCategory.put("인터넷", "통신비");
        keywordToSpendingCategory.put("모바일", "통신비");
        keywordToSpendingCategory.put("와이파이", "통신비");

        // 엔터테인먼트 (Entertainment - Movies, Concerts, etc.)
        keywordToSpendingCategory.put("영화", "엔터테인먼트");
        keywordToSpendingCategory.put("콘서트", "엔터테인먼트");
        keywordToSpendingCategory.put("연극", "엔터테인먼트");
        keywordToSpendingCategory.put("뮤직", "엔터테인먼트");
        keywordToSpendingCategory.put("게임", "엔터테인먼트");
        keywordToSpendingCategory.put("노래", "엔터테인먼트");
        
        // OTT
        keywordToSpendingCategory.put("구독", "OTT");
        keywordToSpendingCategory.put("유튜브", "OTT");
        keywordToSpendingCategory.put("아프리카TV", "OTT");
        keywordToSpendingCategory.put("치지직", "OTT");
        keywordToSpendingCategory.put("넷플릭스", "OTT");
        keywordToSpendingCategory.put("디즈니플러스", "OTT");
        keywordToSpendingCategory.put("티빙", "OTT");
        keywordToSpendingCategory.put("왓챠", "OTT");
        keywordToSpendingCategory.put("웨이브", "OTT");

        // 스포츠/레저 (Sports & Leisure)
        keywordToSpendingCategory.put("스포츠", "스포츠/레저");
        keywordToSpendingCategory.put("수영", "스포츠/레저");
        keywordToSpendingCategory.put("볼링", "스포츠/레저");
        keywordToSpendingCategory.put("클라이밍", "스포츠/레저");
        keywordToSpendingCategory.put("헬스장", "스포츠/레저");
        keywordToSpendingCategory.put("레저", "스포츠/레저");
        keywordToSpendingCategory.put("피트니스", "스포츠/레저");
        keywordToSpendingCategory.put("골프", "스포츠/레저");

        // 교육비 (Education & Tuition)
        keywordToSpendingCategory.put("학원", "교육비 ");
        keywordToSpendingCategory.put("교육", "교육비 ");
        keywordToSpendingCategory.put("유학원", "교육비 ");
        keywordToSpendingCategory.put("강의", "교육비 ");

        // 자동차 유지비 (Car Maintenance & Repairs)
        keywordToSpendingCategory.put("정비소", "자동차 유지비");
        keywordToSpendingCategory.put("타이어", "자동차 유지비");
        keywordToSpendingCategory.put("카센터", "자동차 유지비");
        keywordToSpendingCategory.put("세차장", "자동차 유지비");
        keywordToSpendingCategory.put("엔진오일", "자동차 유지비");

        // 가구/인테리어 (Furniture & Home Decor)
        keywordToSpendingCategory.put("가구", "가구/인테리어");
        keywordToSpendingCategory.put("인테리어", "가구/인테리어");
        keywordToSpendingCategory.put("침대", "가구/인테리어");
        keywordToSpendingCategory.put("커튼", "가구/인테리어");
        keywordToSpendingCategory.put("리빙", "가구/인테리어");

        // 미용/화장품 (Beauty & Cosmetics)
        keywordToSpendingCategory.put("뷰티", "미용/화장품");
        keywordToSpendingCategory.put("헤어", "미용/화장품");
        keywordToSpendingCategory.put("코스메틱", "미용/화장품");
        keywordToSpendingCategory.put("네일아트", "미용/화장품");
        keywordToSpendingCategory.put("화장품", "미용/화장품");
        keywordToSpendingCategory.put("스킨케어", "미용/화장품");
        keywordToSpendingCategory.put("올리브영", "미용/화장품");

        // 보험료 (Insurance Premiums)
        keywordToSpendingCategory.put("보험", "보험료");
        keywordToSpendingCategory.put("연금", "보험료");

        // 유틸리티 (Utilities - Electricity, Water, etc.)
        keywordToSpendingCategory.put("전기", "유틸리티");
        keywordToSpendingCategory.put("수도", "유틸리티");
        keywordToSpendingCategory.put("가스", "유틸리티");
        keywordToSpendingCategory.put("난방", "유틸리티");

        // 모임/경조사비 (Social Events & Gifts)
        keywordToSpendingCategory.put("꽃배달", "모임/경조사비");
        keywordToSpendingCategory.put("화환", "모임/경조사비");
        keywordToSpendingCategory.put("선물", "모임/경조사비");
        keywordToSpendingCategory.put("모임", "모임/경조사비");
        keywordToSpendingCategory.put("경조사", "모임/경조사비");
        keywordToSpendingCategory.put("이벤트", "모임/경조사비");
    }
    
    private static final Map<String, String> keywordToWithdrawalCategory = new HashMap<>();
    static {
    	// 당근수익
    	keywordToWithdrawalCategory.put("중고", "당근수익");
    	keywordToWithdrawalCategory.put("당근", "당근수익");
    }

    // 지출 카테고리 분류
    public static String spendingClassify(String storeName) {
        // 키워드 기반 카테고리 분류
        for (Map.Entry<String, String> entry : keywordToSpendingCategory.entrySet()) {
            if (storeName.contains(entry.getKey())) {
                return entry.getValue();
            }
        }
        return "기타";  // 해당하는 카테고리가 없을 경우 모두 기타로 분류
    }
    
    // 수입 카테고리 분류
    public static String incomeClassify(String keyword) {
        for (Map.Entry<String, String> entry : keywordToWithdrawalCategory.entrySet()) {
            if (keyword.contains(entry.getKey())) {
                return entry.getValue();
            }
        }
        return "기타";  // 해당하는 카테고리가 없을 경우 모두 기타로 분류
    }
    
    /**
     * 해당 지출처 카테고리가 찾고자 하는 카테고리가 맞는지
     * @param storeName 지출처
     * @return 해당 카테고리면 true, 아니면 false
     */
    public static boolean isCategory(String storeName, String category) {
    	for (Map.Entry<String, String> entry : keywordToWithdrawalCategory.entrySet()) {
    		// 카테고리 먼저 찾고 검사하는 가게가 그 카테고리인지 확인 
            if (category.equals(entry.getValue()) && storeName.contains(entry.getKey())) {
                return true;
            }
        }
    	return false;
    }
    
    /**
     * 카테고리에 해당하는 지출처의 내 키워드 반환
     * @param storeName 지출처
     * @return 해당 카테고리면 키워드 반환
     */
    public static String keyword(String storeName, String category) {
    	for (Map.Entry<String, String> entry : keywordToWithdrawalCategory.entrySet()) {
    		// 카테고리 먼저 찾고 검사하는 가게가 그 카테고리인지 확인 
            if (category.equals(entry.getValue()) && storeName.contains(entry.getKey())) {
                return entry.getKey();
            }
        }
    	return null;
    }
}