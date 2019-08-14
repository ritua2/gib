<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<jsp:include page="base.jsp" />
<div class="container">
    <h1>Launching a Compile Job</h1>
    <p>This form will guide you towards composing the command for compiling your serial or parallel programs on TACC/XSEDE resources. Please upload all the files that are external to your program but are required for compiling it successfully, such as, header files and other C/C++ program files.</p>

    <div id="compile" class="tab-pane fade in active">
        <div class="container">
            <form method="POST" action="${contextPath}/compilejob" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="form-group">
                    <label for="system">*System:</label>
                    <select class="form-control" id="system" name="system">
                    <option value="Comet">Comet</option>
                    <option value="Stampede2">Stampede2</option>
                    <option value="Lonestar5">LoneStar5</option>
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
				 <!-- Dropdown to display command input options -->
                    <label for="compiler">Select Compiler:</label>
					<select class="form-control" id="compiler" name="compiler" >
                    <option value="icc ">Serial, C:	icc</option>
                    <option value="icpc ">Serial, C++:	icpc</option>
                    <option value="mpicc ">MPI, C:	mpicc</option>
					<option value="mpicxx ">MPI, C:	mpicxx</option>
					<option value="icc -qopenmp ">Open MP, C:	icc -qopenmp</option>
					<option value="icpc -qopenmp ">Open MP, C++:	icpc -qopenmp</option>
					<option value="nvcc ">CUDA:	nvcc</option>
					<option value="gcc -fopenmp ">Open MP, GNU C:	gcc -fopenmp</option>
					<option value="g++ -fopenmp ">Open MP, GNU C++:	g++ -fopenmp</option>
					<option value="gcc ">GNU C:	gcc</option>
					<option value="g++ ">GNU C++:	g++</option>
                    </select>
                    
                   
                    
                    <!-- Error handling -->
                    <c:if test="compiler_error">
                   
                    <div class="error">  
                        <p>There was an error: ${ compiler_error }</p>
                    </div>
                    </c:if> 
                </div> 
				<div class="form-group">
                    <label for="ccommand">Command:</label>
                    <input type="ccommand" class="form-control" id="ccommand" placeholder="Enter $command"
                           name="ccommand" >
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
                
                <!-- <h4>This is your command:</h4>
                <p id="compileFullCommand"></p> -->

                <div class="text-right">
                    <button type="submit" class="btn btn-default">Compile Code</button>
                </div>
            
        </form>
        </div>
    </div>
    
<br/>
<br/>
</div>
<jsp:include page="footer.jsp" />