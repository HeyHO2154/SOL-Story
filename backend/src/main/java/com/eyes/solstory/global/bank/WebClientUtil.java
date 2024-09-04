package com.eyes.solstory.global.bank;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import com.eyes.solstory.domain.user.dto.OneWonVerificationReq;
import com.eyes.solstory.domain.user.dto.OneWonVerificationRes;
import com.eyes.solstory.domain.user.dto.TransferOneWonRes;
import com.eyes.solstory.domain.user.dto.UserReq;
import com.eyes.solstory.domain.user.dto.UserRes;
import com.eyes.solstory.global.bank.dto.Header;
import com.eyes.solstory.global.bank.dto.SavingsAccountReq;
import com.eyes.solstory.global.bank.dto.SavingsAccountRes;
import com.eyes.solstory.global.bank.dto.SearchSavingsAccountReq;
import com.eyes.solstory.global.bank.dto.SearchSavingsAccountRes;
import com.eyes.solstory.global.bank.dto.SearchSavingsProductRes;
import com.eyes.solstory.global.bank.dto.UpdateSavingsAccountReq;
import com.eyes.solstory.global.bank.dto.UpdateSavingsAccountRes;

import reactor.core.publisher.Mono;

@Component
public class WebClientUtil {
    @Value("${api.key}")
    private String apiKey;
    private final WebClient webClient;
    private static final Logger logger = LoggerFactory.getLogger(WebClientUtil.class.getSimpleName());

    public WebClientUtil(WebClient webClient) {
        this.webClient = webClient;
    }

    //1원 송금
    public Mono<ResponseEntity<TransferOneWonRes>> transferOneWon(Map<String, Object> request) {
        logger.info("transferOneWon()...request:{}", request.toString());
        String url = "/edu/accountAuth/openAccountAuth";
        Mono<ResponseEntity<TransferOneWonRes>> result = webClient.post()
                .uri(url)
                .bodyValue(request)
                .retrieve()
//                .onStatus(
//                		status -> status.equals(HttpStatus.BAD_REQUEST),
 //                       response -> response.bodyToMono(String.class).map(Exception::new))
 //               .onStatus(
  //                      status -> status.equals(HttpStatus.INTERNAL_SERVER_ERROR),
   //                     clientResponse -> clientResponse.bodyToMono(String.class).map(Exception::new))
                .toEntity(TransferOneWonRes.class);
        
        System.out.println("get " +webClient.toString());
        System.out.println(result.toString());
        return result;
    }

    //1원 검증
    public Mono<ResponseEntity<OneWonVerificationRes>> authenticateTransferOneWon(
            OneWonVerificationReq request) {
        logger.info("authenticateTransferOneWon()...request:{}", request.toString());
        String url = "/edu/accountAuth/checkAuthCode";

        return webClient.post()
                .uri(url)
                .bodyValue(request)
                .retrieve()
                .onStatus(
                        HttpStatus.BAD_REQUEST::equals,
                        response -> response.bodyToMono(String.class).map(Exception::new))
                .onStatus(
                        HttpStatus.INTERNAL_SERVER_ERROR::equals,
                        clientResponse -> clientResponse.bodyToMono(String.class).map(Exception::new))
                .toEntity(OneWonVerificationRes.class);
    }

    //사용자 계정 생성
    public Mono<ResponseEntity<UserRes>> creatUserAccount(String userId) {
        logger.info("creatUserAccount()...userId:{}", userId);
        String url = "/member";
        UserReq request = new UserReq(apiKey, userId);

        return webClient.post()
                .uri(url)
                .bodyValue(request)
                .retrieve()
                .onStatus(
                        HttpStatus.BAD_REQUEST::equals,
                        response -> response.bodyToMono(String.class).map(Exception::new))
                .toEntity(UserRes.class);
    }

    //사용자 계정 조회
    public Mono<ResponseEntity<UserRes>> findUserAccount(String userId) {
        logger.info("findUserAccount()...userId:{}", userId);
        String url = "/member/search";
        UserReq request = new UserReq(apiKey, userId);
        return webClient.post()
                .uri(url)
                .bodyValue(request)
                .retrieve()
                .onStatus(
                        HttpStatus.BAD_REQUEST::equals,
                        response -> response.bodyToMono(String.class).map(Exception::new))
                .toEntity(UserRes.class);
    }

    //수시입출금 - 계좌 입금
    public Mono<ResponseEntity<UpdateSavingsAccountRes>> updateSavingAccountDeposit(UpdateSavingsAccountReq request) {
        logger.info("updateSavingAccountDeposit()...request:{}", request.toString());
        String url = "/edu/demandDeposit/updateDemandDepositAccountDeposit";
        return webClient.post()
                .uri(url)
                .bodyValue(request)
                .retrieve()
                .onStatus(
                        HttpStatus.BAD_REQUEST::equals,
                        response -> response.bodyToMono(String.class).map(Exception::new))
                .toEntity(UpdateSavingsAccountRes.class);
    }

    //적금 상품 조회
    public Mono<ResponseEntity<SearchSavingsProductRes>> searchSavingsProduct(Header header) {
        logger.info("searchSavingsProduct()...header:{}", header.toString());
        String url = "/edu/savings/inquireSavingsProducts";
        return webClient.post()
                .uri(url)
                .bodyValue(header)
                .retrieve()
                .onStatus(
                        HttpStatus.BAD_REQUEST::equals,
                        response -> response.bodyToMono(String.class).map(Exception::new))
                .onStatus(
                        HttpStatus.INTERNAL_SERVER_ERROR::equals,
                        clientResponse -> clientResponse.bodyToMono(String.class).map(Exception::new))
                .toEntity(SearchSavingsProductRes.class);
    }

    //적금 계좌 생성
    public Mono<ResponseEntity<SavingsAccountRes>> createSavingAccount(SavingsAccountReq request) {
        logger.info("createSavingAccount()...request:{}", request.toString());
        String url = "/edu/savings/createAccount";

        return webClient.post()
                .uri(url)
                .bodyValue(request)
                .retrieve()
                .onStatus(
                        HttpStatus.BAD_REQUEST::equals,
                        response -> response.bodyToMono(String.class).map(Exception::new))
                .toEntity(SavingsAccountRes.class);
    }

    //적금 계좌 조회 - 단건
    public Mono<ResponseEntity<SearchSavingsAccountRes>> searchSavingAccount(SearchSavingsAccountReq request) {
        logger.info("searchSavingAccount()...request:{}", request.toString());
        String url = "/edu/savings/inquireAccount";

        return webClient.post()
                .uri(url)
                .bodyValue(request)
                .retrieve()
                .onStatus(
                        HttpStatus.BAD_REQUEST::equals,
                        response -> response.bodyToMono(String.class).map(Exception::new))
                .toEntity(SearchSavingsAccountRes.class);
    }
}