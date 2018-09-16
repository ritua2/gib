<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<jsp:include page="base.jsp" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
</head>
<body>
<div class="tab-content">
<h1>Launching a Compile Job</h1>
<p>This form will guide you towards composing the command for compiling your serial or parallel programs on TACC/XSEDE resources. Please upload all the files that are external to your program but are required for compiling it successfully, such as, header files and other C/C++ program files.</p>
<p> The output from your jobs can be found in <strong>/home/ipt/jobs/{date}/compile-{system}-{job-id}</strong></p>

<div id="compile" class="tab-pane fade in active">
    <div class="container">
        <form method="POST" action="${contextPath}/compilejob" enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="form-group">
                <label for="system">*System:</label>
                <select class="form-control" id="system" name="system">
                <option value="Comet">Comet</option>
                <option value="Stampede">Stampede</option>
                <%-- <c:forEach var="sys" items="${systems.items}">
                  <option value=${sys} <c:if test="system == sys">selected</c:if>>{{val.display_name}}</option>
                </c:forEach> --%>
                </select>
                
                <c:if test="system_error">
                <div class="error">
                    <p>There was an error: ${ system_error }</p>
                </div>
                </c:if>
            </div>
            <div class="form-group">
                <label for="ccommand">*Command:</label>
                <input type="ccommand" class="form-control" id="ccommand" placeholder="Enter $command"
                       name="ccommand" required>
                <!-- Table to display command input options -->
                <table class="table-condensed">
                    <thead>
                    <tr>
                        <th>If using</th>
                        <th>Enter</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>serial, C:</td>
                        <td>icc</td>
                    </tr>
                    <tr>
                        <td>serial, C++:</td>
                        <td>icpc</td>
                    </tr>
                    <tr>
                        <td>MPI, C:</td>
                        <td>mpicc</td>
                    </tr>
                    <tr>
                        <td>MPI, C++:</td>
                        <td>mpicxx</td>
                    </tr>
                    <tr>
                        <td>Open MP, C:</td>
                        <td>icc -qopenmp</td>
                    </tr>
                    <tr>
                        <td>Open MP, C++:</td>
                        <td>icpc -qopenmp</td>
                    </tr>
                    <tr>
                        <td>CUDA:</td>
                        <td>nvcc</td>
                    </tr>
                    </tbody>

                </table>
                <!-- Error handling -->
                <c:if test="command_error">
               
                <div class="error">
                    <p>There was an error: ${ command_error }</p>
                </div>
                </c:if>
                
                <c:if test="compile_error">
                <div class="error">
                    <p>There was an error: ${ compile_error }</p>
                </div>
                </c:if>
            </div>
            <div class="form-group">
                <label for="driver">*Driver:</label>
	        	<input type="file" class="form-control" id="driver" name="driver" required />
                
                <c:if test="driver_error">
                <div class="error">
                    <p>There was an error: ${ driver_error }</p>
                </div>
                </c:if>
            </div>
            <div class="form-group">
                <label for="outfiles">*Output File(s):</label>
                <input type="outfiles" class="form-control" id="outfiles" placeholder="a.out" name="outfiles"
                       required>
                <c:if test="outfiles_error">
                <div class="error">
                    <p>There was an error: {{ outfiles_error }}</p>
                </div>
                
                </c:if>
            </div>
            <div class="form-group">
                <label for="addfiles">Additional Files:</label>
                <input type="addfiles" class="form-control" id="addfiles"
                       placeholder="Add additional files or folders separated by commas" name="addfiles">
            </div>
            <div class="form-group">
                <label for="modules">Modules:</label>
                <input type="modules" class="form-control" id="modules" placeholder="Add modules to load separated by commas" name="modules">
               
               <c:if test="modules_error">
               <div class="error">
                   <p>There was an error: ${ modules }</p>
               </div>
               
               </c:if>
            </div>
            <div class="form-group">
                <label for="commargs">Command Args:</label>
                <input type="commargs" class="form-control" id="commargs" placeholder="$args" name="commargs">
                <c:if test="commargs_error">
                <div class="error">
                    <p>There was an error: ${ commargs_error }</p>
                </div>
                </c:if>
            </div>
            <!-- <h4>This is your command:</h4>
            <p id="compileFullCommand"></p> -->

            <div class="text-right">
                <button type="submit" class="btn btn-default">Compile Code</button>
            </div>
        
    </form>
    </div>
</div>
</div>
</body>
</html>
