<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="botDetect" uri="https://captcha.com/java/jsp"%>
<!DOCTYPE html>
<!-- saved from url=(0038)https://onebox.ollehkt.biz/onflogin.do -->
<html lang="ko"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title></title>



<meta http-equiv="X-UA-Compatible" content="IE=edge"><!-- 호환성 보기 막기 -->
<link rel="stylesheet" type="text/css" href="/static/onflogin.do_files/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/static/onflogin.do_files/style.css">
<link rel="stylesheet" type="text/css" href="/static/onflogin.do_files/alert.css">
<link rel="stylesheet" type="text/css" href="/static/onflogin.do_files/jquery-confirm.min.css">

<script type="text/javascript" async="" src="/static/onflogin.do_files/include.js"></script><script type="text/javascript" src="/static/onflogin.do_files/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="/static/onflogin.do_files/alert.js"></script>
<script src="/static/onflogin.do_files/jquery-confirm.min.js"></script>
<script src="/static/onflogin.do_files/jquery.fileDownload.js"></script>
<script type="text/javascript" src="/static/onflogin.do_files/framework.js"></script>
<script type="text/javascript" src="/static/onflogin.do_files/base64.js"></script>

<script type="text/javascript" src="/static/assets/rsa/jsbn.js"></script>
<script type="text/javascript" src="/static/assets/rsa/rsa.js"></script>
<script type="text/javascript" src="/static/assets/rsa/prng4.js"></script>
<script type="text/javascript" src="/static/assets/rsa/rng.js"></script>	

<script type="text/javascript" src="https://cdn.rawgit.com/ricmoo/aes-js/e27b99df/index.js"></script>

<script>
$.ajaxSetup({
    headers: {'${_csrf.headerName}': '${_csrf.token}'}
})
</script>
<script type="text/javascript">

//로그인 선택 탭
function openLogin(evt, login_select) {
    if (login_select === "OneBox") {
        // alert('OneBox system is not yet linked')
        // location.href = 'http://211.47.31.155:8085';
        location.href = 'https://managed.ollehkt.biz';
        return false;
    }

    // tab all off
    $(".tablink").removeClass("tab_on");

    // visual all display = none
    $(".login_visual").css("display", "none");
    
    // select tab on
    $("." + login_select).addClass("tab_on");
    
    // select visual display = block
    var visNum = 0;
    if(login_select == "Cisco")
    {
        visNum = 1;
        $("#loginType").val("Cisco");
        $("#downType").val("Cisco");    // guide download type
        $(".userId").html("Cisco <b>ID</b>");
    }
    else
    {
        // $("#loginType").val("OneBox");
        // $("#downType").val("OneBox");    // guide download type
        // $(".userId").html("OneBox <b>ID</b>");
        location.href = "https://managed.ollehkt.biz/onflogin.do"
    }
    
    $(".login_visual").eq(visNum).css("display", "block");
}

