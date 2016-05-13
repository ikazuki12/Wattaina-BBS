package jp.co.bbs.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jp.co.bbs.dto.BranchDto;
import jp.co.bbs.dto.PositionDto;
import jp.co.bbs.dto.UserDto;
import jp.co.bbs.form.UserForm;
import jp.co.bbs.service.BranchService;
import jp.co.bbs.service.PositionService;
import jp.co.bbs.service.UserService;

@Controller
public class SettingsController {

	@Autowired
	private UserService userService;
	@Autowired
	private BranchService branchService;
	@Autowired
	private PositionService positionService;
	
	@RequestMapping(value = "/settings", method = RequestMethod.GET)
	@ResponseBody
	public String[] getUser(
			Model model,
			@RequestParam(value = "requestJs", required = false) String requestJs){
		Integer id = null;
		Map<String, String> userMap = new HashMap<String, String>();
		ObjectMapper mapper = new ObjectMapper();
		try {
			userMap = mapper.readValue(requestJs, new TypeReference<HashMap<String,String>>() {});
			id = Integer.parseInt(userMap.get("id"));
			 
		} catch (Exception e) {
			e.printStackTrace();
		}
		UserDto user = userService.getSelectUser(id);
		model.addAttribute("user", user);
		List<BranchDto> branches = branchService.getBranch();
	    List<PositionDto> positions = positionService.getPosition();
	    UserForm form = new UserForm();
	    model.addAttribute("userForm", form);
	    model.addAttribute("branches", branches);
	    model.addAttribute("positions", positions);
	    String userId = String.valueOf(user.getId());
	    String branchId = String.valueOf(user.getBranchId());
	    String positionId = String.valueOf(user.getPositionId());
	    String[] datas = {
	    		userId,
	    		user.getLoginId(), 
	    		user.getName(),
	    		branchId,
	    		positionId
	    		};
	    return datas;
	}
	
	@RequestMapping(value = "/settings", method = RequestMethod.POST)
	public String updeteUser(Model model, HttpSession session, @ModelAttribute UserForm form) {
		List<String> messages = new ArrayList<String>();
		UserDto user = UserDto.getInstance(
				form.getLoginId(), form.getPassword(),
				form.getName(), form.getBranchId(), form.getPositionId());
		user.setId(form.getId());
		if (isValid(user, messages)) {
			userService.updeteUser(user);
			return "redirect:/control/";
		} else {
			session.setAttribute("errorMessages", messages);
			return "redirect:/control/";
		}
	}
	
	private boolean isValid(UserDto user, List<String> messages) {
		List<UserDto> exsitUser = userService.getExsitUser(user);
		
		if (user.getLoginId().equals("")) {
			messages.add("ログインIDを入力してください");
		} else if (user.getLoginId().length() < 6 || user.getLoginId().length() > 20) {
			messages.add("ログインIDの文字数は6文字以上20文字以下で入力してください");
		} else if (!user.getLoginId().matches("[a-zA-Z0-9]{6,20}")) {
			messages.add("ログインIDは半角英数字で入力してください");
		}
		if (!user.getPassword().equals("")) {
			if (user.getPassword().length() < 6 || user.getPassword().length() > 20) {
				messages.add("パスワードの文字数は6文字以上20文字以下で入力してください");
			} else if (!user.getPassword().matches("[a-zA-Z0-9]{6,255}")) {
				messages.add("パスワードは半角英数字で入力してください");
			}
		}
		if (user.getName().equals("")) {
			messages.add("名前を入力してください");
		} else if (user.getName().length() > 10) {
			messages.add("名前は10文字以下で入力してください");
		}
		for (int i = 0, size = exsitUser.size(); i < size; i++) {
			if (user.getId() != exsitUser.get(i).getId()) {
				messages.add("既に" + user.getLoginId() + "は使用されています");
			}
		}
		
		if (messages.size() == 0) {
			return true;
		} else {
			return false;
		}
	}
}
