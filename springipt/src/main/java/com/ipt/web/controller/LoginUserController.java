package com.ipt.web.controller;

import java.io.File;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.ipt.web.model.LoginUser;
import com.ipt.web.service.LoginUserService;
import com.ipt.web.service.SecurityService;
import com.ipt.web.validator.LoginUserValidator;

@Controller
@Scope("session")
public class LoginUserController {
    @Autowired
    private LoginUserService loginUserService;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private LoginUserValidator userValidator;

    @GetMapping(value = "/registration")
    public String registration(Model model) {
        model.addAttribute("userForm", new LoginUser());

        return "registration";
    }

    @PostMapping(value = "/registration")
    public String registration(@ModelAttribute("userForm") LoginUser userForm, BindingResult bindingResult, Model model) {
        userValidator.validate(userForm, bindingResult);

        if (bindingResult.hasErrors()) {
            return "registration";
        }

        loginUserService.save(userForm);

        // Creates the user directory
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()).mkdirs();
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()+"/home").mkdirs();
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()+"/home/gib").mkdirs();

        securityService.autologin(userForm.getUsername(), userForm.getPasswordConfirm());

        return "redirect:/welcome";
    }

    @GetMapping(value = "/login")
    public String login(Model model, String error, String logout) {
        if (error != null)
            model.addAttribute("error", "Your username and password is invalid.");

        if (logout != null)
            model.addAttribute("message", "You have been logged out successfully.");

        return "login";
    }

    @GetMapping(value = {"/", "/welcome"})
    public String welcome(HttpServletRequest request, Model model) {
        return "welcome";
    }
    
    @GetMapping(value = "/terminal")
    public String terminal(Model model) {
       /* if (error != null)
            model.addAttribute("error", "Your terminal is not ready.");

        if (logout != null)
            model.addAttribute("message", "You have been logged out successfully.");*/

        return "terminal";
    }

}
