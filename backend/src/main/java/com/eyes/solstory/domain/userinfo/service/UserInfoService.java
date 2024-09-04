package com.eyes.solstory.domain.userinfo.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eyes.solstory.domain.userinfo.entity.Hobby;
import com.eyes.solstory.domain.userinfo.entity.Interest;
import com.eyes.solstory.domain.userinfo.repository.HobbyRepository;
import com.eyes.solstory.domain.userinfo.repository.InterestRepository;

@SuppressWarnings("unchecked")
@Service
public class UserInfoService {
	@Autowired
	private HobbyRepository hobbyRepository;
	@Autowired
	private InterestRepository interestRepository;
	private static final Logger logger = LoggerFactory.getLogger(UserInfoService.class.getSimpleName());

    public void insertUserInfo(Map<String, Object> userInfo) {
		logger.info("insertUserInfo()...userInfo:{}", userInfo);
    	int userNo = (int)userInfo.get("userNo");
    	List<String> hobbies = (List<String>)userInfo.get("hobbies");
    	logger.error("hobbies:{}", hobbies);
    	for(String hobby : hobbies) {
    		Hobby h = new Hobby();
    		h.setUserNo(userNo);
    		h.setHobbyCate(hobby);
    		hobbyRepository.save(h);
    	}
    	
    	List<String> interests = (List<String>)userInfo.get("interests");
    	for(String interest : interests) {
    		Interest i = new Interest();
    		i.setUserNo(userNo);
    		i.setInterestCate(interest);
    		interestRepository.save(i);
    	}
    	
    }
}
