<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication var="authData" property="principal"/>
<!DOCTYPE html>

<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<head>
	<jsp:include page="/WEB-INF/views/includes/common_head.jsp"></jsp:include>
	<!-- Optionally, you can add additional <script> or <link> tags here -->
</head>
<jsp:include page="/WEB-INF/views/includes/header.jsp"></jsp:include>

<div class="static-content">
	<div class="page-content">
	    <ol class="breadcrumb">
			<li><a href="/home">Home</a></li>
			<li class="active"><a href=""><spring:message code="main.view.page_title"/></a></li>
		</ol>
		<div class="page-heading">
            <h1>
                <spring:message code="main.view.page_title"/>
                <%-- <small><spring:message code="main.view.page_sub_title"/></small> --%>
            </h1>
		</div>
		<div class="container-fluid">                          
			<!-- <div data-widget-group="group1"> -->
			<div>
				<div id="main_alert_notification" style="margin-left: 0px;margin-top: 10px;margin-right: 0px; margin-bottom: 10px;border: 1px solid #ddd;border-radius: 4px;background-color:#FFFFFF">
					<center><font size="3" color="#000000" style="font-weight:bold;">SIP Session Monitoring</font></center>
					<iframe src="http://<spring:eval expression="@conf.getProperty('grafana.ip')" />:<spring:eval expression="@conf.getProperty('grafana.port')" />/d/Lxci-FBZk/sip_session?orgId=1&refresh=10s&from=now-1h&to=now&kiosk=1&theme=light" 
						width="100%" height="300px" frameborder="0"  visibility="hidden" onload="this.style.visibility='visible';"></iframe>								
				</div>
				<div style="margin-left: 0px;margin-top: 10px;margin-right: 0px; margin-bottom: 10px;border: 1px solid #ddd;border-radius: 4px;background-color:#FFFFFF">
					<center><font size="3" color="#000000" style="font-weight:bold;">Server & Application Status</font></center>
				    <iframe src="http://<spring:eval expression="@conf.getProperty('grafana.ip')" />:<spring:eval expression="@conf.getProperty('grafana.port')" />/d/rh1DbNxZz/sip_ems_srvstat?orgId=1&refresh=1m&from=now-1h&to=now&theme=light&kiosk=1" 
						width="100%" height="300px" frameborder="0" visibility="hidden" onload="this.style.visibility='visible';"></iframe>
				</div>
			</div>
		</div> <!-- .container-fluid -->
	</div> <!-- #page-content -->
</div>


<jsp:include page="/WEB-INF/views/includes/footer.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/includes/footer_script.jsp"></jsp:include>
<!-- Optionally, you can add Slimscroll and FastClick plugins.
	 Both of these plugins are recommended to enhance the
	 user experience. -->

</body>
</html>