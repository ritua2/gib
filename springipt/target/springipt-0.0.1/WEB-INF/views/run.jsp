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

<h1>Launching a Run Job</h1>

<p>This form will guide you towards composing the command for running your serial or parallel programs on TACC/XSEDE resources. Please upload all the input or data files required by your executable/binary.</p>
<p> The output from your jobs can be found in <strong>/home/ipt/jobs/{date}/run-{system}-{job-id}</strong></p>

  <div id="run" class="tab-pane fade in active">
    <div class="container">
        <form method="POST" action="${contextPath}/runjob" enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="form-group">
                <label for="system">System:</label>
                <select class="form-control" id="system" name="system" onchange="updateQueues()">
	                <option value="comet">Comet</option>
	                <option value="stampede">Stampede</option>
	                <option value="ls5">Lonestar</option>
                </select>
                
                 <c:if test="system_error">
                <div class="error">
                    <p>There was an error: ${ system_error }</p>
                </div>
                </c:if>
            </div>
            <div class="form-group">
                <label for="rcommand">Command:</label>
                <input value="${rcommand}" type="text" class="form-control" id="rcommand"
                       placeholder="Enter ibrun or ./nameofexecutable" name="rcommand" required>
                <c:if test="run_command_error">
                <div class="error">
                    <p>There was an error: ${ run_command_error }</p>
                </div>
                </c:if>

                <label for="jobq">Job Queue:</label>
                <select class="form-control" id="jobq" name="jobq">
                </select>
           
                <c:if test="job_queue_error">
                <div class="error">
                    <p>There was an error: ${ job_queue_error }</p>
                </div>
                </c:if>

                <label for="numcores">Number of cores:</label>
                <select class="form-control" type="number" id="numcores" name="numcores">
                    <option value="disabled" disabled>Select One</option>
                    <option value="1" {% if numcores == "1" %}selected{% endif %}>1</option>
                    <option value="2" {% if numcores == "2" %}selected{% endif %}>2</option>
                    <option value="3" {% if numcores == "3" %}selected{% endif %}>3</option>
                    <option value="4" {% if numcores == "4" %}selected{% endif %}>4</option>
                    <option value="5" {% if numcores == "5" %}selected{% endif %}>5</option>
                    <option value="6" {% if numcores == "6" %}selected{% endif %}>6</option>
                    <option value="7" {% if numcores == "7" %}selected{% endif %}>7</option>
                    <option value="8" {% if numcores == "8" %}selected{% endif %}>8</option>
                    <option value="9" {% if numcores == "9" %}selected{% endif %}>9</option>
                    <option value="10" {% if numcores == "10" %}selected{% endif %}>10</option>
                    <option value="11" {% if numcores == "11" %}selected{% endif %}>11</option>
                    <option value="12" {% if numcores == "12" %}selected{% endif %}>12</option>
                    <option value="13" {% if numcores == "13" %}selected{% endif %}>13</option>
                    <option value="14" {% if numcores == "14" %}selected{% endif %}>14</option>
                    <option value="15" {% if numcores == "15" %}selected{% endif %}>15</option>
                    <option value="16" {% if numcores == "16" %}selected{% endif %}>16</option>
                </select>

                <c:if test="num_cores_error">
                <div class="error">
                    <p>There was an error: ${ num_cores_error }</p>
                </div>
                </c:if>

                <label for="numnodes">Number of Nodes:</label>
                <input value="${numnodes}" type="text" class="form-control" id="numnodes"
                       placeholder="Enter number of nodes. if OpenMP or CUDA: Enter 1, if MPI or Hybrid: You may enter 1+"
                       name="numnodes" required>
                <c:if test="num_nodes_error">
                <div class="error">
                    <p>There was an error: ${ num_nodes_error }</p>
                </div>
                </c:if>


                <label for="binary">Binary:</label>
                <input type="file" class="form-control" id="binary" name="binary" required>
                <c:if test="binary_error">
                <div class="error">
                    <p>There was an error: ${ binary_error }</p>
                </div>
                </c:if>
                <div class="form-group">
                    <label for="addfiles">Additional Files:</label>
                    <input value="${addfiles}" type="addfiles" class="form-control" id="addfiles"
                           placeholder="Add additional files or folders separated by commas" name="addfiles">
                </div>
                <div class="form-group">
                    <label for="modules">Modules:</label>
                    <input type="modules" class="form-control" id="modules"
                           placeholder="Add modules to load separated by commas" name="modules">
                   <c:if test="modules_error">
                   <div class="error">
                       <p>There was an error: ${ modules }</p>
                   </div>
                   </c:if>
                </div>
                <div class="form-group">
                    <label for="rcommandargs">Command Args:</label>
                    <input value="${rcommandargs}" type="text" class="form-control" id="rcommandargs" placeholder="args"
                           name="rcommandargs">
                    <c:if test="run_command_args_error">
                    <div class="error">
                        <p>There was an error: ${ run_command_args_error }</p>
                    </div>
                    </c:if>
                </div>
                <!-- <div>
                  <h4>This is your command:</h4>
                  <p id="fullCommand"></p>
                </div> -->
                <div class="text-right">
                    <button type="submit" class="btn btn-default">Launch Run Job</button>
                </div>
            </div>
        </form>
    </div>
</div>

  <script>
    function updateQueues(){
      var system = $('#system').val();
      var queues = $('#jobq')
      queues.empty()

      if (system == 'stampede') {
          queues.append('<option value="normal" {% if jobq == "normal" %}selected{% endif %}>normal</option>')
          queues.append('<option value="development" {% if jobq == "development" %}selected{% endif %}>development</option>')
          queues.append('<option value="flat-quadrant" {% if jobq == "flat-quadrant" %}selected{% endif %}>flat-quadrant</option>')
          queues.append('<option value="skx-dev" {% if jobq == "skx-dev" %}selected{% endif %}>skx-dev</option>')  
          queues.append('<option value="skx-normal" {% if jobq == "skx-normal" %}selected{% endif %}>skx-normal</option>')  
      
      } else if (system == 'ls5') {
          queues.append('<option value="normal" {% if jobq == "normal" %}selected{% endif %}>normal</option>')
          queues.append('<option value="development" {% if jobq == "development" %}selected{% endif %}>development</option>')
          queues.append('<option value="gpu" {% if jobq == "gpu" %}selected{% endif %}>gpu</option>')
          queues.append('<option value="vis" {% if jobq == "vis" %}selected{% endif %}>vis</option>')
          
      } else if (system == 'comet') {
          queues.append('<option value="gpu-shared" {% if jobq == "gpu-shared" %}selected{% endif %}>gpu-shared</option>')
          queues.append('<option value="gpu" {% if jobq == "gpu" %}selected{% endif %}>gpu</option>')
          queues.append('<option value="debug" {% if jobq == "debug" %}selected{% endif %}>debug</option>')
          queues.append('<option value="compute" {% if jobq == "compute" %}selected{% endif %}>compute</option>')
      }
    }
    updateQueues();
  </script>