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
    <style>
    .dashboard {
        width: 100%;
        height: ${dash.viewHeight}px;
    }
    .content .nav-tabs li.active {
        background-color: #ff0000;
    }
    </style>
</head>
<jsp:include page="/WEB-INF/views/includes/header.jsp"></jsp:include>

<div class="static-content">
	<div class="page-content">
		<!-- Content Header (Page header) -->
		<jsp:include page="/WEB-INF/views/includes/title.jsp"></jsp:include>

		<!--------------------------
		| Your Page Content Here |
		-------------------------->
        <div class="container-fluid">
            <section class='lg-wrap'>
                <div class="card">
                    <form>
                        <div class="search-box card-body form-horizontal row-border">
                            <div class="py-1 form-inline">
                                <label><spring:message code="visitor.view.analytics.search.field.data_interval"/></label>
                                <select class="disable_ui form-select" id="id_data_interval" name="data_interval" >
                                    <option selected value="hourly">시간단위</option>
                                    <option value="daily">일단위</option>
                                </select>      
                                <button id="btn_search" type="button" class="btn btn-primary mx-2">불러오기</button>
                            </div>
                        </div>
                    </form>
                </div>
            </section>
        </div>
        <div class="container-fluid">
            <section class='lg-wrap'>
                <div class="card mt-3">
                    <object type="text/html" class="dashboard" data="${dash.getLinkUrl()}"></object>
				</div>
			</section>
		</div>
	</div> <!-- #page-content -->
</div> <!-- static-content -->


<jsp:include page="/WEB-INF/views/includes/footer.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/includes/footer_script.jsp"></jsp:include>
<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. -->
<jsp:include page="/WEB-INF/views/includes/captive_common_search_script.jsp"></jsp:include>
<script>
$(document).ready(function () {
    if ('${data_interval}')
        $('#id_data_interval').val('${data_interval}');

    $('#btn_search').click(function() {
        const allowed = ['hourly', 'daily'];
        const interval = $('#id_data_interval').val();
        if (allowed.includes(interval)) {
            const url = '/visitor/analytics?data_interval=' + interval;
            location.href = url;
        } else {
            // Optionally, show an error or fallback to a default safe value
            alert('Invalid data interval selected.');
        }
    });
});
</script>

</body>
</html>