function submitForm() {
    //$("#loginForm").submit();
    
    if(!$("#j_captcha").val())
    {
        jAlert('자동등록방지숫자/문자를 순서대로 입력하세요.');
        //jAlert('문제가 발생하였습니다.');
        return false;
    }
    
    var rsaPublicKeyModulus = "";
    var rsaPublicKeyExponent = "";
    
    $.ajax({
        url : '/oneboxCert.do',
        //data: $('#loginForm input').serialize(),
        type: 'POST',
        dataType : 'json',
        beforeSend: function(xhr) {
             xhr.setRequestHeader("Accept", "application/json");
        },
        success : function(result){
            // 서버에서 할 일
            //   - id / pass 체크 실패 시 빈 결과 리턴
            if(!result)
            {
                jAlert("등록되지 않은 아이디 이거나 잘못된 비밀번호 입니다.\r\n5회 실패시, 로그인 접속이 제한됩니다.");
                return false;
            }
            
            rsaPublicKeyModulus = result.publicKeyModulus;
            rsaPublicKeyExponent = result.publicKeyExponent;
            
            var rsa = new RSAKey();
            rsa.setPublic(rsaPublicKeyModulus, rsaPublicKeyExponent);

            // 사용자ID와 비밀번호를 RSA로 암호화한다.
            var securedUsername = rsa.encrypt($("#ob_username").val());
            var securedPassword = rsa.encrypt($("#ob_password").val());
            
            // Cisco 로그인 시 패스워드 암호화
            if($("#loginType").val() == "Cisco")
            {
                // 원본
                //$("#j_username").val(base64_encode($("#ob_username").val()));
                //$("#j_password").val(base64_encode($("#ob_password").val()));
                
                // RSA 변경
                $("#j_username").val(securedUsername);
                $("#j_password").val(securedPassword);
            }
            else
            {
                // 원본
                //$("#j_username").val($("#ob_username").val());
                //$("#j_password").val($("#ob_password").val());
                
                // RSA 변경
                $("#j_username").val(securedUsername);
                $("#j_password").val(securedPassword);
            }
            
            $.ajax({
                url : '/loginCheck.do',
                data: $('#loginForm input').serialize(),
                type: 'POST',
                dataType : 'json',
                beforeSend: function(xhr) {
                     xhr.setRequestHeader("Accept", "application/json");
                },
                success : function(result){
                    // 서버에서 할 일
                    //   - captcha 보안문자 체크
                    //   - rest-auto-login 
                    var message = result.response.message;
                    var error = result.response.error;
                    if (error) get_msg(message);
                    
                    if (error == false) {
                        var url = '';

                        if (url == '') url = '/onebox/ready.do';
                        location.href = url;
                    }else{
                        if(message == "UPDATE_NEED"){
                            $("#j_username").val($("#ob_username").val());
                            $("#loginForm").attr("action","/join/passwordChange.do");
                            $("#loginForm").attr("onsubmit", "");
                            $("#loginForm").submit();
                        }else if(message == "EXPIRED"){
                            $("#j_username").val($("#ob_username").val());
                            $("#loginForm").attr("action","/join/expiredPasswordChange.do");
                            $("#loginForm").attr("onsubmit", "");
                            $("#loginForm").submit();
                        }else if (message == "Incorrect"){
                            jAlert("보안문자가 일치하지 않습니다.", "확인", function(){
                                $("#loginCaptcha_ReloadIcon").trigger("click");
                            });
                        } else{
                            // Cisco 로그인 연동 처리
                            var tmp = message.split("|");
                            
                            if(tmp[0] == "Cisco")
                            {
                                var ret = base64_decode(tmp[1]).split("|");
                                
                                if(ret[0] == "ok")
                                {
                                    // Cisco 로그인 연동 처리
                                    var Url = ret[1];
                                    var ID = ret[2];
                                    var Pwd = ret[3];
                                    
                                    $("#loginCaptcha_ReloadIcon").trigger("click");
                                    formLogin(Url, ID, Pwd);
                                }
                                else if(ret[0] == "fail")
                                {
                                    // Cisco 로그인 실패 처리
                                    var err_msg = ret[1];
                                    err_msg = err_msg.replace("nn", "\n");
                                    jAlert(err_msg, "확인", function(){
                                        $("#j_password").val("");
                                        $("#loginCaptcha_ReloadIcon").trigger("click");
                                    });
                                }
                                else
                                {
                                    // 그외(기존소스)
                                    jAlert(message);
                                    $("#loginCaptcha_ReloadIcon").trigger("click");
                                }
                            }
                            else
                            {
                                // 그외(기존소스)
                                jAlert(message);
                                $("#loginCaptcha_ReloadIcon").trigger("click");
                            }
                        }
                    }
                },
                error : function(){
                    jAlert('문제가 발생하였습니다.', "확인", function(){
                        location.href = "/onflogin.do";
                    });
                }
            });
        },
        error : function(){
            jAlert('문제가 발생하였습니다.');
        }
    });
}

function get_msg(message) {
    var move = '70px';
    jQuery('#message').text(message);
    jQuery('#message').animate({
         top : '+=' + move
    }, 'slow', function() {
         jQuery('#message').delay(1000).animate({ top : '-=' + move }, 'slow');
    });
}

function setform(id, password) {
    $("#j_username").val(id);
    $("#j_password").val(password);
}

function openJoinForm() {
    jAlert("관리자에게 문의하세요.");
}

