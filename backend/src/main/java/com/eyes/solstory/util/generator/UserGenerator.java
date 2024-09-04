package com.eyes.solstory.util.generator;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Random;

public class UserGenerator {
	
	public static void main(String[] args) {
        StringBuilder sb = new StringBuilder();
        Random random = new Random();

        DateTimeFormatter birthFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        DateTimeFormatter joinFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        String[] nameChars = {"가", "강", "경", "고", "구", "권", "김", "나", "남", "노", "도", "류", "문", "박", "배", 
                "백", "서", "석", "손", "송", "신", "안", "양", "여", "오", "우", "유", "윤", "이", "임",
                "장", "전", "정", "조", "최", "하", "한", "홍", "황", "강", "고", "남", "배", "성", "안",
                "양", "오", "유", "윤", "이", "장", "전", "정", "조", "최", "하", "한", "현", "홍", "황"};
        
        for (int i = 1; i <= 100; i++) {
            // Generate random user data
            String userId = "user" + i;
            String password = "pass"; //
            String userName = nameChars[random.nextInt(nameChars.length)] + nameChars[random.nextInt(nameChars.length)] + nameChars[random.nextInt(nameChars.length)];
            String email = "user" + i + "@shinhan.ssafy.com";
            String gender = random.nextBoolean() ? "male" : "female";
            String birth = LocalDate.of(random.nextInt(20) + 1980, random.nextInt(12) + 1, random.nextInt(28) + 1)
                                    .format(birthFormatter);
            String apiKey = "04e988f2-d086-495a-aa2f-67b0e911782f"; //내꺼로 계좌를 발급받았으니까^^
            String joinDate = LocalDate.now().minusDays(random.nextInt(365 * 5)).format(joinFormatter); // Join date within last 5 years

            sb.append("INSERT INTO users (user_no, user_id, password, user_name, email, gender, birth, user_key, join_date, character_img_path) VALUES (")
              .append(i).append(", '")
              .append(userId).append("', '")
              .append(password).append("', '")
              .append(userName).append("', '")
              .append(email).append("', '")
              .append(gender).append("', '")
              .append(birth).append("', '")
              .append(apiKey).append("', '")
              .append(joinDate).append("', NULL);")
              .append(System.lineSeparator());
        }

        System.out.println(sb.toString());
    }

}
