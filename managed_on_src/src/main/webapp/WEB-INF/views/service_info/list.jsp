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
        height: 480px;
    }
    .content .nav-tabs li.active {
        background-color: #ff0000;
    }
    </style>
    <style>
    .custom-combobox {
        position: relative;
        display: inline-block;
    }
    .custom-combobox-toggle {
        position: absolute;
        top: 0;
        bottom: 0;
        margin-left: -1px;
        padding: 0;
    }
    .custom-combobox-input {
        margin: 0;
        padding: 5px 10px;
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
					<div class="card-body form-horizontal row-border">
						<div class="d-sm-flex">
                            <div class="col-sm-2 detail-col-label py-sm-3 py-2 border-top border-bottom">
                                <spring:message code="service_info.view.list.search.company"/>
                            </div>
                            <div class="col-sm-10 py-2 border-top border-bottom form-inline">
                                <select id="id_companyId" name="companyId" class="form-select">
                                </select>
                                <button id="btn_search" class="btn btn-primary ml-4">
                                    <spring:message code="common.view.button.search"/>
                                </button>
                            </div>
						</div>
					</div>
				</div>
			</section>
		</div>

        <div class="container-fluid">
            <section class='lg-wrap'>
                <div class='card mt-3'>
                    <div class='card-body'>
                        <div class='p-3 bg-light'>
                            <div class='position-relative'>
                                <div class='table-responsive'>
                                    <table id="service_list" width="100%" class="table table-bordered dataTable">
                                        <thead>
                                            <tr>
                                                <th><spring:message code="user_home.view.service.fields.serviceStatus"/></th>
                                                <th><spring:message code="user_home.view.service.fields.companyName"/></th>
                                                <th><spring:message code="user_home.view.service.fields.networkName"/></th>
                                                <th><spring:message code="user_home.view.service.fields.serviceType"/></th>
                                                <th><spring:message code="user_home.view.service.fields.ktServiceNo"/></th>
                                                <th><spring:message code="user_home.view.service.fields.deviceType"/></th>
                                                <th><spring:message code="user_home.view.service.fields.model"/></th>
                                                <th><spring:message code="user_home.view.service.fields.assetId"/></th>
                                                <th><spring:message code="user_home.view.service.fields.ip"/></th>
                                                <th><spring:message code="user_home.view.service.fields.ktServiceStartDt"/></th>
                                                <th><spring:message code="user_home.view.service.fields.licenseStartDt"/></th>
                                                <th><spring:message code="user_home.view.service.fields.licenseEndDt"/></th>
                                            </tr>
                                        </thead>
                                    </table>

                                </div>
                            </div>
							<div class="d-flex">
                                <button id="btn_csv" class="btn btn-primary btn-right"><spring:message code="common.view.button.csv"/></button>
                            </div>
						</div>
					</div>
				</div>
			</section>
		</div> <!-- .container-fluid -->
	</div> <!-- #page-content -->
</div>


<jsp:include page="/WEB-INF/views/includes/footer.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/includes/footer_script.jsp"></jsp:include>
<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. -->
<script src="/static/dist/js/base/search_combo.js"></script>
<script>
$(document).ready(function() {
    function cellCallbackNoZero(nTd, sData, data, iRow, iCol) {
        if (sData == 0)
            $(nTd).text('-')
        else
            $(nTd).text(sData)
    }

    function makeAjaxUrl() {
        return '/service_info/api/service_list?companyId='+ encodeURIComponent($('#id_companyId').val())
    }

    function loadTable() {
        $('#id_companyId').combobox();

        dataTable = $('#service_list').DataTable(DATATABLE_SETTING.getLocal({
            ajaxUrl: makeAjaxUrl(),
            order: [[0, 'desc']],
            columnDef: [
                DATATABLE_SETTING.COLUMN.ARCUS_ASSET_STATUS('serviceStatus'),
                { 'data': 'companyName', 'className': 'dt-center' },
                { 'data': 'networkName', 'className': 'dt-center' },
                { 'data': 'serviceType', 'className': 'dt-center' },
                { 'data': 'ktServiceNo', 'className': 'dt-center' },
                { 'data': 'deviceType', 'className': 'dt-center' },
                DATATABLE_SETTING.COLUMN.ARCUS_ASSET_LINK('model', 'assetId', 'model'),
                { 'data': 'assetId', 'className': 'dt-center' },
                { 'data': 'ip', 'className': 'dt-center' },
                { 'data': 'ktServiceStartDt', 'className': 'dt-center' },
                { 'data': 'licenseStartDt', 'className': 'dt-center' },
                { 'data': 'licenseEndDt', 'className': 'dt-center' },
            ]
        }))
    }

    $('#btn_search').click(function() {
        dataTable.ajax.url(makeAjaxUrl()).load()
    });

    $('#btn_csv').click(function() {
        openMenu('/service_info/download_csv?companyId='+ encodeURIComponent($('#id_companyId').val()), true)
    })

    let search_companyId = '${search_companyId}'
    let dataTable

    fillCustomerCompanySelect(
        $('#id_companyId'), 
        '${search_companyId}', 
        loadTable
    )

});

</script>

</body>
</html>