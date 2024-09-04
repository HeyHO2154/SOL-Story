package com.eyes.solstory.domain.user.dto;

import java.time.LocalDate;

import com.eyes.solstory.util.OpenApiUtil;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDto {
    private String userId;
    private String password;
    private String userName;
    private String email;
    private String birth;  //
    private String gender;
    private LocalDate joinDate;
    
   
    public void setJoinDate() {
    	this.joinDate = LocalDate.now();
    }
    
    public LocalDate getJoinDate() {
    	if(this.joinDate == null) {
    		this.joinDate = LocalDate.now();
    	}
    	return this.joinDate;
    }

    @JsonCreator
    public UserDto(@JsonProperty("name") String name, @JsonProperty("userid") String userId
    				,@JsonProperty("password") String password, @JsonProperty("email") String email
    				,@JsonProperty("birthDate") String birthdate, @JsonProperty("gender") String gender) {
    	this.userId = userId;
        this.userName = name;
        this.password = password;
        this.email = email;
        this.birth = birthdate;
        this.gender = gender;
    }
    
    
    /*
    public void setBirthdate(String birthdate) {
    	LocalDate date = LocalDate.parse(birthdate, OpenApiUtil.DATE_FORMATTER);
        this.birthdate = date;
    }
    */
    
    public LocalDate transDateFormatyyyyMMdd(String date) {
    	return LocalDate.parse(date, OpenApiUtil.DATE_FORMATTER);
    }
}
