<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<jsp:include page="../base.jsp" />
<jsp:include page="../fragments/header.jsp" />

<body>

	<div class="container">

		<c:if test="${not empty msg}">
			<div class="alert alert-${css} alert-dismissible" role="alert">
				<button type="button" class="close" data-dismiss="alert"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<strong>${msg}</strong>
			</div>
		</c:if>

		<h1>All Comments</h1>

		<table class="table table-striped">
			<thead>
				<tr>
					<th>#ID</th>
					<th>Title</th>
					<th>Body</th>
					<th>Tag</th>
				</tr>
			</thead>

			<c:forEach var="comment" items="${comments}">
				<tr>
					<td>${comment.id}</td>
					<td>${comment.title}</td>
					<td>${comment.body}</td>
					<td>${comment.tag}</td>

					<td><spring:url value="/comments/${comment.id}" var="userUrl" />
						<spring:url value="/comments/${comment.id}/update" var="updateUrl" />
						<spring:url value="/comments/${comment.id}/delete" var="deleteUrl" />
						<spring:url value="/comments/${comment.id}/reply" var="replyUrl" />

						<button class="btn btn-info" onclick="location.href='${userUrl}'">Query</button>
						<button class="btn btn-primary"
							onclick="location.href='${updateUrl}'">Update</button>
						<button class="btn btn-danger"
							onclick="this.disabled=true;post('${deleteUrl}')">Delete</button>
						<button class="btn btn-success"
							onclick="this.disabled=true;post('${replyUrl}')">Reply</button></td>
				</tr>
				<c:forEach var="reply" items="${comment.replies}">
					<tr>
						<td></td>
						<td>${reply.title}</td>
						<td>${reply.body}</td>
						<td>${reply.tag}</td>
						<td></td>
					</tr>
				</c:forEach>
			</c:forEach>
		</table>

	</div>

	<jsp:include page="../fragments/footer.jsp" />

</body>
</html>