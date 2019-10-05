<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:include page="base.jsp" />

	<div class="container" style="padding-left: 80px;padding-right: 130px">	
<div style="width: 100%;"><table align="centre">
    <tbody><tr>
    <td>
       <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d14307.300161689365!2d-97.73662675857256!3d30.387684017313866!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8644cb88892ec28d%3A0x397fa14bd983eafa!2sJ.%20J.%20Pickle%20Research%20Campus%2C%20The%20University%20of%20Texas%20at%20Austin!5e0!3m2!1sen!2sus!4v1567626571257!5m2!1sen!2sus" width="600" height="450" frameborder="0" style="border:0;" allowfullscreen=""></iframe>
        </td><td width="100%">
        <div style="margin-left: 50px; ">
          <h2>Team</h2>
          <p style="font-size: 20px">Ritu Arora: <a href="rauta@tacc.utexas.edu">rauta@tacc.utexas.edu</a></p>
          <p style="font-size: 20px">Carlos Redondo: <a href="mailto:carlos.red@utexas.edu">carlos.red@utexas.edu</a></p>
          <p style="font-size: 20px">Krishan Pal: <a href="mailto:ksingh35@binghamton.edu">ksingh35@binghamton.edu</a></p>
          </div>
        <div style="margin-left: 50px">
          <h2>Phone / Fax</h2>
          <p>(To be updated)<br>(To be updated)<br><br><strong>Email ID:</strong><a href="mailto:someone@tacc.com">To be added.</a></p>
          </div>
        
        </td>
    </tr>    
    </tbody></table>

</div>
	</div>
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${contextPath}/resources/js/bootstrap.min.js"></script>

<jsp:include page="footer.jsp" />



