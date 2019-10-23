<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:include page="base.jsp" />

<div class="container"   style="padding-left: 80px;padding-right: 130px">	
<h1>FAQs</h1>
<h5>
What is the difference between logging in as an IPT user vs TACC user?
<br>
Answer:
<br>
Does it matter which I log in as? 
Answer: 
<br>
<br>
I just uploaded a file but when I type ls in the terminal I do not see my file?
<br>
Answer: Hit the Refresh List button
<br>
<br>
How do I know if my files successfully uploaded? 
<br>
Answer: Type ls in the directory that the files were uploaded in.
<br>
<br>
What directory to files get uploaded to?
<br>
Answer: /home/gib/
<br>
<br>
It does not matter if this is not the current directory that the user is in. 
What types of actions can you perform in the terminal?
<br>
Answer: Any basic linux commands, create and edit files, as well as compile and run programs. 
<br>
<br>
How do I submit a job?
<br>
Answer: Please have a look at Readme file in git. You can only submit jobs only when you are TACC user.
<br>
<br>
I do not see my job showing in the list?
<br>
Answer: The job hasn't been stored in DB, please check your DB connection.
<br>
</h5>
                

</div>	
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${contextPath}/resources/js/bootstrap.min.js"></script>

<jsp:include page="footer.jsp" />



