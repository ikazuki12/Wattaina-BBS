package jp.co.bbs.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import jp.co.bbs.dto.CommentDto;
import jp.co.bbs.dto.MessageDto;
import jp.co.bbs.dto.UserDto;
import jp.co.bbs.form.CommentForm;
import jp.co.bbs.form.MessageForm;
import jp.co.bbs.service.CommentService;
import jp.co.bbs.service.MessageService;
import jp.co.bbs.service.UserService;

@Controller
public class HomeController {

	@Autowired
	private MessageService messageService;
	@Autowired
	private UserService userService;
	@Autowired
	private CommentService commentService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String messageGet(
			Locale locale, Model model, 
			HttpSession session,
			@RequestParam(value = "category", required = false) String category,
			@RequestParam(value = "start_date", required = false) String startDate, 
			@RequestParam(value = "end_date", required = false) String endDate
			){
		UserDto loginUser = (UserDto) session.getAttribute("loginUser");
		List<MessageDto> messages = messageService.getMessages();
		List<UserDto> users = userService.getUsers();
		List<CommentDto> comments = commentService.getComments();
		model.addAttribute("user", loginUser);
		model.addAttribute("messages", messages);
		model.addAttribute("users", users);
		model.addAttribute("comments", comments);
		MessageForm messageForm = new MessageForm();
		model.addAttribute("messageForm", messageForm);
		CommentForm commentForm = new CommentForm();
		model.addAttribute("commentForm", commentForm);
		int messageSize = messages.size();
		model.addAttribute("messageSize", messageSize);
		if (category != null){
			if (category.equals("all")){
				category = null;
			}
			if (StringUtils.isEmpty(startDate)) {
				if (StringUtils.isEmpty(endDate)) {
					startDate = null;
					endDate = null;
				} else {
					startDate = "0000-00-00";
				}
			} else if (StringUtils.isEmpty(endDate)) {
				endDate = "0000-00-00";
			}
		}
		List<MessageDto> selectMessages = messageService.getSelectMessage(category, startDate, endDate);
		if (selectMessages.size() != 0) {
			model.addAttribute("user", loginUser);
			model.addAttribute("messages", selectMessages);
			return "home";
		} else {
			List<String> errorMessages = new ArrayList<String>();
			errorMessages.add("指定に該当する投稿がありません");
			session.setAttribute("errorMessages", errorMessages);
			return "redirect:/";
		}
		
	}
}
