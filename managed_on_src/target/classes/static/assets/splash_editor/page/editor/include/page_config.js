g_G.setupEditorUI_page_config = (ssid) => {
    g_G.call_eDB_KT_CAPTIVE_SPLASH_LIST(ssid, (data) => {
        if (typeof data == 'string') {
            data = JSON.parse(data);
        }

        g_G.logLoy('g_G.setup _editor_ui_page_config', data);
        g_G.eDB_KT_CAPTIVE_SPLASH_LIST = data.result;
        let i = 0;
        $('#splash_table_body_in_editor *').remove();
        for (const splash_page_info of g_G.eDB_KT_CAPTIVE_SPLASH_LIST) {
            const html = g_G.html.get_splash_list_row_in_editor(splash_page_info, ++i % 2);
            $('#splash_table_body_in_editor').append(html);
        }

    });
}

function delete_curr_splash_page_info() {
    const spi_id = $('input[name="radios_page_config"]:checked').val();
    if (spi_id == null) {
        alert('삭제할 스플레시 페이지를 선택하세요');
        return;
    }
    g_G.logLoy('delete_curr_splash_page_info', spi_id, g_G.splash_page_info.spi_id);
    g_G.send_eDB_KT_CAPTIVE_SPLASH_DEL(spi_id, (data) => {
        if (data.error) {
            alert('error: 456322 :' + data.error.toString());
            return;
        }
        $('#' + spi_id).remove();
        if (spi_id == g_G.splash_page_info.spi_id) {
            g_G.goto_splash_list();
        }

    });
}


function load_curr_splash_page_info() {
    const spi_id = $('input[name="radios_page_config"]:checked').val();
    if (spi_id == null) {
        alert('데이타를 불러올 스플레시 페이지를 선택하세요');
        return;
    }
    const spi = g_G.eDB_KT_CAPTIVE_SPLASH_LIST.find(s => { return s.spi_id == spi_id; });
    if (spi == null) {
        alert('data error : 89234 : reload page');
        return;
    }
    if (g_G.ARCUS_EDITOR) {
        location.href = '/splash_page_info/edit_view/' + encodeURIComponent(spi_id) + '?fromSystem=arcus';
    } else {
        spi.spi_id = g_G.splash_page_info.spi_id;
        g_G.splash_page_info = spi;
        g_G.reload_splash_page_info_from_splashEditor(g_G.splash_page_info);
    }

}

function set_default_splash_page_info() {

}