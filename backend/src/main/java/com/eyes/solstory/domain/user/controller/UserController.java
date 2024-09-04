package com.eyes.solstory.domain.user.controller;

import java.net.URISyntaxException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.eyes.solstory.domain.user.dto.LoginUser;
import com.eyes.solstory.domain.user.dto.UserDto;
import com.eyes.solstory.domain.user.dto.UserRes;
import com.eyes.solstory.domain.user.entity.User;
import com.eyes.solstory.domain.user.repository.UserRepository;
import com.eyes.solstory.domain.user.service.UserService;
import com.eyes.solstory.global.bank.dto.SavingsAccountRes;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api")
public class UserController {
   
	private final UserService userService;
	private final UserRepository userRepository;

	private static final Logger logger = LoggerFactory.getLogger(UserController.class.getSimpleName());	

    // 사용자 계정 생성
    @PostMapping("/user/account")
    public ResponseEntity<UserRes> createUserAccount(@RequestParam("userId") String userId, @RequestParam("email") String email) {
        logger.info("createUserAccount()...userId:{}, email:{}", userId, email);
        return userService.createUserAccount(userId, email);
    }


    // 1원 송금
    @PostMapping("/transfer/one_won")
    public ResponseEntity<String> transferOneWon(
            @RequestParam("accountNo") String accountNo,
            @RequestParam("email") String email) throws URISyntaxException {
        logger.info("transferOneWon()...accountNo:{}, email:{}", accountNo, email);
        return userService.transferOneWon(accountNo, email);
    }

    // 1원 검증
    @PostMapping("/verify/one_won")
    public ResponseEntity<String> verifyOneWon(
            @RequestParam("accountNo") String accountNo,
            @RequestParam("authCode") String authCode,
            @RequestParam("email") String email) throws URISyntaxException {
        logger.info("verifyOneWon()...accountNo: {}, authCode: {}, email:{}", accountNo, authCode, email);
        return userService.verifyOneWon(accountNo, authCode, email);
    }

    // 적금 계좌 생성
    @PostMapping("/savings/account")
    public ResponseEntity<SavingsAccountRes> createSavingAccount(
            @RequestParam("accountTypeUniqueNo") String accountTypeUniqueNo,
            @RequestParam("withdrawalAccountNo") String withdrawalAccountNo,
            @RequestParam("depositBalance") long depositBalance,
            @RequestParam("userId") String userId,
            @RequestParam("targetAmount") int targetAmount) {
        logger.info("createSavingAccount()...accountTypeUniqueNo: {}, withdrawalAccountNo: {}, depositBalance: {}, userId: {}, targetAmount: {}",
                accountTypeUniqueNo, withdrawalAccountNo, depositBalance, userId, targetAmount);
        return userService.createSavingAccount(accountTypeUniqueNo, withdrawalAccountNo, depositBalance, userId, targetAmount);
    }

    //userkey 조회
    @GetMapping("/userkey")
    public ResponseEntity<String> searchUserkey(@RequestParam("email") String email) {
        logger.info("searchUserkey()...{}", email);
    	return userService.searchUserkey(email);
    }
    
    
    
    // 회원가입 - 결과반환
    // 회원가입과 동시에 userKey 생성해서 바로 insert into User
    @PostMapping("/signup")
    public ResponseEntity<?> signUp(@RequestBody UserDto userDto) {
    	logger.info("signup()...{}", userDto.toString());
		User user = userService.saveUser(userDto);
		if(user != null) {
            logger.error("signupUser : {}", user.toString());
            ResponseEntity.ok().build();
        }
		return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
    }
    
    //이메일을 가지고 유저가 존재하는지 확인하는 용도
    @GetMapping("/getUserIdByEmail")
    public ResponseEntity<String> getUserIdByEmail(@RequestParam String email) {
        logger.info("getUserIdByEmail()...{}", email);
        String user_id = userService.findUserIdByEmail(email);
        if (user_id != null) {
            logger.error("foundUserId: {}", user_id);
            return ResponseEntity.ok(user_id);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }
    }

    
    

    /**
     * 
     * @param loginRequest
     * @return
     * 
     * LoginRes (json 형태)
     * {	"loginResult"  : true,  // false
     * 		"loginUser" : {  //null
     * 						"userNo" 	: 1,
     * 						"userName"  : "지히",
     * 						"email"		: "chaehee13@naver.com"
     * 					  }
     * } 
     */
    //로그인페이지에서 "로그인"클릭 시, no 그대로 메인화면 페이지에 넘겨줌.
    @PostMapping(value = "/login", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<LoginUser> login(@RequestBody User loginRequest) {
    	logger.info("login()...{}", loginRequest.toString());
    	LoginUser user = userService.authenticate(loginRequest.getUserId(), loginRequest.getPassword());
	    if (user != null) {
            // 성공적으로 user를 반환
	    	logger.error("loginUser : {}", user.toString());
            return ResponseEntity.ok(user);
        } else {
            logger.error("user does not exist");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
	 }
     
     //아이디 중복확인 - 유저 아이디가 존재하는지 확인. 회원가입페이지에서 쓸 것
     @GetMapping(value = "/check-userid")
     public ResponseEntity<Boolean> checkUserid(@RequestParam("userid") String userId) {
    	 logger.info("checkUserid()...userId : {}", userId);
         return ResponseEntity.ok(userRepository.existsByUserId(userId));
     }
     
     //이메일 중복확인 - 유저 이메일이 존재하는지 확인. 회원가입 때 쓸 것
     @GetMapping(value = "/check-email")
     public ResponseEntity<Boolean> checkEmail(@RequestParam("email") String email) {
    	 logger.info("checkEmail()...email : {}", email);
         return ResponseEntity.ok(userRepository.existsByEmail(email));
     }
     
     //비밀번호 변경 - 비밀번호 변경 페이지에서 쓸 것, 아이디를 가지고 해당 아이디를 가진 회원의 비밀번호를 바꾸기!
     @PostMapping("/change-password") 
     public int changePassword(@RequestParam("userId") String userId, @RequestParam("password") String password) {
    	 logger.info("checkEmail()...userId: {}, password: {}", userId, password);
         int result = userRepository.changePassword(userId, password);
         logger.error("changedPasswordCount : {}", result);
         return result;
     }
     
     @GetMapping(value = "/exist/userInfo", produces = MediaType.APPLICATION_JSON_VALUE)
     public ResponseEntity<Boolean> checkExistUserInfo(@RequestParam("userNo") int userNo){
    	 logger.info("checkEmail()...userNo: {}", userNo);
    	 User user = userRepository.findUserByUserNo(userNo);
    	 logger.info("mbti: {}", user.getMbti());
    	 if(user.getMbti() == null || user.getMbti().isEmpty()) {
    		 return ResponseEntity.ok(false);
    	 }
    	 return ResponseEntity.ok(true);//있을 때 true
     }
}