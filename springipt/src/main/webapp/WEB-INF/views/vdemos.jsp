<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:include page="base.jsp" />
<html>
<head>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

<title>Video Demos</title>
<!-- <link href="${contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet">-->


</head>
<body>
<div class="container">		
 <h3>The usage of IPT is demonstrated through the following videos:</h3>
 <br><br>
 <table>
 <tbody><tr>
 <td><h4>OpenMP Version of Molecular Dynamics Code Using the Interactive Parallelization Tool</h4>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/JH7o_k9Bxd0?rel=0" frameborder="0" allowfullscreen=""></iframe>
		</td><td style="padding-left: 20px;">
 <h4>Interactive Parallelization Tool - Parallelizing Molecular Dynamics with MPI</h4>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/HvlA4pnfFjE?rel=0" frameborder="0" allowfullscreen=""></iframe>
 </td>
 </tr>
    <tr><td><br><br></td><td></td></tr>
 <tr>
 <td>
 <h4>The Interactive Parallelization Tool - Parallelizing the FFT Algorithm with CUDA</h4>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/kCOjqza7OG8?rel=0" frameborder="0" allowfullscreen=""></iframe>
 </td>
 <td style="padding-left: 20px;">
 <h4>The Interactive Parallelization Tool - Parallelizing the FFT algorithm with OpenMP</h4>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/L4a19kF6q48?rel=0" frameborder="0" allowfullscreen=""></iframe>
 </td>
 </tr>
    <tr><td><br><br></td><td></td></tr>
 <tr>
 <td >
 <h4 >The Interactive Parallelization Tool - Parallelizing the FFT algorithm with MPI</h4>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/sg9HDTz0zbo?rel=0" frameborder="0" allowfullscreen="" ></iframe>
 </td>
  <td > </td >
 </tr>
 </tbody><br><br></table>
 </div>       
		
	
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${contextPath}/resources/js/bootstrap.min.js"></script>
</body>
</html>
<jsp:include page="footer.jsp" />



