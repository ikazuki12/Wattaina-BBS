package jp.co.bbs.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jp.co.bbs.dto.CommentDto;
import jp.co.bbs.dto.UserDto;
import jp.co.bbs.service.CommentService;
import jp.co.bbs.service.UserService;

@Controller
public class CommentController {

	@Autowired
	private CommentService commentService;
	
	@Autowired
	private UserService userService;
	
	@RequestMapping(value = "comment", method = RequestMethod.POST)
	@ResponseBody
	public String[] getTestData(
			@RequestParam(value = "requestJs", required = false) String commentJs,
			HttpSession session,
			Model model
			) {

		List<String> messages = new ArrayList<String>();
		String text = null;
		Map<String, String> commentMap = new HashMap<String, String>();
		ObjectMapper mapper = new ObjectMapper();
		try {
			if (commentJs != null) {
				commentMap = mapper.readValue(commentJs, new TypeReference<HashMap<String,String>>() {});
				text = commentMap.get("message");
			} 
		} catch (Exception e) {
			e.printStackTrace();
		}
		int messageId = Integer.parseInt(commentMap.get("id"));
		UserDto loginUser = (UserDto) session.getAttribute("loginUser");
		Date date = new Date();
		if (isValid(text, messages)) {
			commentService.commentInsert(
					loginUser.getId(), messageId, text, date);
			CommentDto comment = commentService.getComment();
			UserDto user = userService.getSelectUser(comment.getUserId());
			String commentText = comment.getText();
			String commentMessageId = String.valueOf(comment.getMessageId());
			String commnetId = String.valueOf(comment.getId());
			String commentUserId = String.valueOf(comment.getUserId());
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy'年'MM'月'dd'日' HH':'mm");
			String retDate = dateFormat.format(comment.getInsertDate());
			String[] datas = {user.getName(), retDate, commentMessageId, commnetId, commentUserId, commentText};
			return datas;
			
		} else {
			String[] datas = { messages.get(0) };
			return datas;
			
		}
	    
	}
	
	private boolean isValid(String text, List<String> messages) {
		if (text.equals("")) {
			messages.add("内容を入力してください");
		} else if (500 < text.length()) {
			messages.add("500文字以下で入力してください");
		}
		if (messages.size() == 0) {
			return true;
		} else {
			return false;
		}
	}
}