/* 
 * Captcha Image 요청
 * [주의] IE의 경우 CaptChaImg.jsp 호출시 매번 변하는 임의의 값(의미없는 값)을 파라미터로 전달하지 않으면
 * '새로고침'버튼을 클릭해도 CaptChaImg.jsp가 호출되지 않는다. 즉, 이미지가 변경되지 않는 문제가 발생한다. 
 *  그러나 크롭의 경우에는 파라미터 전달 없이도 정상 호출된다.
 */

function winPlayer(objUrl) {
    $('#audiocatpch').html(' <bgsound src="' + objUrl + '">');
}

/* 
 * Captcha Audio 요청
 * [주의] IE의 경우 CaptChaAudio.jsp 호출시 매번 매번 변하는 임의의 값(의미없는 값)을 파라미터로 전달하지 않으면
 * '새로고침'된 이미지의 문자열을 읽지 못하고 최초 화면 로드시 로딩된 이미지의 문자열만 읽는 문제가 발생한다. 
 * 이 문제의 원인도 결국 매번 변하는 파라미터 없이는 CaptChaAudio.jsp가 호출되지 않기 때문이다. 
 * 그러나 크롭의 경우에는 파라미터 전달 없이도 정상 호출된다.  
 */
function changeCaptcha() {
 //IE에서 '새로고침'버튼을 클릭시 CaptChaImg.jsp가 호출되지 않는 문제를 해결하기 위해 "?rand='+ Math.random()" 추가 
 $('#catpcha').html('<img src="/join/getCapchaImg.do?rand='+ Math.random() + '"/>');
}
function audioCaptcha() {

  var uAgent = navigator.userAgent;
  var soundUrl = '/join/getCapchaAudio.do';
  if (uAgent.indexOf('Trident') > -1 || uAgent.indexOf('MSIE') > -1) {
      //IE일 경우 호출
      winPlayer(soundUrl+'?agent=msie&rand='+ Math.random());
  } else if (!!document.createElement('audio').canPlayType) {
      //Chrome일 경우 호출
      try { new Audio(soundUrl).play(); } catch(e) { winPlayer(soundUrl); }
  } else window.open(soundUrl, '', 'width=1,height=1');
}

//화면 호출시 가장 먼저 호출되는 부분 
$(document).ready(function() {

    changeCaptcha(); //Captcha Image 요청
 
    $('#reLoad').click(function(){ changeCaptcha(); }); //'새로고침'버튼의 Click 이벤트 발생시 'changeCaptcha()'호출
    $('#soundOn').click(function(){ audioCaptcha(); }); //'음성듣기'버튼의 Click 이벤트 발생시 'audioCaptcha()'호출
    
    
    /*
    $(document).on("keypress", function(){
        if(event.keyCode == 13){
            submitForm();            
        }
    });
    */
    
    // $(document).on("click", ".LoginSubmit", function(){
    //     submitForm();
    // });
    
    $(document).on("keyup", "#publicip", function(event){
        if (!(event.keyCode >=37 && event.keyCode<=40)) {
            var inputVal = $(this).val();
            $(this).val(inputVal.replace(/[^\.0-9]/gi,''));
        }
    });
    
    $(document).on("click", ".btnDownload", function() {
        // 가이드 다운로드
        /*
        var filename = '/images/guide/OneBox_guide_v1.pdf';
        $.fileDownload(filename)
        .done(function () {
            alert('File download a success!');
        })
        .fail(function () { alert('다운로드를 실패하였습니다.'); });
        */
        
        $.fileDownload($("#downladFrm").attr('action'),{
             checkInterval : 4000,
             //httpMethod: "POST",
             data : $("#downladFrm").serialize(),
             successCallback: function(url) {
                //redirect();
             },
             failCallback: function (html, url) {
                 alert("다운로드가 실패하였습니다.");
             }
        }); 
    });
});

