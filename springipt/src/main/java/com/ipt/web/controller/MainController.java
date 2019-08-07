package com.ipt.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.context.annotation.Scope;

import com.ipt.web.model.Comment;
import com.ipt.web.model.MappedUser;
import com.ipt.web.model.Reply;
import com.ipt.web.repository.MappingRepository;
import com.ipt.web.service.CommentService;
import com.ipt.web.service.ReplyService;

@Controller
public class MainController {

		
	@Autowired
    private MappingRepository mappingRepository;
	
	//Under construction
		@RequestMapping(value = "/jobHistory", method = RequestMethod.GET)
		public String showJobHistory(Model model) {

			
			return "jobHistory";

		}
		//Under construction
		@RequestMapping(value = "/help", method = RequestMethod.GET)
		public String showHelp(Model model) {

			
			return "help";

		}

	
	

}