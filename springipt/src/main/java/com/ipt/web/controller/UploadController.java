package com.ipt.web.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.StringJoiner;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class UploadController {

	private static String UPLOADED_FOLDER = "/home/term/";
	private final Logger logger = LoggerFactory.getLogger(UploadController.class);

	@GetMapping("/terminal/upload")
	public String index() {
		return "upload";
	}

	@RequestMapping(value = "/terminal/upload", method = RequestMethod.POST, produces = "application/json")
	public String fileUpload(@RequestParam("filefolder") String filefolderselection,
			@RequestParam("fileToUpload") MultipartFile file, @RequestParam("folderToUpload") MultipartFile[] files,
			@RequestParam("hiddenInput") String jsonfilepath, RedirectAttributes redirectAttributes) {

		System.out.println("Inside the /terminal/upload");
		String objectToReturn = "";
		if (filefolderselection.equals("file")) {

			if (file.isEmpty()) {
				redirectAttributes.addFlashAttribute("msg", "Please select a file to upload");
				// return "redirect:/terminal";
			}

			try {

				byte[] bytes = file.getBytes();
				Path path = Paths.get(UPLOADED_FOLDER + file.getOriginalFilename());
				Files.write(path, bytes);
				Process p1 = Runtime.getRuntime().exec("chown -R 1001:1001 /home/term");

				redirectAttributes.addFlashAttribute("msg",
						"You successfully uploaded '" + file.getOriginalFilename() + "'");

			} catch (IOException e) {
				e.printStackTrace();
			}
		} else if (filefolderselection.equals("folder")) {
			Map<String, Object> map = new HashMap<String, Object>();

			try {
				System.out.println("jsonfilepath " + jsonfilepath);
				ObjectMapper mapper = new ObjectMapper();
				jsonfilepath = jsonfilepath.replace("{", "").replace("}", "").replace("[", "{").replace("]", "}");
				System.out.println("jsonfilepath " + jsonfilepath);

				// convert JSON string to Map
				map = mapper.readValue(jsonfilepath, new TypeReference<Map<String, String>>() {
				});

				// System.out.println(map);
			} catch (JsonGenerationException e) {
				e.printStackTrace();
			} catch (JsonMappingException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			StringJoiner sj = new StringJoiner(" , ");

			for (MultipartFile f : files) {

				if (f.isEmpty()) {
					continue; // next pls
				}

				try {
					byte[] bytes = f.getBytes();
					System.out.println("File PATH GETNAME =" + f.getName() + " Original path Name" + f.getOriginalFilename());
					Path path = Paths.get(UPLOADED_FOLDER + map.get(f.getOriginalFilename()));
					Path parentDir = path.getParent();
					if (!Files.exists(parentDir))
						Files.createDirectories(parentDir);
					Files.write(path, bytes);

					sj.add(f.getOriginalFilename());

				} catch (IOException e) {
					e.printStackTrace();
				}

			}

			String uploadedFileName = sj.toString();

			if (StringUtils.isEmpty(uploadedFileName)) {
				// redirectAttributes.addFlashAttribute("msg", "Please select a folder to
				// upload");
				objectToReturn = "{ msg: 'value1' }";
			} else {
				// redirectAttributes.addFlashAttribute("msg", "You successfully uploaded '" +
				// uploadedFileName + "'");
				objectToReturn = "{ msg: 'value2' }";
			}

		}
		try {
			Process p1 = Runtime.getRuntime().exec("chown -R 1001:1001 /home/term");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return objectToReturn;
		// return "redirect:/terminal";
	}

	@RequestMapping(value = "/terminal/getdropdownvalues", method = RequestMethod.GET, produces = "application/json")
	public @ResponseBody Map<String, String> refreshDropdownValues(Model model, RedirectAttributes redirectAttributes) {
		System.out.println("Uploaded folder path" + UPLOADED_FOLDER);
		Map<String, String> listofpath = new HashMap<String, String>();
		walk(UPLOADED_FOLDER, listofpath);
		System.out.println(listofpath.keySet());
		System.out.println(listofpath.values());
		return listofpath;
	}

	@RequestMapping(value = "/terminal/download/{file_name}/**", produces = "application/zip")
	@ResponseBody
	public HttpServletResponse downloadFolder(@PathVariable("file_name") String moduleBaseName,
			HttpServletRequest request, HttpServletResponse response) {
		final String path = request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE).toString();
	    final String bestMatchingPattern = request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE).toString();

	    moduleBaseName = "/" + moduleBaseName;
		String arguments = new AntPathMatcher().extractPathWithinPattern(bestMatchingPattern, path);

		System.out.println(moduleBaseName + " module base name and args:" + arguments);

		String moduleName;
		if (null != arguments && !arguments.isEmpty()) {
			moduleName = moduleBaseName + '/' + arguments;
		} else {
			moduleName = moduleBaseName;
		}
		System.out.println("ModuleName is " + moduleName);



		try {
			String temparray[] = moduleName.split("/");
			String filename = temparray[temparray.length - 1];
			// get your file as InputStream
			File fileToDownload = new File(moduleName.replace("\\", "/"));

			Map<String, String> filestozip = new HashMap<String, String>();
			walk(moduleName, filestozip);

			response.setStatus(HttpServletResponse.SC_OK);
			response.setCharacterEncoding("UTF-8");
			response.setContentType("application/zip; charset=UTF-8");
			response.setHeader("Content-Disposition", "attachment;filename=" + filename + ".zip");

			ZipOutputStream zipOutputStream = new ZipOutputStream(response.getOutputStream());

			zipDir(moduleName, zipOutputStream);
			zipOutputStream.close();

		} catch (IOException ex) {
			logger.info("Error writing file to output stream. Filename was '{}'", moduleName, ex);
			throw new RuntimeException("IOError writing file to output stream");
		}

		return response;

	}

	@GetMapping("/compile")
	public String uploadStatus() {
		logger.info("Rendering compile page");
		return "compile";
	}
	
	@RequestMapping(value = "/compilejob", method = RequestMethod.POST, produces = "application/json")
	public String compilejob(@RequestParam("system") String system, @RequestParam("driver") MultipartFile driver,
			@RequestParam("ccommand") String ccommand, @RequestParam("outfiles") String outFileName, RedirectAttributes redirectAttributes) {
		System.out.println(system + ",  " + ccommand);

		if (driver.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "Please select a file to upload");
			// return "redirect:/compile";
		}


		try {
			File f = new File("compile01.zip");
			ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(f));
			
			String inputFileName=driver.getOriginalFilename();
			ZipEntry e = new ZipEntry(inputFileName);
			zipOutputStream.putNextEntry(e);
			zipOutputStream.write(driver.getBytes(), 0, driver.getBytes().length);
			zipOutputStream.closeEntry();
            
			
			ZipEntry e1 = new ZipEntry("command.sh");
			zipOutputStream.putNextEntry(e1);
			StringBuilder sb = new StringBuilder();
			sb.append("#!/bin/bash\r\n\n");
			String cmdLine=ccommand+" -o "+outFileName+" "+inputFileName;
			sb.append(cmdLine);
			byte[] data = sb.toString().getBytes();
			zipOutputStream.write(data, 0, data.length);
			zipOutputStream.closeEntry();
			
			zipOutputStream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		try {
			Process p = Runtime.getRuntime().exec("scp -o \"StrictHostKeyChecking no\"-i /home/term/.ssh/PrivateKey.ppk /home/term/compile01.zip akn752@comet.sdsc.edu:/home/akn752");
		}catch (IOException e) {
			e.printStackTrace();
		}
		
		return "compile";
		
	}
	
	@GetMapping("/run")
	public String runStatus() {
		logger.info("Rendering run page");
		return "run";
	}
	
	@RequestMapping(value = "/runjob", method = RequestMethod.POST, produces = "application/json")
	public String runjob(@RequestParam("system") String system,
			@RequestParam("rcommand") String rcommand,
			@RequestParam("jobq") String jobq,
			
			@RequestParam("numcores") String numcores, 
			@RequestParam("numnodes") String numnodes, 
			
			@RequestParam("binary") MultipartFile binary,
			RedirectAttributes redirectAttributes) {
		System.out.println(system + ",  " + rcommand);

		if (binary.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "Please select a file to upload");
			// return "redirect:/compile";
		}


		try {
			File f = new File("run01.zip");
			ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(f));
			
			String inputFileName=binary.getOriginalFilename();
			ZipEntry e = new ZipEntry(inputFileName);
			zipOutputStream.putNextEntry(e);
			zipOutputStream.write(binary.getBytes(), 0, binary.getBytes().length);
			zipOutputStream.closeEntry();
            
			
			ZipEntry e1 = new ZipEntry("run.sh");
			zipOutputStream.putNextEntry(e1);
			StringBuilder sb = new StringBuilder();
			sb.append("#!/bin/bash\r\n\n");
			String cmdLine=rcommand;
			sb.append(cmdLine);
			byte[] data = sb.toString().getBytes();
			zipOutputStream.write(data, 0, data.length);
			zipOutputStream.closeEntry();
			
			
			ZipEntry e2 = new ZipEntry("username.txt");
			zipOutputStream.putNextEntry(e2);
			StringBuilder sb2 = new StringBuilder();
			String cmdLine2="This run job is being submitted on behalf of user \"abc012\".";
			sb2.append(cmdLine2);
			byte[] data2 = sb2.toString().getBytes();
			zipOutputStream.write(data2, 0, data2.length);
			zipOutputStream.closeEntry();
			
			zipOutputStream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		try {
			Process p = Runtime.getRuntime().exec("scp -o \"StrictHostKeyChecking no\"-i /home/term/.ssh/PrivateKey.ppk /home/term/run01.zip akn752@comet.sdsc.edu:/home/akn752");
		}catch (IOException e) {
			e.printStackTrace();
		}
		
		return "run";
		
	}

	@GetMapping("/uploadMultiPage")
	public String uploadMultiPage() {
		return "uploadMulti";
	}

	public void walk(String path, Map<String, String> listofpath) {

		File root = new File(path);
		File[] list = root.listFiles();

		if (list == null)
			return;

		for (File f : list) {
			if (f.isDirectory() && (!f.getName().startsWith("."))) {
				listofpath.put(f.getName(), f.getAbsoluteFile().getAbsolutePath() + File.separator);
				walk(f.getAbsolutePath(), listofpath);
			} else {
				if (!f.getName().startsWith("."))
					listofpath.put(f.getName(), f.getAbsoluteFile().getAbsolutePath());
			}
		}
	}

	public void zipDir(String dir2zip, ZipOutputStream zos) {
		try {
			// create a new File object based on the directory we have to zip
			System.out.println("Dir to ZIP " + dir2zip);
			File zipDir = new File(dir2zip);

			int bytesIn = 0;
			byte[] readBuffer = new byte[2156];
			if (zipDir.isDirectory()) {
				// get a listing of the directory content
				String[] dirList = zipDir.list();

				// loop through dirList, and zip the files
				for (int i = 0; i < dirList.length; i++) {
					File f = new File(zipDir, dirList[i]);

					// If its a directory loop again.
					if (f.isDirectory()) {
						String filePath = f.getPath();
						zipDir(filePath, zos);
						continue;
					}

					FileInputStream fis = new FileInputStream(f);
					ZipEntry anEntry = new ZipEntry(f.getPath());
					System.out.println("THIS IS ENTRY**********" + anEntry);
					zos.putNextEntry(anEntry);
					while ((bytesIn = fis.read(readBuffer)) != -1) {
						zos.write(readBuffer, 0, bytesIn);
					}
					fis.close();
				}
			} else {
				FileInputStream fis = new FileInputStream(zipDir);
				ZipEntry anEntry = new ZipEntry(zipDir.getPath());
				System.out.println("THIS IS ENTRY**********" + anEntry);
				zos.putNextEntry(anEntry);
				while ((bytesIn = fis.read(readBuffer)) != -1) {
					zos.write(readBuffer, 0, bytesIn);
				}
				fis.close();

			}
		} catch (Exception e) {
			logger.error("Error During zipping file");
			e.printStackTrace();
		}
	}
}