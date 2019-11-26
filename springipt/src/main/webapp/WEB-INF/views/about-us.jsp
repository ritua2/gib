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
        
      <figure style="display: inline-block;">
        <img src="/resources/images/Carlos.jpg" alt="Carlos Redondo" height="225" width="225"/>
        <figcaption><a href="https://www.linkedin.com/in/carlos-redondo-albertos/">Carlos Redondo</a><br>Undergraduate Research Assistant</figcaption>
      </figure>

      &nbsp;&nbsp;

      <figure style="display: inline-block;">
        <img src="/resources/images/Ritu.jpg" alt="Ritu Arora" height="225" width="225"/>
        <figcaption><a href="https://www.linkedin.com/in/ritu-arora-59b58ab/">Ritu Arora</a><br>Research Scientist</figcaption>
      </figure>

      &nbsp;&nbsp;

      <figure style="display: inline-block;">
        <img src="/resources/images/Trung.jpg" alt="Trung Nguyen" height="225" width="225"/>
        <figcaption><a href="https://www.linkedin.com/in/trung-nguyen-ba-517389a4/">Trung Nguyen</a><br>Research Assistant</figcaption>
      </figure>

      &nbsp;&nbsp;

      <figure style="display: inline-block;">
        <img src="/resources/images/Hannah.jpg" alt="Hannah DeVault" height="225" width="225"/>
        <figcaption><a href="https://linkedin.com/in/hannah-devault-utbme2020/">Hannah DeVault</a><br>Undergraduate Research Assistant</figcaption>
      </figure>

    </div>

  </section>

  <section class="row container" style="text-align:center;">
      <h2 class="h2 text-center">
          Previous Contributors
      </h2>

      <div>
          
        <figure style="display: inline-block;">
          <img src="/resources/images/KP.JPG" alt="Krishan Pal Singh" height="225" width="225"/>
          <figcaption><a href="https://www.linkedin.com/in/krishanpal/">Krishan Pal Singh</a><br>Graduate Research Assistant</figcaption>
        </figure>

        &nbsp;&nbsp;

        <figure style="display: inline-block;">
          <img src="/resources/images/Joshua.jpg" alt="Gerald Joshua" height="225" width="225"/>
          <figcaption><a href="https://www.linkedin.com/in/geraldjoshua/">Gerald Joshua</a><br>Undergraduate Research Assistant</figcaption>
        </figure>

        &nbsp;&nbsp;

        <figure style="display: inline-block;">
          <img src="/resources/images/Anubhaw.jpg" alt="Anubhaw K. Nand" height="225" width="225"/>
          <figcaption><a href="https://www.linkedin.com/in/anubhawn/">Anubhaw K. Nand</a><br>Graduate Student Intern</figcaption>
        </figure>

      </div>


  </section>
</div>




<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${contextPath}/resources/js/bootstrap.min.js"></script>

<jsp:include page="footer.jsp" />
