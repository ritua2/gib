package com.ipt.web.controller;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;


import java.io.OutputStream;


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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ipt.web.model.LoginUser;
import com.ipt.web.model.MappedUser;
import com.ipt.web.model.UnconfirmedUser;
import com.ipt.web.repository.UserRepository;
import com.ipt.web.repository.MappingRepository;
import com.ipt.web.repository.RoleRepository;
import com.ipt.web.repository.UnconfirmedUserRepository;

import com.ipt.web.service.LoginUserService;
import com.ipt.web.service.UserService;
import com.ipt.web.service.SecurityService;
import com.ipt.web.validator.LoginUserValidator;
import com.ipt.web.validator.UnconfirmedUserValidator;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import com.ipt.web.service.SesListener;

@Controller
@Scope("session")
public class LoginUserController {
    @Autowired
    private LoginUserService loginUserService;
	
	@Autowired
    private UserService userService;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private LoginUserValidator userValidator;
	
	@Autowired
    private UnconfirmedUserValidator unconfirmedUserValidator;
	
	@Autowired
    private UserRepository userRepository;
	
	@Autowired
    private RoleRepository roleRepository;
	
	@Autowired
    private UnconfirmedUserRepository unconfirmedUserRepository;
	
	@Autowired
    private MappingRepository mappingRepository;
	
	private String ip_returned=null;
	
	public static MappedUser mappedUser=new MappedUser();
	private File file1 = new File("Output1.txt");

    @GetMapping(value = "/registration")
    public String registration(Model model) {
        model.addAttribute("userForm", new UnconfirmedUser());

        return "registration";
    }
	
