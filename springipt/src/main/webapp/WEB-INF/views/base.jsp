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
	<!--<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">

				<a class="navbar-brand">Interactive Parallelization Tool</a>
			</div>

			<ul class="nav navbar-nav navbar-right">


					<c:if test="${pageContext.request.userPrincipal.name != null}">
						<form id="logoutForm" method="POST" action="${contextPath}/logout">
							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}" />
						</form>


							Welcome ${pageContext.request.userPrincipal.name} | <a
								onclick="document.forms['logoutForm'].submit()"><span
						class="glyphicon glyphicon-log-out">Logout</span></a>


					</c:if>


				<li><a href="{% url 'logout' %}"><span
						class="glyphicon glyphicon-log-out"></span> Logout</a></li>

				<li><a href="{% url 'login' %}"><span
						class="glyphicon glyphicon-log-out"></span> Login</a></li>

			</ul>
		</div>
	</nav>-->

	<!-- Header -->
	<!-- Navbar -->
	<nav class="navbar navbar-inverse navbar-fixed-top">
	  <div class="container-fluid">
	    <div class="navbar-header">
	      <a class="navbar-brand" href="${contextPath}/welcome">TACC | IPT</a>
	    </div>

	    <ul class="nav navbar-nav navbar-right">
	      <!--<li class="active"><a href="#">Home</a></li>
	      <li><a href="#">Page 1</a></li>
	      <li><a href="#">Page 2</a></li>
	      <li><a href="#">Page 3</a></li>
	      <li><a href="#">Log Out</a></li>
	      <li><a href="${contextPath}/login">Log In</a></li>-->
	      <c:if test="${pageContext.request.userPrincipal.name != null}">
			<form id="logoutForm" method="POST" action="${contextPath}/logout">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
			</form>
			<li><a href="#">Welcome, ${pageContext.request.userPrincipal.name}</a></li>
	      	<li><a href="#" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
		  </c:if>
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
	<!-- End of IPT Banner -->

	<c:if test="${pageContext.request.userPrincipal.name != null}">
		<!--Tabs-->
		<div class="container">
			<ul class="nav nav-tabs ">
				<li id='terminal-tab'>
					<a href="${contextPath}/terminal">Terminal</a>
				</li>
				<li id='compile-tab'>
					<a href="${contextPath}/compile">Compile</a>
				</li>
				<li id='run-tab'>
					<a href="${contextPath}/run">Run</a>
				</li>
				<li id='history-tab'>
					<a href="{% url 'history' %}">Job History</a>
				</li>
				<li id='help-tab'>
					<a href="{% url 'help' %}">Help</a>
				</li>
				<li id='admin-tab'>
					<a href="{% url 'admin' %}">Admin</a>
				</li>
				<li id='compile-tab'>
					<a href="${contextPath}/comments">Messageboard</a>
				</li>
			</ul>

			<div class="tab-content">


				<!-- <div class="messages">
	        {% for message in messages %}
	          <p{% if message.tags %} class="{{ message.tags }}" {% endif %}>{{ message }}</p>
	        {% endfor %}
	      	</div> -->

			</div>
		</div>
	</c:if>
	<!-- End of Tabs -->
	<!-- End of Header -->
