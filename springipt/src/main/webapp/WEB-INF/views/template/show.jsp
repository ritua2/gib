<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:include page="../base.jsp" />




<div class="container" style="padding-left: 80px;padding-right: 130px">

	<c:if test="${not empty msg}">
		<div class="alert alert-${css} alert-dismissible" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">&times;</span>
			</button>
			<strong>${msg}</strong>
		</div>
	</c:if>

	<h1>Comment Details</h1>
	<br />

	<div class="row">
		<label class="col-sm-2">ID</label>
		<div class="col-sm-10">${comment.id}</div>
	</div>

	<div class="row">
		<label class="col-sm-2">Title</label>
		<div class="col-sm-10">${comment.title}</div>
	</div>

	<div class="row">
		<label class="col-sm-2">Body</label>
		<div class="col-sm-10">${comment.body}</div>
	</div>

	<div class="row">
		<label class="col-sm-2">Tag</label>
		<div class="col-sm-10">${comment.tag}</div>
	</div>


</div>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${contextPath}/resources/js/bootstrap.min.js"></script>


<jsp:include page="../footer.jsp" />