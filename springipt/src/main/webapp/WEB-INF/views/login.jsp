<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:include page="base.jsp" />

<!--<div class="container">
    <div class="content">
        <form method="POST" action="${contextPath}/login" class="form-signin">
            <h2 class="form-heading">Log in</h2>

            <div class="form-group ${error != null ? 'has-error' : ''}">
                <span>${message}</span>
                <input name="username" type="text" class="form-control" placeholder="Username"
                       autofocus="true"/>
                <input name="password" type="password" class="form-control" placeholder="Password"/>
                <span>${error}</span>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <button class="btn btn-lg btn-primary btn-block" type="submit">Log In</button>
                <h4 class="text-center"><a href="${contextPath}/registration">Create an account</a></h4>
            </div>

        </form>

    </div>
</div>-->
<c:if test="${pageContext.request.userPrincipal.name != null}">
    <script>window.location.replace("${contextPath}/welcome");</script>
</c:if>

<div class="Site-content">
  <!-- LOGIN FORM -->
  <div class="text-center" style="padding:50px 0" id="login_form">
    <div class="logo">LOGIN</div>
    <!-- Main Form -->
    <div class="login-form-1">
        <form method="POST" action="${contextPath}/login" id="login-form" class="text-left">
            <div class="login-form-main-message"></div>
            <div class="main-login-form ${error != null ? 'has-error' : ''}">
                <span>${message}</span>
                <div class="login-group">
                    <div class="form-group">
                        <label for="lg_username" class="sr-only">Username</label>
                        <input type="text" class="form-control" id="lg_username" name="username" placeholder="Username">
                    </div>
                    <div class="form-group">
                        <label for="lg_password" class="sr-only">Password</label>
                        <input type="password" class="form-control" id="lg_password" name="password" placeholder="Password">
                    </div>
                    <div class="form-group login-group-checkbox">
                        <input type="checkbox" id="lg_remember" name="lg_remember">
                        <label for="lg_remember">remember</label>
                    </div>
                </div>
                <button type="submit" class="login-button">
                    <i class="fa fa-chevron-right"></i>
                </button>
            </div>
            <span>${error}</span>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="etc-login-form">
                <p>forgot your password? <a href="#" class="forgot_password_section">click here</a></p>
                <p>new user? <a href="${contextPath}/registration" class="signup_section">create new account</a></p>
            </div>
        </form>
    </div>
    <!-- end of Main Form -->
  </div>
  <!-- End of Login Form -->

    <!-- FORGOT PASSWORD FORM -->
    <div class="text-center" style="padding:50px 0" id="forgot_password_form">
        <div class="logo">FORGOT PASSWORD</div>
        <!-- Main Form -->
        <div class="login-form-1">
            <form id="forgot-password-form" class="text-left">
                <div class="etc-login-form">
                    <p>You will be sent instructions on how to reset your password.</p>
                </div>
                <div class="login-form-main-message"></div>
                <div class="main-login-form">
                    <div class="login-group">
                        <div class="form-group">
                            <label for="fp_email" class="sr-only">Email address</label>
                            <input type="text" class="form-control" id="fp_email" name="fp_email" placeholder="Email Address">
                        </div>
                    </div>
                    <button type="submit" class="login-button"><i class="fa fa-chevron-right"></i></button>
                </div>
                <div class="etc-login-form">
                    <p>already have an account? <a href="#" class="login_section">login here</a></p>
                    <p>new user? <a href="${contextPath}/registration" class="signup_section">create new account</a></p>
                </div>
            </form>
        </div>
        <!-- end:Main Form -->
    </div>
   <!-- End of FORGOT PASSWORD FORM -->

</div>

<!-- /container -->
<jsp:include page="footer.jsp" />