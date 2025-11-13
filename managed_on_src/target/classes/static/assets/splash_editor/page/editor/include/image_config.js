// <!-- 배너 이미지 -->
let is_no_save_banner = true;

function save_image_config() {
    // if (is_no_save_banner == false) {
    //     alert("이미지 사이즈는 1080px X 200px 보다 작아야 합니다.");
    //     return;
    // }
    g_G.call_eDB_KT_CAPTIVE_SPLASH_UPDATE();

}

const ALLOWED_PREVIEW_IMAGE_TYPES = Object.freeze([
    "image/jpeg",
    "image/png",
    "image/gif",
    "image/webp",
    "image/bmp"
]);

let currentPreviewObjectUrl = null;

function image_config_showMyImage(fileInput) {
    var files = fileInput.files;
    for (var i = 0; i < files.length; i++) {
        var file = files[i];
        var imageType = /image.*/;
        if (!file.type.match(imageType)) {
            continue;
        }
        if (ALLOWED_PREVIEW_IMAGE_TYPES.indexOf(file.type) === -1) {
            alert("지원하지 않는 이미지 형식입니다. (허용: JPG, PNG, GIF, WEBP, BMP)");
            continue;
        }
        if (file.size > 6000000) {
            alert("이미지 사이즈는 5메가 이하여야 합니다.");
        }

        var img = document.getElementById("image_config_preview");
        img.file = file;
        console.log('file=', file.name, file.size);
        var reader = new FileReader();
        reader.onload = (function(aImg) {
            return function(e) {
                if (currentPreviewObjectUrl) {
                    window.URL.revokeObjectURL(currentPreviewObjectUrl);
                    currentPreviewObjectUrl = null;
                }
                var objectUrl = window.URL.createObjectURL(file);
                currentPreviewObjectUrl = objectUrl;
                aImg.src = objectUrl;
                g_G.log('aImg=', $("#image_config_preview").height(), $("#image_config_preview").width());

                // if ($(aImg).height() > 200 || $(aImg).width() > 1080) {
                //     is_no_save_banner = false;
                //     alert("이미지 사이즈는 1080px X 200px 보다 작아야 합니다.");
                //     return;
                // }
                image_config_upload();
            };
        })(img);
        reader.readAsDataURL(file);
    }
}

function image_config_upload() {
    const spi = g_G.splash_page_info;
    var file_data = $('#image_config_upload_file').prop('files')[0];
    if (file_data == null) {
        alert('select file');
        return;
    }
    var form_data = new FormData();
    form_data.append('file', file_data);
    form_data.append('ssid', spi.ssid);
    form_data.append('company_id', spi.company_id);
    form_data.append('network_id', spi.network_id);
    form_data.append('image_type', "banner");

    console.log('form_data=', form_data);
    $.ajax({
        url: `${API_URL_HEADER}/eFILE_IMAGE_UPLOAD`, // point to server-side controller method
        dataType: 'text', // what to expect back from the server
        cache: false,
        contentType: false,
        processData: false,
        data: form_data,
        type: 'post',
        success: function(resp) {
            const data = JSON.parse(resp)[0].original;
            g_G.logLoy('image_config_upload ok ', data);
            const pti_id = data.pti_id;
            g_G.splash_page_info.banner_image_id = pti_id;
            g_G.setup_preview_ui_image_config(g_G.splash_page_info);

        },
        error: function(resp) {
            alert('error:' + resp);
        }
    });
}

function image_config_bannerImageDelete() {
    g_G.splash_page_info.banner_image_id = -1;
    g_G.setup_preview_ui_image_config(g_G.splash_page_info);
    //g_G.setupEditorUI_image_config(g_G.splash_page_info);
    if (currentPreviewObjectUrl) {
        window.URL.revokeObjectURL(currentPreviewObjectUrl);
        currentPreviewObjectUrl = null;
    }
    $('#image_config_preview').attr('src', "/static/assets/splash_editor/img/1080x200upload.png");

}


// 배너 이미지 에디터 ui
g_G.setupEditorUI_image_config = (splash_page_info) => {

    let url = `${API_URL_HEADER}/eFILE_IMAGE_GET?pti_id=` + splash_page_info.banner_image_id;
    if (splash_page_info.banner_image_id == -1) {
        url = "/static/assets/splash_editor/img/1080x200upload.png";
    }
    //console.log('url = ', url);
    $('#image_config_preview').attr('src', url);
}