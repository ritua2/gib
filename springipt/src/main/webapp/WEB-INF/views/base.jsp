<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Interactive Parallelization Tool</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
	integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
<!-- Latest compiled and minified CSS -->
<link href="${contextPath}/resources/css/main.css" rel="stylesheet">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src='https://www.google.com/recaptcha/api.js'></script>
</head>
<%--
<spring:url value="/" var="urlHome" />
<spring:url value="terminal" var="urlTerminal" />
 --%>
<body>
	<!-- Navbar -->
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand"><img
					src="${contextPath}/resources/images/IPT-Fut.svg"></a>
				<!--<a class="navbar-brand">Interactive Parallelization Tool</a> -->
			</div>

			<ul class="nav navbar-nav navbar-right">


					<c:if test="${pageContext.request.userPrincipal.name != null}">
						<!--<form id="logoutForm" method="POST" action="${contextPath}/perform_logout">
							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}" />-->
						</form>

						
							Welcome ${pageContext.request.userPrincipal.name} | <!--<a
								onclick="document.forms['logoutForm'].submit()"><span
						class="glyphicon glyphicon-log-out">Logout</span></a>-->
						<a
								href="${contextPath}/perform_logout"><span
						class="glyphicon glyphicon-log-out">Logout</span></a>


					</c:if>


				<!-- <li><a href="{% url 'logout' %}"><span
						class="glyphicon glyphicon-log-out"></span> Logout</a></li>

				<li><a href="{% url 'login' %}"><span
						class="glyphicon glyphicon-log-out"></span> Login</a></li> -->

			</ul>
		</div>

	</nav>
	<!-- End of Navbar -->

	<!-- IPT Banner -->
	<div class="main-banner">
		<p>
			<img src="${contextPath}/resources/images/IPT-Banner.jpg"
				class="img-responsive" alt="IPT Banner">
		</p>
	</div>
	
	

	<!--Tabs-->
	<div class="container">
		<ul class="nav nav-tabs">
			<li id='terminal-tab'><a href="${contextPath}/terminal">Terminal</a></li>
			<li id='compile-tab'><a href="${contextPath}/compile">Compile</a></li>
			<li id='run-tab'><a href="${contextPath}/run">Run</a></li>
			<li id='history-tab'><a href="${contextPath}/jobHistory">Job
					History</a></li>
			<li id='help-tab'><a href="${contextPath}/help">Help</a></li>

			<li id='admin-tab'><a href="${contextPath}/admin">Admin</a></li>
			<li id='compile-tab'><a href="${contextPath}/comments">Messageboard</a></li>
		</ul>
		<!-- End Tabs -->

			<div class="tab-content">


				<!-- <div class="messages">
	        {% for message in messages %}
	          <p{% if message.tags %} class="{{ message.tags }}" {% endif %}>{{ message }}</p>
	        {% endfor %}
	      	</div> -->

		</div>
	</div>

		
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
		integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
		crossorigin="anonymous"></script>
	<!-- Latest compiled and minified JavaScript -->
	<script
		src="https://cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min.js"></script>
	<script>
		var link_was_clicked = false;
document.addEventListener("click", function(e) {
  if (e.target.nodeName.toLowerCase() === 'a') {
    link_was_clicked = true;
  }
}, true);

window.onbeforeunload = function(event) {
	if(link_was_clicked===true){
	console.log("abc1");
	//event.returnValue=null;
	link_was_clicked = false;
	}else{
	console.log("abc2");
    //event.returnValue = "Write something clever here..";
	//return "";
	
	}
	
};
	</script>
		




</body>
</html>