	@PostMapping(value = "/registration")
    public String registration(@ModelAttribute("userForm") UnconfirmedUser userForm, BindingResult bindingResult, Model model) {
		
		String jsonInputString=null, okey=null, baseIP=null;
		BufferedReader reader=null;
		URL url = null;
		StringBuilder result = new StringBuilder();
		
        //userValidator.validate(userForm, bindingResult);
		unconfirmedUserValidator.validate(userForm, bindingResult);
		
	
		
        if (bindingResult.hasErrors()) {
            return "registration";
        }
		
		try {
					File envar = new File("/usr/local/tomcat/webapps/envar.txt");
					reader = new BufferedReader(new FileReader(envar));
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
				
		String token = UUID.randomUUID().toString();
		//userForm.setValidation_state("no");
		userForm.setValidation_key(token);
		
		//loginUserService.save(userForm);
		userService.save(userForm);
		
		
		final String confirmationUrl = "http://"+baseIP+":9090/registrationConfirmation?user="+userForm.getUsername()+"&token="+token;
		
			
		String message= "Welcome to GIB,"+"\\n"+"\\n"+"Thank you for registering!"+"\\n"+"\\n"+"Please verify your email by clicking or copying the following link into your browser's search bar: "+confirmationUrl;
		
		
		
		try{
		jsonInputString = "{\"key\":\""+okey+"\",\"subject\":\"Registration Confirmation for "+userForm.getUsername()+"\", \"email_address\": \""+userForm.getEmail()+"\", \"text\":\""+message+"\"}"; 
		
		url = new URL("http://"+baseIP+":5000/api/email/send");
		} catch(MalformedURLException e){
				e.printStackTrace();
			}catch (IOException e) {
				e.printStackTrace();
			} 	
		
		try{
			
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json; utf-8");
			conn.setDoOutput(true);
			
			File file4 = new File("EmailValidation_submit.txt");
			
			FileWriter fileWriter = new FileWriter(file4);
			
			fileWriter.write("\n");
			fileWriter.write("Base IP: "+ baseIP);
			fileWriter.write("\n");
			fileWriter.write("Base IP: "+ message);
			fileWriter.write("\n");
			fileWriter.write("URL: "+ url.toString());
			fileWriter.write("\n");
			fileWriter.write("\n");
			fileWriter.write(jsonInputString);
			fileWriter.write("\n");
			fileWriter.flush();
			fileWriter.close();
			
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
			
			try{
			File file3 = new File("ValidationResult.txt");
			FileWriter fileWriter2 = new FileWriter(file3);
			fileWriter2.write(result.toString());
			fileWriter2.write("\n");
			fileWriter2.flush();
			fileWriter2.close();
		}catch(IOException e){
			e.printStackTrace();
		}
				
		}catch(ProtocolException e){
			e.printStackTrace();
		}catch(IOException e){
			e.printStackTrace();
		}
				
		// Creates the user directory
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()).mkdirs();
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()+"/home").mkdirs();
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()+"/home/gib").mkdirs();
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()+"/home/gib/home").mkdirs();
        new File("/home/greyfish/users/sandbox/DIR_"+userForm.getUsername()+"/home/gib/home/gib").mkdirs();
        //securityService.autologin(userForm.getUsername(), userForm.getPasswordConfirm());

        //return "redirect:/welcome";
		return "redirect:/sentlink";
    }
	
	@GetMapping(value = "/sentlink")
    public String sentLink() {
        
        return "sentlink";
    }

	@GetMapping(value = "/registrationConfirmation")
    public String registrationConfirmation(@RequestParam("user") String userName, @RequestParam("token") String code) {
		
		//Boolean check=false;
		//check=null == auth.getPrincipal();
		
		try{
			File file3 = new File("Valid_Link.txt");
			FileWriter fileWriter2 = new FileWriter(file3);
			fileWriter2.write("\n");
			fileWriter2.write(userName);
			fileWriter2.write("\n");
			fileWriter2.write(code);
			fileWriter2.write("\n");
			fileWriter2.flush();
			fileWriter2.close();
		}catch(IOException e){
			e.printStackTrace();
		}
		
		if(unconfirmedUserRepository.findByUsername(userName)!=null){
		if(unconfirmedUserRepository.findByUsername(userName).getValidation_key().equals(code)){
			LoginUser lu= new LoginUser();
			lu.setId(unconfirmedUserRepository.findByUsername(userName).getId());
			lu.setUsername(unconfirmedUserRepository.findByUsername(userName).getUsername());
			lu.setEmail(unconfirmedUserRepository.findByUsername(userName).getEmail());
			lu.setName(unconfirmedUserRepository.findByUsername(userName).getName());
			lu.setInstitution(unconfirmedUserRepository.findByUsername(userName).getInstitution());
			lu.setCountry(unconfirmedUserRepository.findByUsername(userName).getCountry());
			lu.setPassword(unconfirmedUserRepository.findByUsername(userName).getPassword());
			//lu.setPasswordConfirm(unconfirmedUserRepository.findByUsername(userName).getPassword());
			lu.setRole(roleRepository.findOne(1L));
			userRepository.save(lu);
			unconfirmedUserRepository.delete(unconfirmedUserRepository.findByUsername(userName));
			return "registrationConfirmation2";
		}else{
			if(unconfirmedUserRepository.findByUsername(userName)!=null)
				unconfirmedUserRepository.delete(unconfirmedUserRepository.findByUsername(userName));
			return "registrationError";
		}
		}else
			return "registrationError";
	}
	
	/*@GetMapping(value = "/registrationConfirmation")
    public String registrationConfirmation(@RequestParam("user") String userName, @RequestParam("token") String code, Authentication auth, HttpServletRequest request) {
		
		Boolean check=false;
		check=null == auth.getPrincipal();
		
		try{
			File file3 = new File("Valid_Link.txt");
			FileWriter fileWriter2 = new FileWriter(file3);
			fileWriter2.write("\n");
			fileWriter2.write(userName);
			fileWriter2.write("\n");
			fileWriter2.write(code);
			fileWriter2.write("\n");
			fileWriter2.flush();
			fileWriter2.close();
		}catch(IOException e){
			e.printStackTrace();
		}
		
		if(loginUserService.findByUsername(userName).getValidation_key().equals(code)){
			LoginUser lu=loginUserService.findByUsername(userName);
			lu.setValidation_state("verified");
			loginUserService.save(lu);
			if(!check)
				return "registrationConfirmation1";
			else
				return "registrationConfirmation2";
		}else{
			loginUserService.delete(loginUserService.findByUsername(userName));
			HttpSession session = request.getSession(true);
			session.invalidate();
			return "registrationError";
		}
		
    }*/
	
	
	

    /*@GetMapping(value = "/login")
    public String login(Model model, String error, String logout, HttpServletRequest request) { 

		RequestAttributes attribs = RequestContextHolder.getRequestAttributes();
		HttpServletRequest request1=null;

		if (RequestContextHolder.getRequestAttributes() != null) {
				request1 = ((ServletRequestAttributes) attribs).getRequest();
		}


		try{
			File file4 = new File("Test.txt");
			FileWriter fileWriter = new FileWriter(file4);
			fileWriter.write("\n");
			fileWriter.write("Khwaab");
			//fileWriter.write("auth: "+SecurityContextHolder.getContext().getAuthentication().getDetails());
			fileWriter.write("\n");
			fileWriter.flush();
			fileWriter.close();
		}catch(IOException e){
			e.printStackTrace();
		}
		
		/*if (error != null)
            model.addAttribute("error", "Your username and password is invalid.");

        if (logout != null){
			model.addAttribute("name", logout);
            model.addAttribute("message", "You have been logged out successfully.");
		}*/	

		/*  return "redirect:/welcome";
    }*/
	@RequestMapping(value = "/test1")
    public void test1(HttpSession session, HttpServletRequest request) { 
		
		try{
			File file4 = new File("Abc.txt");
			FileWriter fileWriter = new FileWriter(file4);
			fileWriter.append("\n");
			fileWriter.append("LDAP User");
			fileWriter.append("\n");
			fileWriter.flush();
			fileWriter.close();
			
		}catch(IOException e){
			e.printStackTrace();
		}
	}
	@RequestMapping(value = "/test2")
    public void test2(HttpSession session, HttpServletRequest request) { 
		
		try{
			File file4 = new File("Abc2.txt");
			FileWriter fileWriter = new FileWriter(file4);
			fileWriter.append("\n");
			fileWriter.append("DB User");
			fileWriter.append("\n");
			fileWriter.flush();
			fileWriter.close();
		}catch(IOException e){
			e.printStackTrace();
		}
	}
	@GetMapping(value = "/entry")
    public String entry() {
        return "login_v7";
    }
	
	 @GetMapping(value = "/login_normal")
    public String login_normal(Model model, String error, String logout) {
		
		if (error != null)
            model.addAttribute("error", "Your username and password is invalid.");

        if (logout != null){
			model.addAttribute("name", logout);
            model.addAttribute("message", "You have been logged out successfully.");
		}	
		
		
		return "login_normal";
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
			if(authentication.getPrincipal().toString().substring(0,65).equals("org.springframework.security.ldap.userdetails.LdapUserDetailsImpl")){
				is_ldap=true;
				new File("/home/greyfish/users/sandbox/DIR_"+authentication.getName().toString().replace(" ","_")).mkdirs();
				new File("/home/greyfish/users/sandbox/DIR_"+authentication.getName().toString().replace(" ","_")+"/home").mkdirs();
				new File("/home/greyfish/users/sandbox/DIR_"+authentication.getName().toString().replace(" ","_")+"/home/gib").mkdirs();
				new File("/home/greyfish/users/sandbox/DIR_"+authentication.getName().toString().replace(" ","_")+"/home/gib/home").mkdirs();
				new File("/home/greyfish/users/sandbox/DIR_"+authentication.getName().toString().replace(" ","_")+"/home/gib/home/gib").mkdirs();
			}				
		}
		session.setAttribute("is_ldap", is_ldap.toString());
		
		// TODO
		// Add user information to MySQL

			return "welcome";
		}else 			
			return "redirect:/entry";
    }
    
    @GetMapping(value = "/terminal")
    public String terminal(Model model,HttpServletRequest request, HttpSession session, Authentication authentication) {
       
	   String curl_output=null;
	   String loggedin_user=null;
	   
	   String baseIP0=null;
		
		File file0 = new File("/usr/local/tomcat/webapps/envar.txt");
		BufferedReader reader0;
		try {
			reader0 = new BufferedReader(new FileReader(file0));
			String line = reader0.readLine();
			while (line != null) {
				if(line.contains("URL_BASE"))
					baseIP0=line.substring(line.indexOf("=")+1);
				line = reader0.readLine();
			}
			reader0.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	   
	   if(session.getAttribute("is_ldap")=="true"){
		   if(authentication.getName().toString().contains(" "))
			   loggedin_user=authentication.getName().toString().replace(" ","_");
	   }else
		   loggedin_user=request.getUserPrincipal().getName();
		
		
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
		
		//Principal principal = request.getUserPrincipal();
		
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
			//curl_output=abc;
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
			//Boolean abc=request.isUserInRole("ROLE_ADMIN");
			File file2 = new File("Redirect.txt");
			FileWriter fileWriter = new FileWriter(file2);
			fileWriter.write(result2.toString());
			//fileWriter.write(abc.toString());
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
				curl_output=curl_output.substring(curl_output.indexOf("https://")+8, curl_output.indexOf("/wetty"));
			else
				curl_output = "Error!!";		
		}
    	
			session.setAttribute("mySessionAttribute", curl_output);
			mappedUser.setUser(loggedin_user);
			mappedUser.setIp(curl_output);
			session.setAttribute("uName", loggedin_user);
			session.setAttribute("uIP", curl_output);

			
			mappingRepository.save(mappedUser);
			
			
		//List<MappedUser> list=mappingRepository.findAll();
			
	}else{
		//com.ipt.web.service.WaitService.wait(request.getUserPrincipal().getName());
		com.ipt.web.service.WaitService.wait(loggedin_user);
		
		//String str = com.ipt.web.service.WaitService.returnWaitKey(request.getUserPrincipal().getName());
		String str = com.ipt.web.service.WaitService.returnWaitKey(loggedin_user);
		if(session.getAttribute("key")==null && session.getAttribute("key1")==null){
			
			session.setAttribute("key1", str);
		}else{
			session.setAttribute("key", session.getAttribute("key1") );
			session.setAttribute("key1", str);
		}
		
	}
		model.addAttribute("ip", (String) session.getAttribute("mySessionAttribute"));
		model.addAttribute("baseip", baseIP0);
			
        return "terminal";
    }
	
	@GetMapping(value = "/redirect")
    public String redirect(Model model, HttpSession session) {
		model.addAttribute("ip", (String) session.getAttribute("mySessionAttribute"));
        return "redirect";
    }
	
	

}
