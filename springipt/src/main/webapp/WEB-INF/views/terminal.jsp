<!-- {% extends 'base.html' %}

{% block headersum %} -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<jsp:include page="base.jsp" />
<div class="container">
    <h1>Terminal</h1>
    <!-- This particular block template is only for a tab header.
    This block can be modified or removed completely, just be sure to remove the
    opening and closing "headersum" blocks.  -->
    <!-- {% endblock %}

    {% block body %} -->
    <table cellpadding="0" cellspacing="0" width="100%" height="350px">
    <tr>
      <td width="75%">
      <div class="terminal">
        <!-- {% if url %} -->
        <%-- <c:if test="url"> --%>    
        <%-- right here --%>
        <%-- the ip address is different for each user --%>
        <c:set var="username" value="${pageContext.request.userPrincipal.name}" />
        <c:set var="path" value="${contextPath}" />
        <%
          String username = (String)pageContext.getAttribute("username");
          String path =getServletContext().getRealPath("/");
          String result = "";
          System.out.println(getServletContext().getRealPath("/"));
          try {
            Runtime r = Runtime.getRuntime();                    
            String command = path.concat("resources/UserTerminal.sh ").concat(username);
            Process p = r.exec(command);
            BufferedReader in =
                new BufferedReader(new InputStreamReader(p.getInputStream()));
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                System.out.println(inputLine);
                result += inputLine;
            }
            in.close();

          } catch (IOException e) {
               System.out.println(e);
          }
          System.out.println("result is " + result);
          pageContext.setAttribute("UserRedirect", result);
        %>
          <iframe id="webterm" src=<%= pageContext.getAttribute("UserRedirect") %> style="overflow:hidden; width:850px; height:500px; background: white; float:center; " allowtransparency="true"> Terminal Session Frame</iframe>
        <!-- {% else %} -->
    <%--     </c:if>
        <c:if test="url"> --%>
          <!-- <iframe id="webterm" src=""  style="overflow:hidden; width:850px; height:500px; background: white; float:center; " allowtransparency="true"> Terminal Session Frame</iframe> -->
        <!-- {% endif %} -->
    <%--     </c:if> --%>
      </div>
      </td>
      <td valign="top">
      <a data-toggle="tooltip"  style="border-bottom:1px dotted #000;text-decoration: none;" title="Upload Additional Files and they will show up in /home/ipt within your IPT terminal."><h3>File Upload</h3></a>
      <form id="uploadForm" action="${contextPath}/terminal/upload" method="POST" enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <div id="myRadioGroup">
        File upload <input type="radio" name="filefolder" checked="checked" value="file" />
        Folder upload <input type="radio" name="filefolder" value="folder" />
        <div id="file" class="desc">
    	    <div class="form-group">
    	        <input type="file" class="form-control" id="file"
    	                       placeholder="Add additional files or folders" name="fileToUpload" >
    	    </div>
        </div>
        <div id="folder" class="desc">
    	    <div class="form-group">
    	        <input type="file" class="form-control" id="folder"
    	                       placeholder="Add additional files or folders" name="folderToUpload" webkitdirectory mozdirectory directory multiple>
    	        <input type="hidden" id="uploadId" name="hiddenInput">
    	    </div>
        </div>
    	</div>
        <div class="text-right">
          <button type="submit" class="btn btn-default">Upload</button>
        </div>
      </form>
      <br/><br/>
      
        <a data-toggle="tooltip"  style="border-bottom:1px dotted #000;text-decoration: none;" title="Select file or folder to download. Folder path ends with a slash '/' "><h3>Download File/Folder </h3></a>
      <form id="downloadForm" method="GET" action="${contextPath}/terminal/download" enctype="multipart/form-data">
          <div class="form-group">
    	  <select id=fileToDownload>
      	    <option value="">--Select--</option>
    	  </select>
              <input type="hidden" name="action" value="download">
          </div>
          <table>
    	<td width="80%">
          <div class="text-left">
              <button id=refreshList type="button" class="btn btn-default">Refresh List</button>
          </div>
    	</td>
    	<td align="right">
          <div class="text-right">
              <button type="submit" class="btn btn-default">Download</button>
          </div>
    	</td>
          </table>
      </form>

      </td>
    </tr>
    </table>
  </div>
    <!-- {% endblock %}
  
