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
       <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3441.627639109634!2d-97.72832288439244!3d30.38992978175791!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8644cb89ec2a322b%3A0x86afcc8dc7608457!2sTexas%20Advanced%20Computing%20Center!5e0!3m2!1sen!2sus!4v1573015347332!5m2!1sen!2sus" width="600" height="450" frameborder="0" style="border:0;" allowfullscreen=""></iframe>
        </td><td width="100%">
        <div style="margin-left: 50px; ">
          <h2>Team</h2>
          <p style="font-size: 20px">Ritu Arora:<br><a href="mailto:rauta@tacc.utexas.edu">rauta@tacc.utexas.edu</a></p>
          <p style="font-size: 20px">Carlos Redondo:<br><a href="mailto:carlos.red@utexas.edu">carlos.red@utexas.edu</a></p>
          <p style="font-size: 20px">Krishan Pal:<br><a href="mailto:ksingh35@binghamton.edu">ksingh35@binghamton.edu</a></p>
          <p style="font-size: 20px">Hannah DeVault:<br><a href="mailto:hdev@utexas.edu">hdev@utexas.edu</a></p>
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
