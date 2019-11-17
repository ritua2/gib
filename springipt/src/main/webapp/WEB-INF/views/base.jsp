<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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


<body style="background: #e9ebf0">


	<div class="main-banner">
			<img src="${contextPath}/resources/images/IPT-Banner.jpg"
				class="img-responsive" alt="IPT Banner" style="width: 100%;">
	</div>

	<!-- Navbar -->
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="/"><img
					src="${contextPath}/resources/images/IPT-Fut.svg"></a>
				<!--<a class="navbar-brand">Interactive Parallelization Tool</a> -->
			</div>


			<!--Tabs-->
			<div class="container">
				<ul class="nav nav-tabs">
					<c:if test="${pageContext.request.userPrincipal.name != null}">
						<li>&emsp;&emsp;&emsp;&nbsp;&nbsp;</li>
						<c:if test="${sessionScope.is_admin == 'true'}">
							<li id='admin-tab'><a href="${contextPath}/admin" style="color: #ffffff;">Admin</a></li>
						</c:if>
						<li id='terminal-tab'><a href="${contextPath}/terminal" style="color: #ffffff;">Terminal</a></li>
						
						<c:if test="${(sessionScope.is_admin == 'true')||(sessionScope.is_ldap == 'true')}">
							<li id='run-tab'><a href="${contextPath}/compileRun" style="color: #ffffff;">Compile & Run</a></li>
						</c:if>
						<li id='history-tab'><a href="${contextPath}/jobHistory" style="color: #ffffff;">Job History</a></li>

						<li id='help-tab' >
							<a data-toggle="dropdown" href="#" aria-expanded="false" style="color: #ffffff;">Help
			                	<span class="caret"></span>
			            	</a>
			                <ul class="dropdown-menu" style="margin-left: -10px;margin-top: 0px">
				                <li><a href="/faq" style="color: #555555;">FAQ</a></li>
				                <li><a href="/help" style="color: #555555;">User Guide</a></li>
								<li><a href="/vdemos" style="color: #555555;">Video Demos</a></li>
								<li><a href="/contactus" style="color: #555555;">Contact Us</a></li>				
			                </ul>
						</li>
						

						<li id='compile-tab'><a href="${contextPath}/comments" style="color: #ffffff;">Message Board</a></li> 
						<li id='aboutus-tab'><a href="${contextPath}/aboutus" style="color: #ffffff;">About Us</a></li>
						<li>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</li>
						<li id="username-tab"><a href="/" style="color: #ffffff;">Welcome ${pageContext.request.userPrincipal.name}</a></li>
						<li id="logout-tab" >
							<a href="${contextPath}/perform_logout" style="color: #ffffff;">
								<span class="glyphicon glyphicon-log-out">Logout</span>
							</a>
						</li>
					</c:if>

					<c:if test="${pageContext.request.userPrincipal.name == null}">
						<li>&emsp;&emsp;&emsp;&nbsp;&nbsp;</li>

						<li id='help-tab' >
							<a data-toggle="dropdown" href="#" aria-expanded="false" style="color: #ffffff;">Help
			                	<span class="caret"></span>
			            	</a>
			                <ul class="dropdown-menu" style="margin-left: -10px;margin-top: 0px">
				                <li><a href="/faq" style="color: #555555;">FAQ</a></li>
				                <li><a href="/help" style="color: #555555;">User Guide</a></li>
								<li><a href="/vdemos" style="color: #555555;">Video Demos</a></li>
								<li><a href="/contactus" style="color: #555555;">Contact Us</a></li>				
			                </ul>
						</li>
						<li id='compile-tab'><a href="${contextPath}/comments" style="color: #ffffff;">Message Board</a></li> 
						<li id='aboutus-tab'><a href="${contextPath}/aboutus" style="color: #ffffff;">About Us</a></li>
						<li>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</li><li id="signup-tab"><a href="/registration" style="color: #ffffff;">Sign Up</a></li>
						<li id="login-tab" ><a href="/login_normal" style="color: #ffffff;">Log In</a></li>
					</c:if>

				</ul>
				<!-- End Tabs -->

			</div>

		</div>
	</nav>



	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
		integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
		crossorigin="anonymous"></script>
	<!-- Latest compiled and minified JavaScript -->
	<script
		src="https://cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min.js"></script>
	

	<div style="padding-bottom: 10rem;"></div>
