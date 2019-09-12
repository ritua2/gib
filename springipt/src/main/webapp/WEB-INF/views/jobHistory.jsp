<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:include page="base.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Job History</title>

    <!-- <link href="${contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet">-->

</head>
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

		

		<table class="table table-striped">
			<thead>
				<tr>
					<th>ID</th>
					<th>Type</th>
					<th>Status</th>
					<th>No. Nodes</th>
					<th>No. Cores</th>
					<th>Submission Date</th>
					<th>Start Date</th>
					<th>Date Received</th>
					<th>Execution Time(s)</th>
					<th>Error</th>
						
					
				</tr>
			</thead>
			


			<c:forEach var="job" items="${jobs}">
				<tr>
					
					<td>${job.id}</td>
					<td>${job.type}</td>
					<td>${job.status}</td>
					<td>${job.n_nodes}</td>
					<td>${job.n_cores}</td>
					<td>${job.date_submitted}</td>
					<td>${job.date_started}</td>
					<td>${job.date_server_received}</td>
					<td>${job.sc_execution_time}</td>
					<td>${job.error}</td>

					
				</tr>
			</c:forEach>
				
			
		</table>

	</div>

	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${contextPath}/resources/js/bootstrap.min.js"></script>
</body>
</html>
<jsp:include page="footer.jsp" />