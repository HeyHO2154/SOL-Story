package com.eyes.solstory.global.bank.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter 
@Setter
@AllArgsConstructor
public class Header {
    private String apiName;
    private String transmissionDate;
    private String transmissionTime;
    private String institutionCode;
    private String fintechAppNo;
    private String apiServiceCode;
    private String institutionTransactionUniqueNo;
    private String apiKey;
    @Override
    public String toString() {
        return "HeaderReq{" +
                "apiName='" + apiName + '\'' +
                ", transmissionDate='" + transmissionDate + '\'' +
                ", transmissionTime='" + transmissionTime + '\'' +
                ", institutionCode='" + institutionCode + '\'' +
                ", fintechAppNo='" + fintechAppNo + '\'' +
                ", apiServiceCode='" + apiServiceCode + '\'' +
                ", institutionTransactionUniqueNo='" + institutionTransactionUniqueNo + '\'' +
                ", apiKey='" + apiKey + '\'' +
                '}';
    }
}
