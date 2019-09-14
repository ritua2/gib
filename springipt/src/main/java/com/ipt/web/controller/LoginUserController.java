package com.ipt.web.controller;

import java.io.ByteArrayOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.File;
import java.lang.Exception;
import java.net.*;
import java.security.Principal;
import java.util.*; 
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.ipt.web.model.LoginUser;
import com.ipt.web.model.MappedUser;
import com.ipt.web.repository.UserRepository;
import com.ipt.web.repository.MappingRepository;
import com.ipt.web.service.LoginUserService;
import com.ipt.web.service.SecurityService;
import com.ipt.web.validator.LoginUserValidator;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import com.ipt.web.service.SesListener;

@Controller
@Scope("session")
public class LoginUserController {
    @Autowired
    private LoginUserService loginUserService;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private LoginUserValidator userValidator;
	
	@Autowired
    private UserRepository userRepository;
	
	@Autowired
    private MappingRepository mappingRepository;
	
	//@Autowired
	//private SesListener sesListener;
	
		
	private String ip_returned=null;
	
	
	
	public static MappedUser mappedUser=new MappedUser();
	private File file1 = new File("Output1.txt");

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
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()+"/home/gib/home").mkdirs();
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()+"/home/gib/home/gib").mkdirs();

        securityService.autologin(userForm.getUsername(), userForm.getPasswordConfirm());

        return "redirect:/welcome";
    }

    @GetMapping(value = "/login")
    public String login(Model model, String error, String logout, HttpServletRequest request) {
		
	

        return "login_v7";
    }
	
	 @GetMapping(value = "/login_normal")
    public String login_normal(Model model, String error, String logout, HttpServletRequest request) {
		
		if (error != null)
            model.addAttribute("error", "Your username and password is invalid.");

        if (logout != null){
			model.addAttribute("name", logout);
            model.addAttribute("message", "You have been logged out successfully.");
		}	
		
		
		return "login_normal";
    }
	@GetMapping(value = "/login_tacc")
    public String login_tacc(Model model, String error, String logout, HttpServletRequest request, Authentication authentication) {
		
		if (error != null)
            model.addAttribute("error", "Your username and password is invalid.");

        if (logout != null){
			model.addAttribute("name", logout);
            model.addAttribute("message", "You have been logged out successfully.");
		}
		
		
				

        return "login_tacc";
    }
	
	 @GetMapping(value = "/perform_logout")
    public String logout1(HttpServletRequest request) {
		
		if(request.getSession().getAttribute("mySessionAttribute")!=null)
		com.ipt.web.service.WaitService.freeInstance(request.getUserPrincipal().getName(),request.getSession().getAttribute("mySessionAttribute").toString());
		
		HttpSession session = request.getSession(false);
		session.invalidate();
		
		return "redirect:/login?logout";
        
    }
	
	@GetMapping(value = {"/", "/welcome"})
    public String welcome(HttpServletRequest request, Model model, HttpSession session, Principal principal, Authentication authentication) {
		
		Boolean abc=false;
		Boolean is_ldap=false;
		Boolean check=false;
		check=null == principal;
		
		if(!check){
			abc=request.isUserInRole("ROLE_ADMIN");
			session.setAttribute("is_admin", abc.toString());
		if(authentication.getPrincipal().toString().contains("Not granted any authorities")){
			if(authentication.getPrincipal().toString().substring(0,65).equals("org.springframework.security.ldap.userdetails.LdapUserDetailsImpl"))
				is_ldap=true;
		}
		session.setAttribute("is_ldap", is_ldap.toString());
		
			return "welcome";
		}else 			
			return "redirect:/login";
    }
    
    @GetMapping(value = "/terminal")
    public String terminal(Model model,HttpServletRequest request, HttpSession session) {
       
	   String curl_output=null;
	   String loggedin_user=null;
	   
	   if(session.getAttribute("is_ldap")=="true"){
		   if(authentication.getName().toString().contains(" "))
			   loggedin_user=authentication.getName().toString().replace(" ","_");
	   }else
		   loggedin_user=request.getUserPrincipal().getName();
	   
	   try{
			File file4 = new File("Details.txt");
			FileWriter fileWriter = new FileWriter(file4);
			fileWriter.write("\n");
			fileWriter.write("Username : "+ loggedin_user);
			fileWriter.write("\n");
			fileWriter.flush();
			fileWriter.close();
		}catch(IOException e){
			e.printStackTrace();
		}
		
		
	if(session.getAttribute("mySessionAttribute")==null || ((session.getAttribute("mySessionAttribute")!=null)&& ((new com.ipt.web.service.MappingService().findMapping(loggedin_user))!="Null"))){
		
		
		StringBuilder result = new StringBuilder();
		StringBuilder result2 = new StringBuilder();

        URL url = null;
		String okey=null, jsonInputString=null, baseIP=null;
		
		File file = new File("/usr/local/tomcat/webapps/envar.txt");
		BufferedReader reader;
		try {
			reader = new BufferedReader(new FileReader(file));
			String line = reader.readLine();
			while (line != null) {
				if(line.contains("orchestra_key"))
					okey=line.substring(line.indexOf("=")+1);
				else if(line.contains("URL_BASE"))
					baseIP=line.substring(line.indexOf("=")+1);
				line = reader.readLine();
			}
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		
		try{
			url = new URL("http://"+baseIP+":5000/api/assign/users/"+loggedin_user);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json; utf-8");
			conn.setDoOutput(true);
			jsonInputString = "{\"key\":\""+okey+"\", \"sender\":\"carlos\"}";
			try(OutputStream os = conn.getOutputStream()) {
				byte[] input = jsonInputString.getBytes("utf-8");
				os.write(input, 0, input.length);           
			}
			BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			while ((line = rd.readLine()) != null) {
				result.append(line);
			}
			rd.close();
			if(result!=null){
			try{
			File file1 = new File("Assign.txt");
			FileWriter fileWriter = new FileWriter(file1);
			fileWriter.write(result.toString());
			fileWriter.write("\n");
			fileWriter.write("User:"+loggedin_user);
			fileWriter.write("\n");
			fileWriter.flush();
			fileWriter.close();
		}catch(IOException e){
			e.printStackTrace();
			}}
			if(result.toString().equals("False")){
				ip_returned="False";
			}else{
				ip_returned=result.toString();
			}
	  
		}catch(MalformedURLException e){
			e.printStackTrace();
		}catch(ProtocolException e){
			e.printStackTrace();
		}catch(IOException e){
			e.printStackTrace();
		}
		
		if(ip_returned.equals("False"))
			curl_output="Error!!!";
		else{
			
			try{
				url = new URL("http://"+baseIP+":5000/api/redirect/users/"+loggedin_user+"/"+ip_returned.substring(0,ip_returned.indexOf(':')));
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("GET");
				conn.setInstanceFollowRedirects( false );
				BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String line=null;;
				while ((line = rd.readLine()) != null) {
					result2.append(line);
				} 
				rd.close();
				if(result2!=null){
			try{
			
			File file2 = new File("Redirect.txt");
			FileWriter fileWriter = new FileWriter(file2);
			fileWriter.write(result2.toString());
			
			fileWriter.flush();
			fileWriter.close();
		}catch(IOException e){
			e.printStackTrace();
			}}
				curl_output=result2.toString();
			}catch(MalformedURLException e){
				e.printStackTrace();
			}catch(ProtocolException e){
				e.printStackTrace();
			}catch(IOException e){
				e.printStackTrace();
			}	
		
			if(curl_output.contains("Redirecting"))
				curl_output=curl_output.substring(curl_output.indexOf("http://")+7, curl_output.indexOf("/wetty"));
			else
				curl_output = "Error!!";		
		}
    	
			session.setAttribute("mySessionAttribute", curl_output);
			mappedUser.setUser(loggedin_user);
			mappedUser.setIp(curl_output);
			session.setAttribute("uName", loggedin_user);
			session.setAttribute("uIP", curl_output);

			
			mappingRepository.save(mappedUser);
			
			
		
			
	}else{
		
		com.ipt.web.service.WaitService.wait(loggedin_user);
		
		String str = com.ipt.web.service.WaitService.returnWaitKey(loggedin_user);
		if(session.getAttribute("key")==null && session.getAttribute("key1")==null){
			
			session.setAttribute("key1", str);
		}else{
			session.setAttribute("key", session.getAttribute("key1") );
			session.setAttribute("key1", str);
		}
		
	}
		model.addAttribute("ip", (String) session.getAttribute("mySessionAttribute"));
        return "terminal";
    }

}