function checkNewPassword(pw) {
    var pwNum = pw.search(/[0-9]/g);
    var pwEng = pw.search(/[a-z]/ig);
    var pwSpe = pw.search(/[~!@#$%^&*()\[\]_+|<>?:{}]/gi);
    
    if (pw.length < 10) {
        jAlert("비밀번호는 10자리 이상 입력해주세요.","알림");
        
        throw "password length 10 under";
    }
    
    if (pw.search(/\s/) != -1) {
        jAlert("비밀번호는 공백없이 입력해주세요.","알림");
        
        throw "empty digit";
    }
    
    if (pwNum < 0 || pwEng < 0 || pwSpe < 0) {
        jAlert("비밀번호는 영문, 숫자, 특수문자를 혼합하여 입력해주세요.","알림");
        
        throw "error";
    }
} 

function checkCustomerName(name, alertMsg, cn){
    
    if(cn == 1)
        var deny_pattern = /[^(가-힣a-zA-Z0-9\-)]/;
    else
        var deny_pattern = /[^a-zA-Z0-9\-]/;
    
    if(deny_pattern.test(name))
    {
        //jAlert(alertMsg);
        //throw "not valid";
        
        jAlert(alertMsg);
        return false;
    }
    return true;
}

function checkCustomereName(seq, alertMsg){
    var deny_pattern = /[^a-zA-Z0-9\-]/; 
    if(deny_pattern.test(seq))
    {
        jAlert(alertMsg);
        throw "not valid";
        return false;
    }
    return true;
}

function checkByte(string, alertMsg){
    var stringLength = string.length;
    var stringByteLength = 0;
    
    for(var i=0; i<stringLength; i++) {
        if(escape(string.charAt(i)).length >= 4)
            stringByteLength += 2;
        else if(escape(string.charAt(i)) == "%A7")
            stringByteLength += 2;
        else
            if(escape(string.charAt(i)) != "%0D")
                stringByteLength++;
    }
    if(stringByteLength > 50)
    {
        //jAlert(alertMsg);
        //throw "not valid";
        alert(alertMsg);
        return false;
    }
    return true;
} 

function goPasswordClear(account_id, features){
    /*
    $("#account_id").val(account_id);
    $("#customerForm").attr('action','/passwordClear.do');
    $("#customerForm").serialize();
    $("#customerForm").submit();
    */
    
    var popTitle = "passwdClear";
    
    window.open("", popTitle, features);
    
    $("#account_id").val(account_id);
    $("#customerForm").attr("target", popTitle);
    $("#customerForm").attr('action','/passwordClear.do');
    $("#customerForm").serialize();
    $("#customerForm").submit();
}


function MM_openBrWindow(theURL,winName,features) { //v2.0
    /*
    window.open("","popForm",features);
    $("#popForm").attr("target", "popForm");
    $("#popForm").submit();
    */

    password_reset(features);
}

function porc_resetPasswd()
{
    var param = {
        customerName : $("#customerName").val(),
        publicip : $("#publicip").val(),
        customerId : $("#customerId").val(),
    };
    
    if(validateCustomData(param))
    {
        var defaultOpt = {
            url:'/customerCheck.do',
            type:"post",
            dataType:'json',
            async:false,
            data:{
                customerName : param.customerName,
                customereName : param.customereName,
                customerId : param.customerId
            },
            success:function(data){
                if(data.success)
                {
                    goPasswordClear(data.account_id);
                }
                else
                {
                    jAlert(data.errMsg, "에러");
                }
            },
            error:function(){
                jAlert("입력된 정보가 맞지 않습니다.", "에러");
            }
        };
        fn.requestAjax(defaultOpt);
    }
}

function NullCheck(name, msg)
{
    if(!name)
    {
        alert(msg);
        return false;
    }
    
    return true;
}

function CheckParam(param)
{
    if(!NullCheck(param.customerName, "기업명을 입력해 주세요."))    return false;
    if(!checkCustomerName(param.customerName, "기업명은 한글,영문, 숫자만 가능합니다.", 1))    return false;
    if(!checkByte(param.customerName, "기업명은 한글 25자, 영문 50자 이하 입니다."))    return false;
    
    if(!NullCheck(param.publicip, "고객 IP를 입력해주세요."))    return false;
    if(!checkIP(param.publicip, "고객 IP는 숫자, '.'만 가능합니다.", 2))    return false;
    if(!checkByte(param.publicip, "고객 IP는 15자 이하입니다."))    return false;
    
    if(!NullCheck(param.customerId, "고객 ID를 입력해주세요."))    return false;
    
    return true;
}


// 패스워드 초기화
function password_reset(features){
    window.open("/rest-auth/reset_password", "", "width=800, height=600");
}


</script>
<link rel="shortcut icon" type="image/x-icon" href="https://onebox.ollehkt.biz/images/kt.olleh.onebox/favicon.ico" alt="kt">
</head>
<body class="login02">



<!-- 가이드 파일 다운로드 -->
<form id="downladFrm" name="downladFrm" action="https://onebox.ollehkt.biz/onebox/voc/api/guide/download" method="post">
<input type="hidden" name="downType" id="downType" value="OneBox">
</form>

<form method="post" action="https://onebox.ollehkt.biz/passwordClearPop.do" id="popForm">
</form>

<form id="customerForm" method="post">
<input type="hidden" name="account_id" id="account_id">
</form>

    <input type="hidden" id="RSAModulus" value="${RSAModulus}" />
    <input type="hidden" id="RSAExponent" value="${RSAExponent}" />
<h1 class="login_logo"><img src="/static/onflogin.do_files/logo_kt_bi.png" alt="KT"></h1>
<div class="login02_wrapper">
    <div class="login_tab fl_wrap">
        <!-- <button class="tablink OneBox" onclick="openLogin(event,&#39;OneBox&#39;)">One Box</button> -->
        <button class="tablink Cisco tab_on" style="text-align:left">Cisco</button>
    </div>
    
    
    <form name="loginForm" id="loginForm" method="post" onsubmit="return false;">
    <input name="${_csrf.parameterName}" type="hidden" value="${_csrf.token}"/>
    <input name="password" type="hidden">
    <%-- <input type="hidden" name="loginType" id="loginType" value="OneBox" readonly=""> --%>
    <%-- <input type="hidden" id="j_username" name="j_username" value="" readonly="">
    <input type="hidden" id="j_password" name="j_password" value="" readonly=""> --%>
    
    <!-- One Box -->
    <div id="OneBox" class="s_login fl_wrap">
        <div class="login_canvas fl_right" style="height:580px;">
            <div class="login_area">
                <p class="login_alert txt_888 txt_12 mt20 mb20">
                    <b class="txt_red">서비스 선택 후</b>, 로그인 해 주십시오.<br>(로그인 <b class="txt_000">5회 실패</b> 시, 로그인이 제한됩니다.) 
                </p>
                <ul class="input_area">
                    
                    <%-- <li class="input_idpw"><label for="id" class="userId">One Box <b>ID</b></label> <input type="text" id="ob_username" style="background:#FFF;"></li>
                    <li class="input_idpw"><label for="password">password</label> <input type="password" id="ob_password" style="width:70%;background:#FFF;"></li> --%>
                    <li class="input_idpw">
                        <label for="id" class="userId">Cisco <b>ID</b></label>
                        <input type="text" id="ob_username" name="loginId" style="background:#FFF;">
                    </li>
                    <li class="input_idpw">
                        <label for="raw_password">password</label>
                        <input type="password" id="ob_password" name="raw_password" autocomplete="off" style="width:70%;background:#FFF;">
                        <input type="hidden" name="passWord">
                    </li>
                    <li class="text_center mg20">
                        <div>
                            <botDetect:captcha id="loginCaptcha" userInputID="j_captcha" />
                            <%-- <div class="validationDiv">
                                <input name="captchaCode" type="text" id="captchaCode" value="${loginCaptcha.captchaCode}" />
                                <input type="button" name="validateCaptchaButton" onclick="validate()" value="Validate" id="validateCaptchaButton" />
                            </div> --%>
                        </div>
                    </li>
                    <li class="txt_12 txt_bbb text_center mg10">자동등록방지숫자/문자를 순서대로 입력하세요.</li>
                    <li class="input_idpw text_center"><input type="text" class="mg_c" onfocus="this.value=&#39;&#39;" id="j_captcha" name="j_captcha" style="text-transform: uppercase;background:#FFF;" maxlength="6" autocomplete="off"></li>
                    <%-- <li class="login_btn"><button class="LoginSubmit" onclick="validateCaptcha()">Login</button></li> --%>
                    <li class="login_btn"><button class="LoginSubmit" onclick="login()">Login</button></li>
                </ul> 
            </div>
            <ul class="login_guide mt20">
                <li><span></span> 상품정보는 KT영업사원 혹은 1588-0114 으로 문의하세요.</li>
                <li><span></span> 로그인 실패/정보분실 시 02-2651-2999 으로 문의하세요.</li>
                <%-- <li><span></span> 패스워드 분실 시 우측 초기화 버튼을 눌러 변경하세요. <button onclick="password_reset(); return false;">패스워드초기화</button></li> --%>
                <%-- <li><span></span> 서비스 설명이 필요하시면 가이드를 다운로드 하세요. <button class="btnDownload">다운로드</button></li> --%>
                <!-- <li><span></span> 서비스 설명이 필요하시면 가이드를 다운로드 하세요. <a href="/images/guide/OneBox_guide_v1.pdf" style="color:#117ae5;text-decoration:underline;">다운로드</a></li> -->
            </ul>
        </div>
        <!-- one box 비주얼 -->
        <div class="login_visual fl_left" style="display:none;">
            <p class="visual_shadow"></p>
            <span class="visual01"><img src="/static/onflogin.do_files/img_onebox01.png"></span>
            <span class="visual02"><img src="/static/onflogin.do_files/img_onebox02.png"></span>
            <span class="visual03"><img src="/static/onflogin.do_files/img_onebox03.png"></span>
            <span class="visual04"><img src="/static/onflogin.do_files/img_onebox04.png"></span>
        </div>
        <!-- //one box 비주얼 -->
        
        <!-- Cisco 비주얼 -->
        <div class="login_visual fl_left" style="display:block;">
            <p class="visual_shadow"></p>
            <span class="visual01"><img src="/static/onflogin.do_files/img_cisco01.png"></span>
            <span class="visual02"><img src="/static/onflogin.do_files/img_cisco02.png"></span>
            <span class="visual03"><img src="/static/onflogin.do_files/img_cisco03.png"></span>
            <span class="visual04"><img src="/static/onflogin.do_files/img_cisco04.png"></span>
        </div>
        <!-- //Cisco 비주얼 -->
        
    </div>
    <!-- //One Box -->

    <div class="login_footer2">
        <img src="/static/onflogin.do_files/bnr_managedon.png" alt="KT Managed ON" class="mb20">
        해당 Site는 해상도 1920*1080에 최적화 되어 있으며, 웹브라우저의 경우 chrome 브라우저에 최적화 되어 있습니다.<br>
        Internet Explorer의 경우 11이상, 최신 버전 이용을 권장합니다.
    </div>
    </form>
</div>

<script>
function arcusLogin() {
    var form = $('<form id="arcus_login_form" method="POST" action="/login">')

    var loginId  = $('#loginForm input[name="loginId"]').val()
    var password = $('#loginForm input[name="password"]').val()
    var captcha = $('#loginForm input[name="j_captcha"]').val()
    var captchaId = $('#loginForm input[name="BDC_VCID_loginCaptcha"]').val()

    var inputLoginId = $('<input type="hidden" name="loginId">').val(loginId)
    var inputPassword = $('<input type="hidden" name="passWord">').val(password)
    var inputCaptcha = $('<input type="hidden" name="j_captcha">').attr('value', captcha)
    var inputCaptchaId = $('<input type="hidden" name="BDC_VCID_loginCaptcha">').val(captchaId)
    var data = $('<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">')

    form.append(inputLoginId)
    form.append(inputPassword)
    form.append(inputCaptcha)
    form.append(inputCaptchaId)
    form.append(data)
    $('body').append(form)

    form.submit()
}

// function login(e) {
//     e.preventDefault()
//     $.ajax({
//         type: "POST",
//         url: "${grafana_url}/login",
//         contentType: "application/json",
//         //        data: JSON.stringify($('#form_user').serializeArray()),
//         data: JSON.stringify({
//             user: '${grafana_user}',
//             password: '${grafana_pass}'
//         }),
//         error: function (xhr, option, error) {
//             // showAjaxError(xhr, option, error);
//             // alert("<spring:message code="common.ajax.add_fail"/>");

//             return arcusLogin()
//             // if (confirm("Dashboard Server is Down. You can't use some dashboard elements.\n proceed to login?"))
//             //     return arcusLogin()
//             // else
//             //     return false;
//         },
//         success: function () {
//             return arcusLogin()
//         }
//     })
// }

$(document).ready(function() {
    $('input[name="loginId"]').focus();
    $('#id_btn_login').click(login)
    $('input[name="loginId"]').keypress(function(e) {
        if (e.keyCode == 13)
            return login(e)
    });
    $('input[name="passWord"]').keypress(function(e) {
        if (e.keyCode == 13)
            return login(e)
    });
});
</script>

<%-- captcha --%>
<script>
function validateCaptcha() {
    $.ajax({
        type: "post", 
        data: {
            'captchaCode': $('#j_captcha').val(),
            'instanceId': $('#BDC_VCID_loginCaptcha').val()
        },
        url: "/rest-auth/captcha/validate",
        dataType: 'json',
        timeout: 5000,
        success: function(resultVal){
            if (resultVal.result)
                login();
            else
                jAlert('보안문자가 일치하지 않습니다.');
        },
        error: function(e){
            jAlert("오류가 발생하였습니다.\n"+e.responseJSON.message);
        }
    });
}
</script>

<script>
    function zeroPad(src) {
        return ('0' + src).slice(-2)
    }

    function getDateKey() {
        var now = new Date()
        var key = now.getFullYear() 
                +'-'+zeroPad(now.getMonth()+1)
                +'-'+zeroPad(now.getDate())
                +'^'+zeroPad(now.getHours())
                +':'+zeroPad(now.getMinutes())
        return key
    }

    function login() {
		console.log('login')
        if (!$('#loginForm input[name="loginId"]').val()) {
            jAlert('아이디를 입력하세요')
            return false;
        }
        if (!$('#loginForm input[name="raw_password"]').val()) {
            jAlert('비밀번호를 입력하세요')
            return false;
        }
        if (!$('#loginForm input[name="j_captcha"]').val()) {
            jAlert('보안문자를 입력하세요')
            return false;
        }
        var rsa = new RSAKey();
        rsa.setPublic($("#RSAModulus").val(), $("#RSAExponent").val());
        $('#loginForm input[name="password"]').val(rsa.encrypt($('#loginForm input[name="raw_password"]').val()))

        $.ajax({
            type: 'POST',
            // url: '${base_url}/rest-auth/check_remote_login_wrap',
            url: '/rest-auth/check_remote_login_wrap',
            // url: '/rest-auth/test_post',
            // dataType: 'json',
            // data: $('#loginForm input').serialize(),
            // data: 'loginId='+$('#loginForm input[name="loginId"]').val()
            //     +'&password='+$('#loginForm input[name="password"]').val()
            //     +'&j_captcha='+$('#loginForm input[name="j_captcha"]').val()
            //     +'&BDC_VCID_loginCaptcha='+$('#loginForm input[name="BDC_VCID_loginCaptcha"]').val(),
            contentType: "application/json",
            data: JSON.stringify({
                loginId:   $('#loginForm input[name="loginId"]').val(),
                password:  $('#loginForm input[name="password"]').val(),
                captcha:   $('#loginForm input[name="j_captcha"]').val(),
                captchaId: $('#loginForm input[name="BDC_VCID_loginCaptcha"]').val(),
            }),
            success: function(data) {
                if (data.result == 'ok') {
                    // formLogin(data.redirect, data.ID, data.Pwd)
                    arcusLogin();
                } else if (data.result == 'captcha_fail') {
                    jAlert(data.err_msg, "확인", function() {
                        $('.BDC_ReloadIcon').trigger('click');
                    })
                } else {
                    jAlert(data.err_code + ': ' + data.err_msg, "확인", function() {
                        $('.BDC_ReloadIcon').trigger('click');
                    })
                }
            },
            error: function(xhr, option, error) {
                console.log('error')
                console.log(error)
                $('.BDC_ReloadIcon').trigger('click');
            }
        })
    }

</script>


</body></html>