{% block scripts %} -->
<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
  <script>
      $(document).ready(function(){
          src = document.getElementById('webterm').src;
          if (src === window.location.href){
              getTerminalUrl(0) //start count at 0
          }
          $("#folder").hide();
          $("input[name$='filefolder']").click(function() {
          var test = $(this).val();

           $("div.desc").hide();
          $("#" + test).show();
    	  });
          $.ajax({
              url: '${contextPath}/terminal/getdropdownvalues',
              type: 'GET',
  	    dataType: "json",
              success: function(data){
  	    drpDwnValue=data;
  	    $.each( drpDwnValue, function( key, f ) {
                $("#fileToDownload").append($('<option>', {
      		value: f +'/',
      		text: f
  		}));
  	    });	

             },
              error: function(){
                  console.log("error in ajax call");
              }
          });
      });
      

      async function sleep(ms = 0) {
        return new Promise(r => setTimeout(r, ms));
      }
      
      var printFiles = function (event) {
          var files = event.target.files;
          jsonObj = [];
          
          for (var indx in files) {
              var curFile = files[indx];
              var fileName = curFile.name
              var path = curFile.webkitRelativePath
              item = {};
              if((fileName != null) && (path != null)){
            	  item [fileName] = '/'+path;
            	  jsonObj.push(item);
              }
              
          }
          
          jsonString = JSON.stringify(jsonObj);
		  $("#uploadId").val(jsonString);
          console.log($("#uploadId").val());
      };
      
      $('#folder').change(printFiles);

      var getTerminalUrl = function(count) {
        $.get("webterm",
        function(data) {
            count += 1;
            console.log(count, data)
            if (data.url !== ""){
                sleep(75)
                webterm.src = data.url;
                return;
            } else if (count < 20){
              getTerminalUrl(count)
            }
        });
      }

      $('#downloadForm').on('submit', function(event){
          event.preventDefault();
          $('#errorMsg').text('');
          $.ajax({
            url: window.location.origin + '${contextPath}/terminal/download/' + $('#fileToDownload').val(),
            type: 'GET'
          }).fail(function(xhr) {
            $('#errorMsg').text($('#fileToDownload').val() + ' -- ' +xhr.responseText);
          }).done(function(xhr) {
            window.location = window.location.origin + '${contextPath}/terminal/download/' + $('#fileToDownload').val()
          });
      });
      $('#refreshList').click(function () {
          $.ajax({
              url: '${contextPath}/terminal/getdropdownvalues',
              type: 'GET',
  	    dataType: "json",
              success: function(data){
  	    drpDwnValue=data;
  	    $('#fileToDownload').html('');
  	    $('#fileToDownload').append('<option value="">--Select--</option>');
  	    $.each( drpDwnValue, function( key, f ) {
                $("#fileToDownload").append($('<option>', {
      		value: f + '/',
      		text: f
  		}));
  	    });	

             },
              error: function(){
                  console.log("error in ajax call");
              }
          });

        });

      $('#uploadForm').on('submit', function(event){
          event.preventDefault();
          $('#errorMsg').text('');
          var form = $('#uploadForm')[0]
          var formData = new FormData(form);

          $.ajax({
            url: window.location.origin + '${contextPath}/terminal/upload',
            data: formData,
            type: 'POST',
            dataType: "json",
            processData: false,
            contentType: false,
            success: function(xhr) {
              $('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>'
                   + xhr.msg +'</div>').insertBefore('.terminal')
            }
          }).fail(function(xhr) {
            $('<div class="alert alert-danger alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>'
            + xhr.responseJSON.msg +'</div>').insertBefore('.terminal')
          });
      });
  </script>
<!-- {% endblock %} -->

<jsp:include page="footer.jsp" />