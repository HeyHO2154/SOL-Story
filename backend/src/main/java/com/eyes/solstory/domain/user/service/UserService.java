package com.eyes.solstory.domain.user.service;

import java.net.URI;
import java.net.URISyntaxException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.eyes.solstory.constants.OpenApiUrls;
import com.eyes.solstory.domain.challenge.entity.ChallengeReward;
import com.eyes.solstory.domain.challenge.repository.ChallengeRewardRepository;
import com.eyes.solstory.domain.financial.entity.UserAccount;
import com.eyes.solstory.domain.financial.repository.UserAccountRepository;
import com.eyes.solstory.domain.financial.service.DemandDepositCollector;
import com.eyes.solstory.domain.user.dto.LoginUser;
import com.eyes.solstory.domain.user.dto.UserDto;
import com.eyes.solstory.domain.user.dto.UserRes;
import com.eyes.solstory.domain.user.entity.User;
import com.eyes.solstory.domain.user.repository.UserRepository;
import com.eyes.solstory.global.bank.WebClientUtil;
import com.eyes.solstory.global.bank.dto.SavingsAccountReq;
import com.eyes.solstory.global.bank.dto.SavingsAccountRes;
import com.eyes.solstory.util.OpenApiUtil;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    @Value("${api.key}")
    private String apiKey;
    private final WebClientUtil webClientUtil;
    private final UserRepository userRepository;
    private final UserAccountRepository userAccountRepository;
    private final ChallengeRewardRepository challengeRewardRepository;
    
    private static final Logger logger = LoggerFactory.getLogger(UserService.class.getSimpleName());

    //사용자 계정 생성
    public ResponseEntity<UserRes> createUserAccount(String userId, String email) {
        logger.info("createUserAccount()...userId:{}, email:{}", userId, email);
        ResponseEntity<UserRes> response = webClientUtil.creatUserAccount(email)
                .onErrorMap(e -> new RuntimeException("사용자 계정 생성 중 오류 발생", e))
                .block();

        User user = userRepository.findUserByEmail(email);
        if (user == null) {
            logger.error("signupUser : {}", user.toString());
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(null);
        }

        UserRes userRes = response.getBody();
        if (userRes != null && userRes.getUserKey() != null) {
            logger.error("userResponse : {}, userKey:{}", userRes, userRes.getUserKey());
            user.updateUserKey(userRes.getUserKey());
            userRepository.save(user);
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
        
        return ResponseEntity.ok(userRes);
    }

    // 1원 송금
    public ResponseEntity<String> transferOneWon(
            String accountNo, String email) throws URISyntaxException {
        logger.info("transferOneWon()...accountNo:{}, email:{}", accountNo, email);
        LocalDateTime now = LocalDateTime.now();
        User user = userRepository.findUserByEmail(email);
        logger.error("user:{}", user.toString());
        
        String transmissionDate = LocalDate.now().format(OpenApiUtil.DATE_FORMATTER);
        String transmissionTime = LocalDateTime.now().format(OpenApiUtil.TIME_FORMATTER);

        Map<String, String> header = OpenApiUtil.createHeaders("04e988f2-d086-495a-aa2f-67b0e911782f", OpenApiUrls.OPEN_ACCOUNT_AUTH);

        Map<String, Object> request = new HashMap<>();
        request.put("Header", header);
        request.put("accountNo", accountNo);
        request.put("authText", "SSAFY");

        ResponseEntity<String> response = OpenApiUtil.callApi(new URI(OpenApiUrls.ACCOUNT_AUTH_URL + OpenApiUrls.OPEN_ACCOUNT_AUTH), request);
        ObjectMapper objectMapper = new ObjectMapper();
        
        String transactionUniqueNo = "";
        try {
            JsonNode rootNode = objectMapper.readTree(response.getBody());
            transactionUniqueNo = rootNode.path("REC").path("transactionUniqueNo").asText();
        } catch (Exception e) {
            throw new RuntimeException("err", e);
        }
        
        header = OpenApiUtil.createHeaders("04e988f2-d086-495a-aa2f-67b0e911782f", OpenApiUrls.INQUIRE_TRANSACTION_HISTORY);

        request = new HashMap<>();
        request.put("Header", header);
        request.put("accountNo", accountNo);
        request.put("transactionUniqueNo", transactionUniqueNo);
        
        response = OpenApiUtil.callApi(new URI(OpenApiUrls.DEMAND_DEPOSIT_URL + OpenApiUrls.INQUIRE_TRANSACTION_HISTORY), request);
        logger.error("response:{}", response);
        try {
            JsonNode rootNode = objectMapper.readTree(response.getBody());
            String summary = rootNode.path("REC").path("transactionSummary").asText();
            int code = Integer.parseInt(summary.substring(6));
            System.out.println("summary :"+code);
        } catch (Exception e) {
            throw new RuntimeException("err", e);
        }
        
        
        return ResponseEntity.ok(response.getBody());
    }

    @Autowired
    DemandDepositCollector demandDepositCollector;
    // 1원 검증
    public ResponseEntity<String> verifyOneWon(String accountNo, String authCode, String email) throws URISyntaxException {
        logger.info("verifyOneWon()...accountNo:{}, authCode:{}, email:{}", accountNo, authCode, email);
        User user = userRepository.findUserByEmail(email);
        logger.error("user:{}", user.toString());
        Map<String, String> header = OpenApiUtil.createHeaders(user.getUserKey(), OpenApiUrls.CHECK_ACCOUNT_AUTH);
        
        Map<String, Object> request = new HashMap<>();
        request.put("Header", header);
        request.put("accountNo", accountNo);
        request.put("authText", "SSAFY");
        request.put("authCode", authCode);
        
        ResponseEntity<String> response = OpenApiUtil.callApi(new URI(OpenApiUrls.ACCOUNT_AUTH_URL + OpenApiUrls.CHECK_ACCOUNT_AUTH), request);
        logger.error("verifyOneWonApiResponse:{}", response);
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            JsonNode rootNode = objectMapper.readTree(response.getBody());
            String status = rootNode.path("REC").path("status").asText(); //SUCCESS
        } catch (Exception e) {
            throw new RuntimeException("err", e);
        }
        return ResponseEntity.ok(response.getBody());
    }

    // 적금 계좌 생성
    public ResponseEntity<SavingsAccountRes> createSavingAccount(String accountTypeUniqueNo, String withdrawalAccountNo, 
    		long depositBalance, String userId, int targetAmount) {
        logger.info("createSavingAccount()...accountTypeUniqueNo:{}, withdrawalAccountNo:{}, depositBalance:{}, userId:{}, targetAmount:{}", accountTypeUniqueNo, withdrawalAccountNo, depositBalance, userId, targetAmount);
        User user = userRepository.findUserByUserId(userId);
        logger.error("user:{}", user.toString());
        String transmissionDate = LocalDate.now().format(OpenApiUtil.DATE_FORMATTER);
        String transmissionTime = LocalDateTime.now().format(OpenApiUtil.TIME_FORMATTER);

        SavingsAccountReq.Header header = SavingsAccountReq.Header.builder()
                .apiName("createAccount")
                .transmissionDate(transmissionDate)
                .transmissionTime(transmissionTime)
                .institutionCode("00100")
                .fintechAppNo("001")
                .apiServiceCode("createAccount")
                .institutionTransactionUniqueNo("20240101121212123456")
                .apiKey(apiKey)
                .userKey(user.getUserKey())
                .build();
        SavingsAccountReq request = SavingsAccountReq.builder()
                .header(header)
                .accountTypeUniqueNo(accountTypeUniqueNo)
                .withdrawalAccountNo(withdrawalAccountNo)
                .depositBalance(depositBalance)
                .build();

        ResponseEntity<SavingsAccountRes> response = webClientUtil.createSavingAccount(request)
                .onErrorMap(e -> new RuntimeException("적금 계좌 생성 중 오류 발생", e))
                .block();

        logger.error("createSavingAccountApiResponse : {}", response.toString());
        if (response == null || response.getStatusCode() != HttpStatus.OK) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }

        SavingsAccountRes.Rec rec = response.getBody().getRec();
        UserAccount userAccount = UserAccount.builder()
                .accountNo(rec.getAccountNo())
                .user(user)
                .accountType(1)
                .accountName(rec.getAccountName())
                .targetAmount(targetAmount)
                .regDate(LocalDate.now())
                .endDate(LocalDate.parse(rec.getAccountExpiryDate()))
                .isActive(1)
                .build();

        userAccountRepository.save(userAccount);
        ChallengeReward challengeReward = ChallengeReward.builder().userNo(user.getUserNo()).keys(0).build();
        challengeRewardRepository.save(challengeReward);

        return ResponseEntity.ok(response.getBody());
    }

    public ResponseEntity<String> searchUserkey(String email) {
        logger.info("searchUserkey()...email:{}", email);
        return ResponseEntity.ok(userRepository.findUserByEmail(email).getUserKey());
    }
    
    
    
    
    /////////////gabin
    
    //회원가입 때 쓸 메소드
    public User saveUser(UserDto userDto) {
    	logger.info("saveUser()...{}", userDto.toString());
    	System.out.println(userDto);
    	User user = User.builder()
    			.userId(userDto.getUserId())
    			.password(userDto.getPassword())
    	        .userName(userDto.getUserName())
    	        .email(userDto.getEmail())
    	        .gender(userDto.getGender())
    	        .birth(userDto.transDateFormatyyyyMMdd(userDto.getBirth())) //변환필요
    	        .joinDate(LocalDate.now())
    			.build();
    	logger.info("user ...{}", user.toString());
    	userRepository.save(user);
        return user;
    }
    
    //이메일을 가지고 아이디 구하기. 계정찾기페이지에서 사용하여 비밀번호 변경페이지에 넘겨줄 것.
    public String findUserIdByEmail(String email) {
        logger.info("findUserIdByEmail()...email:{}", email);
        User user = userRepository.findUserByEmail(email);
        return user != null ? user.getUserId() : null;
    }
    
    //로그인 인증
    public LoginUser authenticate(String username, String password) {
    	logger.info("anthenticate()...username:{}, password:{}", username, password);
        return userRepository.login(username, password);
	}
    
    //유저 넘버 구하기
    public int getUserNo(User user) {
        logger.info("getUserNo()...user:{}", user.toString());
        //저장된 회원의 user_no을 조회하여서
        User userforNumber = userRepository.findByUserId(user.getUserId());
        //그 회원의 user_no를 반환해주기
        return userforNumber.getUserNo();
    }
}