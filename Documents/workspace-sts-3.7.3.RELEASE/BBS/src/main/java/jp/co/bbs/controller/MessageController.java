package jp.co.bbs.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.bbs.dto.MessageDto;
import jp.co.bbs.dto.UserDto;
import jp.co.bbs.form.MessageForm;
import jp.co.bbs.service.MessageService;

@Controller
public class MessageController {

	@Autowired
	private MessageService messageService;
	
	@RequestMapping(value = "/message/", method =  RequestMethod.GET)
	public String messageInsert(Model model) {
		MessageForm messageForm = new MessageForm();
		model.addAttribute("messageForm", messageForm);
		return "message";
	}
	
	@RequestMapping(value = "/message/", method =  RequestMethod.POST)
	public String messageInsert(@ModelAttribute MessageForm form, HttpSession session, Model model) throws ParseException {
		UserDto loginUser = (UserDto) session.getAttribute("loginUser");
		List<String> messages = new ArrayList<String>();
		Date datepicker = new Date();
		MessageDto message = 
				MessageDto.getInstance(
						loginUser.getId(), form.getSubject(), form.getText(), form.getCategory(), datepicker);
		if (isValid(message, messages)) {
			messageService.messageInsert(message);
			return "redirect:/";
		} else {
			session.setAttribute("errorMessages", messages);
			return "redirect:/message/";
		}
		
	}
	
	private boolean isValid(MessageDto message , List<String> messages) {
		
		if (message.getSubject().equals("")) {
			messages.add("件名を入力してください");
		} else if (50 < message.getSubject().length()) {
			messages.add("件名は50文字以下で入力してください");
		}
		if (message.getText().equals("")) {
			messages.add("本文を入力してください");
		} else if (1000 < message.getText().length()) {
			messages.add("本文は1000文字以下で入力してください");
		}
		if (message.getCategory().equals("")) {
			messages.add("カテゴリーを入力してください");
		} else if (10 < message.getCategory().length()) {
			messages.add("カテゴリーはは10文字以下で入力してください");
		}
		if (messages.size() == 0) {
			return true;
		} else {
			return false;
		}
	}
}
