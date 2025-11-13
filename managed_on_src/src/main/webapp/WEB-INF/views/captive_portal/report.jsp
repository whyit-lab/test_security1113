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
    .report-content {
        width: 100%;
        height: 1300px;
    }
    .content .nav-tabs li.active {
        background-color: #ff0000;
    }
    </style>
</head>
<jsp:include page="/WEB-INF/views/includes/header_captive.jsp"></jsp:include>

<div class="static-content">
	<div class="page-content">
		<!-- Content Header (Page header) -->
		<jsp:include page="/WEB-INF/views/includes/title_captive.jsp"></jsp:include>

		<!--------------------------
		| Your Page Content Here |
		-------------------------->
        <%-- <div class="container-fluid">
            <section class='lg-wrap'>
                <jsp:include page="/WEB-INF/views/includes/dashboard.jsp"></jsp:include>
			</section>
		</div> --%>

		<div class="container-fluid">
			<section class='lg-wrap'>
                <form>
                    <div class="card">
                        <div class="card-body form-horizontal row-border">
                            <c:if test="${ authData.isCaptiveAdmin() }">
                                <div class="d-sm-flex">
                                    <div class="col-sm-1 detail-col-label py-sm-3 py-2 border-top">구단
                                    </div>
                                    <div class="col-sm-11 py-2 border-top form-inline">
                                        <select id="id_companyId" name="companyId" class="form-select">
                                        </select>
                                    </div>
                                </div>
                            </c:if>
                            <div class="d-sm-flex">
                                <div class="col-sm-1 detail-col-label py-sm-3 py-2 border-top">성별
                                </div>
                                <div class="col-sm-11 py-2 border-top form-inline">
                                    <span id="id_CustomerGender">
                                    </span> 
                                </div>
                            </div>
                            <div class="d-sm-flex">
                                <div class="col-sm-1 detail-col-label py-sm-3 py-2 border-top">연령대
                                </div>
                                <div class="col-sm-11 py-2 border-top form-inline">
                                    <span id="id_CustomerAge">
                                    </span> 
                                </div>
                            </div>
                            <div class="d-sm-flex border-bottom">
                                <div class="col-sm-1 detail-col-label py-sm-3 py-2 border-top">
                                    <spring:message code="meraki.common.view.report.fields.startDate"/>
                                </div>
                                <div class="col-sm-3 py-2 border-top">
                                    <div class="input-group date">
                                        <div class="col-sm-1 py-1 pr-4">
                                            <i class="fa fa-calendar"></i>
                                        </div>
                                        <input type="text" id="id_fromDt" name="fromDt" class="form-control" readonly>
                                    </div>
                                </div>
                                <div class="col-sm-1 detail-col-label py-sm-3 py-2 border-top">
                                    <spring:message code="meraki.common.view.report.fields.endDate"/>
                                </div>
                                <div class="col-sm-3 py-2 border-top">
                                    <div class="input-group date">
                                        <div class="col-sm-1 py-1 pr-4">
                                            <i class="fa fa-calendar"></i>
                                        </div>
                                        <input type="text" id="id_toDt" name="toDt" class="form-control" readonly>
                                    </div>
                                </div>
                                <div class="col-sm-4 py-2 border-top">
                                    <button type="button" id="btn_search" class="btn btn-primary"><spring:message code="common.view.button.search"/></button>
                                    <%-- <c:if test="${authData.hasWrightAuth(requestScope['javax.servlet.forward.request_uri'])}">
                                        <button type="button" id="btn_print" class="btn btn-primary"><spring:message code="common.view.button.print"/></button>
                                    </c:if> --%>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
			</section>
		</div>

		<div class="container-fluid">
			<section class='lg-wrap'>
                <div class='card mt-3'>
                    <div class='card-body'>
                        <div class="row main-section" id = "main_section">
                            <iframe type="text/html" class="report-content">
                            </iframe>
                        </div>
                    </div>
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
<script>
$('#id_fromDt').datepicker(DATEPICKER_DEFAULT_SETTING);
$('#id_toDt').datepicker(DATEPICKER_DEFAULT_SETTING);

