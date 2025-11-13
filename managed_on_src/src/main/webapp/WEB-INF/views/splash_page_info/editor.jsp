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
    <meta charset="utf-8">
    <meta name="author" content="roy whyit.co.kr">
    <meta name="generator" content="Hugo 0.83.1">
    <!-- https://stackoverflow.com/questions/44501266/how-to-set-width-to-mobile-screen-size-using-html-css -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="/static/assets/splash_editor/css/splash_common.css" rel="stylesheet">
    <link href="/static/assets/splash_editor/page/editor/editor.css" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="/static/assets/splash_editor/free/common/css/layout.css"/>
  
    <style>
    .title-label {
      /* text-align:center; */
      background-color: #f9f9f9;
      /* white-space:nowrap; */
      font-size: 1.2em;
      font-weight:500;
      color:#000;
    }
    .title-content {
      font-size: 1.11m;
      mragin-left: 2px;
    }
    .card {
      max-width: 1200px;
    }
    .card-fotter {
      max-width: 1200px;
    }
    .flex-container {
      display: flex;
    }
    .flex-center {
      display: flex;
      justify-content: right;
      align-items: center;
      width: 100%;
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
					<div class="card-body">
            <div class="row">
              <div class="col-7">
                <div>
                  <span class="title-label">고객사 : </span><span class="title-content" id="editor_company"></span>
                  <span class="title-label">지점 : </span><span class="title-content" id="editor_network"></span>
                  <span class="title-label">SSID : </span><span class="title-content" id="editor_ssid"></span><input type="hidden" id="editor_ssidId">
                </div>
                <div class="flex">
                  <span class="title-label">페이지명 : </span><span class="title-content" id="editor_page_name"></span>
                </div>
              </div>
              <div class="col flex-container">
                <div class="flex-center">
                  <button class="btn btn-secondary btn-right" onclick="g_G.goto_splash_preivew()">페이지 미리보기</button>
                  <button class="btn btn-primary btn-right" id="btn_save_as">다른 이름으로 저장</button>
                  <button class="btn btn-danger btn-right" id="btn_activate_spi">이 설정 사용</button>
                </div>
              </div>
            </div>
					</div>
				</div>
				<div class="card">
					<div class="card-body">
            <div class="row">
              <div class="col-md-4 splash_preview">
                <section id="wrap" class="bg_typeB bg-color-target" style="overflow-y: auto;">
                    <!-- .free_wifi -->
                    <div class="free-wifi">
                        <p class="fw-tit typeA" id="preview_title" ></p>
                        <p class="fw-desc1234" id="preview_titleBig_contents" ><span></span></p>
                        <p class="fw-desc1234" id="preview_title_contents"><span></span></p>
                    </div>
                    <!-- /.free_wifi -->

                    <ul class="list-group theme_center" id="preview_list">
                    </ul>
                </section>
              </div>
              <div class="col-md-8" style="padding-right: 0">
                <div class="tab">
                  <button class="tablinks" onclick="g_G.openTag(event, 'page_config')" id="page_config_editor_tab">페이지 목록</button>
                  <button class="tablinks" onclick="g_G.openTag(event, 'theme_config')" id="theme_config_editor_tab">테마</button>
                  <button class="tablinks" onclick="g_G.openTag(event, 'logo_config')" id="logo_config_editor_tab">로고</button>
                  <button class="tablinks" onclick="g_G.openTag(event, 'title_config')" id="title_config_editor_tab">타이틀</button>
                  <button class="tablinks" onclick="g_G.openTag(event, 'agree_config')" id="agree_config_editor_tab">동의항목</button>
                  <button class="tablinks" onclick="g_G.openTag(event, 'survey_config')" id="survey_config_editor_tab">설문</button>
                  <button class="tablinks" onclick="g_G.openTag(event, 'login_config')" id="login_config_editor_tab">로그인</button>
                  <button class="tablinks" onclick="g_G.openTag(event, 'banner_config')" id="banner_config_editor_tab">광고</button>
                  <button class="tablinks" onclick="g_G.openTag(event, 'etc_config')" id="etc_config_editor_tab">기타설정</button>
                </div>

                <div id="page_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/page_config.html"></div>
                <div id="theme_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/theme_config.html"></div>
                <div id="logo_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/logo_config.html"></div>
                <div id="title_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/title_config.html"></div>
                <div id="agree_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/agree_config.html"></div>
                <div id="survey_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/survey_config.html"></div>
                <div id="login_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/login_config.html"></div>
                <div id="banner_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/image_config.html"></div>
                <div id="etc_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/etc_config.html"></div>
                <div id="etc_config" class="tabcontent" include-html="/static/assets/splash_editor/page/editor/include/survey_config.html"></div>
              </div>
            </div>
          </div>
          <div class="card-footer">
            <div>
              <%-- <button class="btn btn-secondary" onclick="g_G.goto_splash_list()">스플레시 관리로 이동</button> --%>
              <button class="btn btn-secondary" id="btn_goto_status">스플레시 관리로 이동</button>
              <button class="btn btn-danger btn-right" onclick="g_G.delete_and_goto_splash_list(g_G.splash_page_info.spi_id)">삭제</button>
              <%-- <button class="btn btn-primary btn-right" onclick="g_G.call_eDB_KT_CAPTIVE_SPLASH_UPDATE()">설정 저장</button> --%>
            </div>
          </div>
        </div>
			</section>

    </div> <!-- .container-fluid -->
  </div> <!-- #page-content -->
</div>

  <script>var ARCUS_EDITOR = {}; const ARCUS_SPLASH_BASE_URL = '${splashBaseUrl}';</script>
  <%-- <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> --%>
  <script src="/static/assets/splash_editor/js/lib/moment.min.js"></script>
  <script src="/static/assets/splash_editor/page/assets/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/static/assets/splash_editor/js/lib/Chart.min.js"></script>
  <script src="/static/assets/splash_editor/js/lib/Sortable.min.js">
  <script src="/static/assets/splash_editor/js/lib/editorjs@latest"></script>
  <script src="/static/assets/ckeditor/ckeditor.js"></script>
  
  <script src="/static/assets/splash_editor/js/lib/html5-qrcode.min.js" ></script>
  <script src="/static/assets/splash_editor/js/lib/qrcode.min.js" ></script>

  <script src="/static/assets/splash_editor/js/include-html.js"></script>
  <script src="/static/assets/splash_editor/js/util_func.js"></script>
  <script src="/static/assets/splash_editor/js/html_template.js"></script>
  <script src="/static/assets/splash_editor/js/api_func.js"></script>

  <script src="/static/assets/splash_editor/page/editor/include/login_config.js"></script>
  <script src="/static/assets/splash_editor/page/editor/include/page_config.js"></script>
  <script src="/static/assets/splash_editor/page/editor/include/image_config.js"></script>
  <script src="/static/assets/splash_editor/page/editor/include/logo_config.js"></script>
  <script src="/static/assets/splash_editor/page/editor/include/etc_config.js"></script>
  <script src="/static/assets/splash_editor/page/editor/include/theme_config.js"></script>
  <script src="/static/assets/splash_editor/page/editor/include/title_config.js"></script>
  <script src="/static/assets/splash_editor/page/editor/include/agree_config.js"></script>
  <script src="/static/assets/splash_editor/page/editor/include/survey_config.js"></script>

  <script src="/static/assets/splash_editor/page/editor/editor.js"></script>
  <script src="/static/assets/splash_editor/page/editor/preview_dragAndDrop.js"></script>

  <script src="/static/assets/splash_editor/page/include_preview/login.js"></script>
  <script src="/static/assets/splash_editor/page/include_preview/survey.js"></script>
  <script src="/static/assets/splash_editor/page/include_preview/agree.js"></script>

  <!--
  <script src="../assets/dist/js/bootstrap.bundle.min.js"></script>
  <script src="../assets/4.0/js/bootstrap.min.js"></script>
  -->
  <%-- <link rel="stylesheet" href="/static/assets/splash_editor/js/lib/bootstrap.min.css"> --%>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/includes/footer_script.jsp"></jsp:include>
<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. -->
<script>
    // openPreview = () => {
    //     const spi_id = g_G.splash_page_info.spi_id;
    //     const url = `/static/assets/splash_editor/page/preview/index.html?spi_id=${spi_id}`;
    //     window.open(url, 'splash_page_preview');
    // }
    window.addEventListener('load', function() {
        includeHTML(() => {
            g_G.is_splash_editor = true;
            g_G.is_show_eidtor_survey = '1';
            //console.log('@@@@@@@@@@@@@@@@@@@ init.js includeHTML');
            //$('#page_config').load("include/page_config.html");

            //test url :  http://localhost:8081/splash_editor/page/editor/index.html?spi_id=26
            // const rq = g_G.getUrlParams();
            const spi_id = getIdFromUrl();
            if (spi_id)
                g_G.call_eDB_KT_CAPTIVE_SPLASH_GET(spi_id, g_G.reload_splash_page_info_from_splashEditor);
            else {
                // alert('required param : spi_id');
            }
            startup_theme_bg_color();

        });

    });
    $(document).ready(function() {
      const spi_id = getIdFromUrl();

      $('#btn_goto_status').click(function() {
        location.href = '/splash_page_info/status?companyId=${splashPageInfo.getCompanyId()}&networkId=${splashPageInfo.getNetworkId()}&ssid='+ $('#editor_ssidId').val();
      })

      $('#btn_save_as').click(function() {
        const name = prompt("새 로그인 페이지 설정 이름을 입력하세요", g_G.splash_page_info.name + "의 사본("+ getFormDate() + ")");
        if (! name)
          return false;
        $.post(
          '/splash_page_info/api/v1/eDB_KT_CAPTIVE_SPLASH_COPY',
          {
            spi_id: spi_id,
            name: name,
          }, 
          (data) => {
            console.log('eDB_KT_CAPTIVE_SPLASH_COPY ', data);
            const new_spi_id = data;
            if (data.error) {
                alert('error: 23434 :' + data.error.toString);
                return;
            }
            openMenu('/splash_page_info/edit_view/'+ new_spi_id + '?fromSystem=arcus')
          }
        );
      })

      if (spi_id) {
        $('#btn_activate_spi').click(function() {
          $.ajax({
            type: "POST",
            url: "/splash_page_info/api/activate",
            contentType: "application/json",
            data: JSON.stringify({
              id: $('#editor_ssidId').val(),
              activedSpiId: spi_id
            }),
            error: function (xhr, option, error) {
                showAjaxError(xhr, option, error);
            },
            success: function () {
                alert("<spring:message code="common.ajax.save_succ"/>");
            }
          });
        })
      }
    })
</script>

</body>

</html>