<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<jsp:include page="base.jsp" />


<body>
<div class="container">
		<table class="table table-hover">
            <tr>
                <thead>
                <th>ID</th>
                <th>Name</th>
                <th>Status</th>
                <th>Start</th>
                <th>End</th>
                </thead>
            </tr>
            <c:forEach var="job" items="${jobs}">
            <tr>
                <td>${job.user}</td>
                <td>${job.name}</td>
                <td>${job.status}</td>
                <td>${job.startTime}</td>
                <td>${job.endTime}</td>
                <td></td>
            </tr>
            </c:forEach>
        </table>
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
<jsp:include page="footer.jsp" />

</body>
</html>