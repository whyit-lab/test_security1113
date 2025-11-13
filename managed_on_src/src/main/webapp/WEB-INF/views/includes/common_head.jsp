<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, minimal-ui">
	<title><spring:message code="title.main"/></title>
	<!-- Bootstrap -->
	<link href="/static/assets/splash_editor/page/assets/dist/css/bootstrap.min.css" rel="stylesheet">
	<link type="text/css" rel="stylesheet" href="/static/assets/css/jquery-ui.css">
	<link type="text/css" rel="stylesheet" href="/static/assets/fonts/font-awesome/css/font-awesome.min.css">
	<link type="text/css" rel="stylesheet" href="/static/assets/fonts/themify-icons/themify-icons.css">
	<link type="text/css" rel="stylesheet" href="/static/assets/dataTables/dataTables.bootstrap4.css?ver=200402">
	<link type="text/css" rel="stylesheet" href="/static/assets/dataTables/buttons.dataTables.css?ver=200402">
	<link type="text/css" rel="stylesheet" href="/static/assets/css/style.css?ver=200402">

	<!-- Date Picker -->
	<link type="text/css" href="/static/assets/plugins/bootstrap-datepicker/css/bootstrap-datepicker.min.css" rel="stylesheet">
	<link type="text/css" rel="stylesheet" href="/static/assets/css/whyit.css">

	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
	<!-- FAVICON -->
	<link href="/static/assets/img/favicon.png" rel="shortcut icon">

	<!--js plugins-->
	<script type="text/javascript" src="/static/assets/js/jquery.min.js"></script>
	<script type="text/javascript" src="/static/assets/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/static/assets/js/moment.min.js"></script>
	<script type="text/javascript" src="/static/assets/js/popper.min.js"></script>
	<script src="/static/assets/splash_editor/page/assets/dist/js/bootstrap.bundle.min.js"></script>
	<script type="text/javascript" src="/static/assets/bootstrap/js/bootstrap-filestyle.min.js?ver=200402"></script>
	<script type="text/javascript" src="/static/assets/js/enquire.min.js?ver=200402"></script>
	<script type="text/javascript" src="/static/assets/js/jquery.datetimepicker.min.js"></script>
	<!-- dataTables -->
	<script type="text/javascript" src="/static/assets/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" src="/static/assets/dataTables/dataTables.bootstrap4.min.js"></script>
	<script type="text/javascript" src="/static/assets/dataTables/dataTables.buttons.min.js"></script>
	<script type="text/javascript" src="/static/assets/dataTables/buttons.colVis.min.js"></script>

	<script type="text/javascript" src="/static/assets/js/custom.js?ver=200402"></script>

	<!-- Date Picker -->
	<script type="text/javascript" src="/static/assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.min.js"></script>

	<!-- jQuery Validation -->
	<script type="text/javascript" src="/static/assets/plugins/jquery-validation/dist/jquery.validate.min.js"></script> 
	<script type="text/javascript" src="/static/assets/plugins/jquery-validation/dist/additional-methods.min.js"></script> 

	<!-- LoadingOverlay -->
	<script src="/static/assets/plugins/loadingoverlay/loadingoverlay.min.js"></script>

	<%-- toggle switch --%>
    <%-- <link href="/static/assets/css/bootstrap4-toggle.min.css" rel="stylesheet">
    <script src="/static/assets/js/bootstrap4-toggle.min.js"></script> --%>

	<script>
	$.ajaxSetup({
		headers: {'${_csrf.headerName}': '${_csrf.token}'}
	})
	</script>
	<jsp:include page="/WEB-INF/views/includes/messages.jsp"></jsp:include>