function isFormValid() {
    $('.static-content form').validate(
        {
            rules : {
                fromDt : {
                    date : true,
                    pattern : REGEX_DATE_FORMAT
                },
                toDt : {
                    date : true,
                    pattern : REGEX_DATE_FORMAT
                }
            },
            messages : {
                fromDt : {
                    required : '<spring:message code="meraki.common.view.report.validation.startDate"/>',
                    date : '<spring:message code="meraki.common.view.report.validation.startDt.date"/>',
                    pattern : '<spring:message code="meraki.common.view.report.validation.startDt.dateFormat"/>',
                },
                toDt : {
                    required : '<spring:message code="meraki.common.view.report.validation.toDate"/>',
                    date : '<spring:message code="meraki.common.view.report.validation.endDt.date"/>',
                    pattern : '<spring:message code="meraki.common.view.report.validation.endDt.dateFormat"/>'
                },
            }
        });
    if (!$('.static-content form').valid()) {
        return false;
    }

    if (! isValidFromToDate($('#id_fromDt').val(), $('#id_toDt').val())) {
        alert('<spring:message code="common.validation.invalid_from_to_date"/>');
        return false;
    }

    return true;
}

$(document).ready(function() {
    <c:if test="${ authData.isCaptiveAdmin() }">
        fillCompanySelect($('#id_companyId'));
    </c:if>
    createChecks(
        $('#id_CustomerGender'),
        'checkbox',
        'searchGenderCode',
        '/code/api/list_code_simple?codeGroup=CUSTOMER_GENDER',
        null,
        null,
        function() {
            $('input[name="searchGenderCode"]').map(function(i, e) {
                e.checked = true;
            });
        },
        { label: '전체', value: 'All', checked: true }
    );
    createChecks(
        $('#id_CustomerAge'),
        'checkbox',
        'searchAgeCode',
        '/code/api/list_code_simple?codeGroup=CUSTOMER_AGE',
        null,
        null,
        function() {
            $('input[name="searchAgeCode"]').map(function(i, e) {
                e.checked = true;
            });
        },
        { label: '전체', value: 'All', checked: true }
    );
    
    $('#btn_print').click(function () {
        window.print();
    });
    $('#btn_search').click(function () {
        if (! isFormValid()) {
            return false;
        }

        // if (! $('#id_companyId').val()) {
        //     alert('구단을 선택하세요.');
        //     return false;
        // }
        // $('.report-content')[0].style.display = "none";      // fix windows chrome timing? issue

        let searchGenderCodes = $('input[name="searchGenderCode"]:checked').map(function(id, el) {
            return "'"+$(el).val()+"'";
        }).get().join(',');
        let searchAgeCodes = $('input[name="searchAgeCode"]:checked').map(function(id, el) {
            return "'"+$(el).val()+"'";
        }).get().join(',');
        let contentUrl = '/report/content'
            + '?fromDt=' + encodeURIComponent($('#id_fromDt').val())
            + '&toDt=' + encodeURIComponent($('#id_toDt').val())
            + '&searchGenderCodes=' + encodeURIComponent(searchGenderCodes)
            + '&searchAgeCodes=' + encodeURIComponent(searchAgeCodes)
            + '&companyId=' + encodeURIComponent($('#id_companyId').val())
        
        $('.static-content-wrapper').LoadingOverlay('show', LOADING_OVERLAY_OPTION);
        $('.report-content').attr('src', contentUrl);
    })
    $('.report-content').on('load', function() {
        $('.static-content-wrapper').LoadingOverlay('hide', LOADING_OVERLAY_OPTION);
        $('.report-content')[0].style.display = "";
        setTimeout(function() {
            $('.report-content')[0].style.height = "1400px";
            $('.report-content')[0].style.width = "980px";
        }, 500);
    })

    $('#id_fromDt').val(getFormDate(-1));
    $('#id_toDt').val(getFormDate());
});
</script>

</body>
</html>