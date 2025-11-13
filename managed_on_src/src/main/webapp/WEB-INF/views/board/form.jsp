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
    small {
        margin-left: 3px;
        font-weight: bold;
        color: gray;
    }
    .detail-dropzone {
        min-height: 180px;
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
                <form>
                    <div class="card">
                        <div class="card-body form-horizontal row-border">
                            <input type="hidden" id="id_boardTypeCode" name="boardTypeCode" value="${ boardType }">
                            <div class="d-sm-flex">
                                <div class="col-sm-2 detail-col-label py-sm-3 py-2 border-top">
                                    <spring:message code="board.view.fields.boardSettings"/>
                                </div>
                                <div class="col-sm-10 py-2 border-top form-inline">
                                    <div class="checkbox checkbox-inline">
                                        <input type="checkbox" id="id_boardTopYn" name="boardTopYn">
                                        <label for="id_boardTopYn"><spring:message code="board.view.fields.boardTopYn"/></label>
                                    </div>
                                    <div class="checkbox checkbox-inline">
                                        <input type="checkbox" id="id_boardCriticalYn" name="boardCriticalYn">
                                        <label for="id_boardCriticalYn"><spring:message code="board.view.fields.boardCriticalYn"/></label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-sm-flex">
                                <div class="col-sm-2 detail-col-label py-sm-3 py-2 border-top">
                                    <spring:message code="board.view.fields.boardTitle"/>*
                                </div>
                                <div class="col-sm-10 py-2 border-top">
                                    <input type="text" id="id_boardTitle" name="boardTitle" maxlength="200" class="form-control" placeholder="Enter Boardtitle" required>
                                </div>
                            </div>
                            <div class="d-sm-flex border-bottom">
                                <div class="col-sm-2 detail-col-label py-sm-3 py-2 border-top">
                                    <spring:message code="board.view.fields.boardContent"/>
                                </div>
                                <div class="col-sm-10 py-2 border-top">
                                    <textarea id="id_boardContent" name="boardContent" rows="8" col='80'></textarea>
                                </div>
                            </div>
                            <%-- <div class="d-sm-flex border-bottom">
                                <div class="col-sm-2 detail-col-label py-sm-3 py-2 border-top detail-dropzone">
                                    <spring:message code="board.view.fields.attachFile"/>
                                </div>
                                <div class="col-sm-10 py-2 border-top fileDrop">
                                    <div id="id_attachFile" class="uploadedList">
                                        <span><spring:message code="board.view.fields.attachFileList"/></span>
                                    </div>
                                </div>
                            </div> --%>
                        </div>
                        <div class="card-footer">
                            <div>
                                <button type="button" id="btn_list" class="btn btn-default"><spring:message code="common.view.button.list"/></button>
                                <c:if test="${authData.hasWrightAuth(requestScope['javax.servlet.forward.request_uri'])}">
                                    <button type="button" id="btn_save" class="btn btn-primary btn-right"><spring:message code="common.view.button.save"/></button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </form>
            </section>

		</div> <!-- /.container-fluid -->
	</div> <!-- /.page-content -->
</div>


<jsp:include page="/WEB-INF/views/includes/footer.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/includes/footer_script.jsp"></jsp:include>
<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. -->

<!-- include summernote css/js -->
<script src="/static/assets/ckeditor/ckeditor.js"></script>
<script>
var boardType = '${ boardType }';
var boardRoot = '/board/' + boardType;

.create(document.querySelector('#id_boardContent'), {
toolbar: ['heading','bold','italic','link','bulletedList','numberedList','blockQuote']
})
.then(editor => {
window.editor = editor; // 필요 시 글로벌 참조
})
.catch(error => {
console.error('CKEditor 초기화 오류', error);
});

// summernote disable upload div
var imageUploadDiv = $('div.note-group-select-from-files');
if (imageUploadDiv.length) {
  imageUploadDiv.remove();
}

function isFormValid(reqData) {
    // Insert custom validation logic here!

    $('.static-content form').validate({
        messages: {
            boardId: '<spring:message code="board.validation.boardId.required"/>',
            boardTypeCode: '<spring:message code="board.validation.boardTypeCode.required"/>',
            boardTitle: '<spring:message code="board.validation.boardTitle.required"/>',
            boardTopYn: '<spring:message code="board.validation.boardTopYn.required"/>',
            boardCriticalYn: '<spring:message code="board.validation.boardCriticalYn.required"/>',
            deleteYn: '<spring:message code="board.validation.deleteYn.required"/>',
        }
    });
    if (! $('.static-content form').valid()) {
        // alert('<spring:message code="common.validation.fail"/>');
        return false;
    }
    return true;
}

function getAttachFilePaths() {
    var paths = [];
    $('input[name="attach_file_path"]').each(function() {
        paths.push($(this).val());
    })
    return paths;
}


function makeAttachFileLinks(paths) {
    $.each(paths, function() {
        addAttachFileLink($(".uploadedList"), this, true);
    });
}

var mode = getPartFromUrl(1);  // add_view/update_view
if (mode == 'update_view') {
    $('#id_page_sub_title').text('<spring:message code="board.view.update.page_sub_title"/>');
} else {
    $('#id_page_sub_title').text('<spring:message code="board.view.add.page_sub_title"/>');
}

if (mode == 'update_view') {
    var id = getIdFromUrl();
    var reqData = {
        boardId: id
    }

    $.ajax({
        type: 'GET',
        url: "/board/" + boardType + "/api/get",
        contentType: 'application/json',
        data: reqData,
        error: showAjaxError,
        success: function (resData) {
        	var boardContent = $('#id_boardContent').summernote('code');
            $('#id_boardId').val(resData.boardId);
            $('#id_boardTypeCode').val(resData.boardTypeCode);
            $('#id_boardSubdivideCode').val(resData.boardSubdivideCode);
            $('#id_boardTitle').val(resData.boardTitle);
            /* $('#id_boardContent').val(resData.boardContent); */
            $('#id_boardContent').summernote('code', resData.boardContent);
            setYn($('#id_boardTopYn'), resData.boardTopYn);
            setYn($('#id_boardCriticalYn'), resData.boardCriticalYn);
            $('#id_regDt').val(resData.regDt);
            $.each(resData.attachFilePaths, function(i, path) {
                addAttachFileLink($('#id_attachFile'), path, true);
                $('.fileDrop').append(makeInputHiddenStr('attach_file_path', path))
            })
        }
    });

<c:if test="${authData.hasWrightAuth(requestScope['javax.servlet.forward.request_uri'])}">
    $('#btn_save').click(function () {
        var reqData = {
            boardId: id,
            boardTypeCode: $('#id_boardTypeCode').val(),
            boardSubdivideCode: $('#id_boardSubdivideCode').val(),
            boardTitle: $('#id_boardTitle').val(),
            boardContent: $('#id_boardContent').summernote('code'),
            boardTopYn: getYn($('#id_boardTopYn')),
            boardCriticalYn: getYn($('#id_boardCriticalYn')),
            attachFilePaths: getAttachFilePaths(),
        }
        if (! isFormValid(reqData)) {
            return false;
        }
        $.ajax({
            type: "POST",
            url: "/board/" + boardType + "/api/update",
            contentType: "application/json",
            //		data: JSON.stringify($('#form_user').serializeArray()),
            data: JSON.stringify(reqData),
            // error: function (xhr, option, error) {
            //     var $modal = $('#modal_ajax_error');
            //     if ($modal) {
            //         $modal.find('.modal-body span').text(xhr.responseText);
            //         $modal.modal();
            //         $modal.focus();
            //     } else {
            //         alert(xhr.responseText);
            //         // alert("<spring:message code="common.ajax.edit_fail"/>");
            //     }
            // },
            error: showAjaxError,
            success: function () {
                alert("<spring:message code="common.ajax.edit_succ"/>");
                location.href = boardRoot + '/list_view';
            }
        });
    });
</c:if>
} else { // add_view
<c:if test="${authData.hasWrightAuth(requestScope['javax.servlet.forward.request_uri'])}">
    $('#btn_save').click(function () {
        var reqData = {
            boardTypeCode: $('#id_boardTypeCode').val(),
            boardSubdivideCode: $('#id_boardSubdivideCode').val(),
            boardTitle: $('#id_boardTitle').val(),
            boardContent: $('#id_boardContent').summernote('code'),
            boardTopYn: getYn($('#id_boardTopYn')),
            boardCriticalYn: getYn($('#id_boardCriticalYn')),
            attachFilePaths: getAttachFilePaths(),
        }
        if (! isFormValid(reqData)) {
            return false;
        }
        $.ajax({
            type: "POST",
            url: "/board/" + boardType + "/api/add",
            contentType: "application/json",
            //		data: JSON.stringify($('#form_user').serializeArray()),
            data: JSON.stringify(reqData),
            // error: function (xhr, option, error) {
            //     var $modal = $('#modal_ajax_error');
            //     if ($modal) {
            //         $modal.find('.modal-body span').text(xhr.responseText);
            //         $modal.modal();
            //         $modal.focus();
            //     } else {
            //         alert(xhr.responseText);
            //         // alert("<spring:message code="common.ajax.add_fail"/>");
            //     }
            // },
            error: showAjaxError,
            success: function () {
                alert("<spring:message code="common.ajax.add_succ"/>");
                location.href = boardRoot + '/list_view';
            }
        });
    });
</c:if>
}

$('#btn_list').click(function() {
    openMenu(boardRoot + '/list_view');
});

$(function () {
    $(".fileDrop").on("dragenter dragover", function(event){
        event.preventDefault();
    });
    
    $(".fileDrop").on("drop", function(event){
        if ($('.fileDrop a').length >= MAX_UPLOAD_COUNT) {
            alert('<spring:message code="board.validation.attachFileList.max_file_upload_count"/>');
            return false;
        }
        event.preventDefault();
        
        var files = event.originalEvent.dataTransfer.files;
        var file = files[0];
        
        //console.log(file);
        
        var formData = new FormData(); 
        formData.append("file", file);
        
        $.ajax({
            url: '/upload/uploadAjax',
            data: formData,
            dataType: 'text',
            processData: false,
            contentType: false,
            type: 'POST',
            error: showAjaxError,
            success: function(data){
                // alert(data);

                $('.fileDrop').append(makeInputHiddenStr('attach_file_path', data))

                addAttachFileLink($(".uploadedList"), data, true);
            },
        });// ajax
    });
    
    //업로드 파일 삭제 처리
    $(".uploadedList").on("click", "small", function(event){
        
        var that = $(this);
        
        // alert($(this).attr("data-src"));
        if (! confirm('삭제 하시겠습니까?')) {
            return false;
        }

        var del_path = $(this).attr('data-src');
        var $relHidden = $('input[type="hidden"]').filter(function() {
            return this.name == 'attach_file_path'
                && this.value == del_path;
        })
        $relHidden.remove();
        
        $.ajax({
            url: "/upload/deleteFile",
            type: "post",
            data: {fileName:$(this).attr("data-src")},
            dataType: "text",
            error: showAjaxError,
            success : function(result){
                if(result == 'deleted'){
                    //alert("deleted");
                    that.parent("div").remove();
                }//
            },
        });
        
    });//uploadedList
    
});

</script>
</body>
</html>