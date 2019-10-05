<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:include page="base.jsp" />

<script src="${contextPath}/resources/js/bootstrap.min.js"></script>

<br />
<br />
<div class="container">
<div class="container-fluid" style=" z-index: 5;  
margin:-35px 0px 0px 0px; 
padding:45px 415px 35px 65px; 
text-align: left; 
font-size: 1.2em; 
border-radius: 0px;">
    <center>
        <h1>Welcome to IPT, ${pageContext.request.userPrincipal.name}!</h1>
    </center>
</div>
</div>
<br/>
<br/>

<!-- /container -->
<jsp:include page="footer.jsp" />