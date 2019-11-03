<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:include page="base.jsp" />


<div class="container">
    <section class="row container" style="text-align:center;">
        <h2 class="h2 text-center">
            Project Team
        </h2>

                
                
            
        
<div>
    <div class="nova team-overview">
        <figure><img alt="" src="/springipt/resources/images/Carlos.jpg" height="225" width="225">
            <img alt="" src="/springipt/resources/images/KP.JPG" height="225" width="225">
            <img alt="" src="/springipt/resources/images/Ritu.jpg">
            <img alt="" src="/springipt/resources/images/Trung.jpg" height="225" width="225">
        </figure>
    </div>

    <div class="nova title">
        <h4>
            <a href="https://www.linkedin.com/in/carlos-redondo-albertos/" style="margin-left: -40px">Carlos Redondo</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.linkedin.com/in/krishanpal/">Krishan Pal Singh</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.linkedin.com/in/ritu-arora-59b58ab/">Ritu Arora</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.linkedin.com/in/trung-nguyen-ba-517389a4/">Trung Nguyen</a>
        </h4>

        <p style="margin-left: -80px">Undergraduate Research Assistant&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Graduate Research Assistant&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Research Scientist&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Research Assistant</p>
    </div>
</div>

<div>

    <div class="nova team-overview">
        <figure><img alt="" src="/springipt/resources/images/Hannah.jpg" height="225" width="225"></figure>
    </div>

    <div class="nova title">
    <h4>
        <a href="https://linkedin.com/in/hannah-devault-utbme2020/"> Hannah DeVault</a>
    </h4>

    <p style="margin-left: -80px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Undergraduate Research Assistant</p></div>

</div>

</section>

    <section class="row container" style="text-align:center;">
        <h2 class="h2 text-center">
            Previous Contributors
        </h2>
        <div>
            <div class="nova team-overview">
                <figure><img alt="" src="/springipt/resources/images/Joshua.jpg" height="225" width="225">
                <img alt="" src="/springipt/resources/images/Anubhaw.jpg" height="225" width="225"></figure>
            </div>
            <div class="nova title">
                <h4><a href="https://www.linkedin.com/in/geraldjoshua/">Gerald Joshua</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.linkedin.com/in/anubhawn/">Anubhaw K Nand</a></h4>
                <p>Undergraduate Student Intern&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Graduate Student Intern</p>
            </div>
        </div>
    </section>
</div>




<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${contextPath}/resources/js/bootstrap.min.js"></script>

<jsp:include page="footer.jsp" />
