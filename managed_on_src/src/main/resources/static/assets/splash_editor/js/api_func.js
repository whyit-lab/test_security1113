let API_URL_HEADER;
let SPLASH_URL_HEADER;
if (window.location.href.indexOf('localhost') == -1) {
    // API_URL_HEADER = 'https://dev1ssl.whyit.co.kr:8081/api/v1';
    // SPLASH_URL_HEADER = 'https://dev1ssl.whyit.co.kr:8081/static/assets/splash_editor/page';
    API_URL_HEADER = '/api/v1';
    SPLASH_URL_HEADER = '/static/assets/splash_editor/page';
    if (window.location.href.indexOf('dev1ssl.whyit') == -1) {
        g_G.logLoy = () => {}
        g_G.log = () => {}
    }
} else {
    API_URL_HEADER = 'http://localhost:8081/api/v1';
    SPLASH_URL_HEADER = 'http://localhost:8081/static/assets/splash_editor/page';
}

if (g_G.ARCUS_EDITOR) {

    API_URL_HEADER = '/splash_page_info/api/v1';
}


$(function() {
    "use strict";
    g_G.recv_eDB_KT_CAPTIVE_COMPANY = (data) => {
        if (typeof data == 'string') {
            data = JSON.parse(data);
        }

        g_G.eDB_KT_CAPTIVE_COMPANY = data.result;
        console.log('recv_eDB_KT_CAP TIVE_COMPANY=', g_G.eDB_KT_CAPTIVE_COMPANY);
        $('#eDB_KT_CAPTIVE_COMPANY *').remove();
        g_G.eDB_KT_CAPTIVE_COMPANY.forEach(function(o) {
            let option = "<option></option>";
            $('#eDB_KT_CAPTIVE_COMPANY')
                .append($(option)
                    .attr("value", o.id) //company_id
                    .text(o.name));
        });
        $("#eDB_KT_CAPTIVE_COMPANY").change(function() {
            const company_id = $("#eDB_KT_CAPTIVE_COMPANY").val();
            // g_G.disableHtmlControl(true, true);
            $.get(`${API_URL_HEADER}/eDB_KT_CAPTIVE_NETWORK_LIST?company_id=${company_id}`,
                g_G.recv_eDB_KT_CAPTIVE_NETWORK_LIST);
        });
        if (g_G.eDB_KT_CAPTIVE_COMPANY.length > 0) {
            let company = g_G.eDB_KT_CAPTIVE_COMPANY[0];
            if (g_G.curr_company_id) {
                let find_company = g_G.eDB_KT_CAPTIVE_COMPANY.find(c => {
                    return c.id == g_G.curr_company_id;
                });
                if (find_company == null) {
                    const company_id = g_G.curr_company_id;
                    find_company = g_G.eDB_KT_CAPTIVE_COMPANY.find(c => {
                        return c.id == company_id;
                    });
                }
                if (find_company) {
                    company = find_company;
                }
            }

            $.get(`${API_URL_HEADER}/eDB_KT_CAPTIVE_NETWORK_LIST?company_id=${company.id}`,
                g_G.recv_eDB_KT_CAPTIVE_NETWORK_LIST);
        }

    }

    g_G.recv_eDB_KT_CAPTIVE_NETWORK_LIST = (data) => {
        if (typeof data == 'string') {
            data = JSON.parse(data);
        }

        g_G.eDB_KT_CAPTIVE_NETWORK_LIST = data.result;
        g_G.logLoy('eDB_KT_CAPTIVE_NETWORK_LIST= ', data);
        $('#eDB_KT_CAPTIVE_NETWORK_LIST *').remove();
        g_G.eDB_KT_CAPTIVE_NETWORK_LIST.forEach(function(n) {
            $('#eDB_KT_CAPTIVE_NETWORK_LIST')
                .append($("<option></option>")
                    .attr("value", n.id)
                    .text(n.name));
        });
        $("#eDB_KT_CAPTIVE_NETWORK_LIST").change(function() {
            const network_id = $("#eDB_KT_CAPTIVE_NETWORK_LIST").val();
            g_G.logLoy('network_id=', network_id);
            const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SSID_LIST?network_id=${network_id}`;
            var jqxhr = $.get(url, g_G.recv_eDB_KT_CAPTIVE_SSID_LIST);
        });
        if (g_G.eDB_KT_CAPTIVE_NETWORK_LIST.length > 0) {
            let network = g_G.eDB_KT_CAPTIVE_NETWORK_LIST[0];
            if (g_G.curr_network_id) {
                network = g_G.eDB_KT_CAPTIVE_NETWORK_LIST.find(n => {
                    return n.id == g_G.curr_network_id;
                });
                if (network == null) {
                    console.error('923 network==null');
                    network = g_G.eDB_KT_CAPTIVE_NETWORK_LIST[0];
                }
            }

            const network_id = network.id;
            const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SSID_LIST?network_id=${network_id}`;
            var jqxhr = $.get(url, g_G.recv_eDB_KT_CAPTIVE_SSID_LIST);
        }
    }

    g_G.recv_eDB_KT_CAPTIVE_SSID_LIST = (data) => {
        if (typeof data == 'string') {
            data = JSON.parse(data);
        }

        g_G.eDB_KT_CAPTIVE_SSID_LIST = data.result;
        g_G.logLoy('eDB_KT_CAPTIVE_SSID_LIST= ', data);
        $('#eDB_KT_CAPTIVE_SSID_LIST *').remove();
        g_G.eDB_KT_CAPTIVE_SSID_LIST.forEach(function(n) {
            $('#eDB_KT_CAPTIVE_SSID_LIST')
                .append($("<option></option>")
                    .attr("value", n.id)
                    .text(n.name));
        });
        $("#eDB_KT_CAPTIVE_SSID_LIST").change(function() {
            const ssid = $("#eDB_KT_CAPTIVE_SSID_LIST").val();
            //g_G.logLoy('network_id=', network_id);
            const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_LIST?ssid=${ssid}`;
            var jqxhr = $.get(url, g_G.recv_eDB_KT_CAPTIVE_SPLASH_LIST);
        });
        if (g_G.eDB_KT_CAPTIVE_SSID_LIST.length > 0) {
            let ssid = g_G.eDB_KT_CAPTIVE_SSID_LIST[0].id;
            if (g_G.curr_ssid) {
                ssid = g_G.curr_ssid;
            }

            const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_LIST?ssid=${ssid}`;
            var jqxhr = $.get(url, g_G.recv_eDB_KT_CAPTIVE_SPLASH_LIST);
        }

    }

    g_G.call_eDB_KT_CAPTIVE_SPLASH_LIST = (ssid, CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_LIST?ssid=${ssid}`;
        var jqxhr = $.get(url, CB);
    }
    g_G.call_eDB_KT_CAPTIVE_SPLASH_GET = (spi_id, CB) => {
        let url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_GET?spi_id=${spi_id}`;
        if (g_G.is_show_eidtor_survey) {
            url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_GET?spi_id=${spi_id}&is_show_eidtor_survey=true`;
        }
        g_G.log('call_eDB_KT_CAPTIVE_SPLASH_GET call :', url);
        g_G.log('g_G.call_eDB_KT_C APTIVE_SPLASH_GET = spi_id', spi_id);

        var jqxhr = $.get(url, (data) => {
            if (typeof data == 'string') {
                data = JSON.parse(data);
            }
            if (data.error) {
                alert(data.error);
                return;
            }
            g_G.log('call_eDB_KT_CAPTIVE_SPLASH_GET = ', data);
            g_G.pubKey_RSA = data.pubKey_RSA;
            g_G.splash_page_info = data.splash_page_info;
            g_G.splash_page_info_company = data.company;
            g_G.splash_page_info_network = data.network;
            g_G.splash_page_info_ssid_info = data.ssid_info;
            g_G.agreement_page_list = data.agreement_page_list;
            g_G.survey_sheet_list = data.survey_sheet_list;
            g_G.login_url = data.login_url;
            g_G.CAP_MERAKI_CLOUD_SUCCESS_URL_DOMAIN = data.CAP_MERAKI_CLOUD_SUCCESS_URL_DOMAIN;
            g_G.continue_url = data.continue_url;
            g_G.server_url = data.server_url;
            // g_G.agreement_page_list.sort((a, b) => {
            //     return a.order - b.order;
            // });
            if (g_G.splash_page_info && g_G.splash_page_info.agree_need_list && g_G.splash_page_info.agree_need_list.length > 0) {
                for (const a of g_G.agreement_page_list) {
                    if (a == null) continue;
                    a.is_need = false;
                }
                let ap_id_list = g_G.splash_page_info.agree_need_list.split(',');
                for (const ap_id of ap_id_list) {
                    const agreement_page = g_G.agreement_page_list.find(a => {
                        return a &&
                            a.ap_id == ap_id;
                    });
                    if (agreement_page)
                        agreement_page.is_need = true;
                }
            } else {
                if (g_G.agreement_page_list)
                    for (const a of g_G.agreement_page_list) {
                        if (a)
                            a.is_need = true;
                    }

            }
            if (g_G.splash_page_info && g_G.splash_page_info.agree_use_list && g_G.splash_page_info.agree_use_list.length > 0) {
                for (const a of g_G.agreement_page_list) {
                    if (a)
                        a.is_use = false;
                }
                let ap_id_list = g_G.splash_page_info.agree_use_list.split(',');
                for (const ap_id of ap_id_list) {
                    const agreement_page = g_G.agreement_page_list.find(a => {
                        return a && a.ap_id == ap_id;
                    });
                    if (agreement_page)
                        agreement_page.is_use = true;
                }
            } else {
                if (g_G.splash_page_info && g_G.agreement_page_list)
                    for (const a of g_G.agreement_page_list) {
                        if (a) {
                            a.is_use = true;
                        }
                    }

            }
            if (g_G.splash_page_info) {

                const agree_order_list = g_G.splash_page_info.agree_order_list;
                if (agree_order_list && agree_order_list.length > 0) {
                    let ap_id_list = agree_order_list.split(',');
                    let _agreement_page_list = [];
                    ap_id_list.reverse();
                    for (const _ap_id of ap_id_list) {
                        const idx = g_G.agreement_page_list.findIndex(a => {
                            return a && a.ap_id == _ap_id;
                        });
                        if (idx == -1) {
                            //console.error('_api_id not found ', _ap_id);
                            continue;
                        }
                        const save = g_G.agreement_page_list[idx];
                        //g_G.log('save = ', save, idx);
                        g_G.agreement_page_list.splice(idx, 1);
                        g_G.agreement_page_list.unshift(save);
                    }
                }
            }

            //console.log('1234 call_eDB_KT_CAPTIVE _SPLASH_GET', g_G.splash_page_info, g_G.agreement_page_list);
            if (CB)
                CB(g_G.splash_page_info);
        }).fail(function(err) {
            if (typeof err.responseText == 'string') {
                err = JSON.stringify(err.responseText);
            }
            //console.error(err);
            //alert("스플래시 페이지가 존재하지 않습니다.");
            if (CB)
                CB(null);
        });

    }


    // 선택된 로그인 페이지를 현제 ssid에 기본 로그인 페이지로 지정한다.
    g_G.call_eDB_KT_CAPTIVE_SPLASH_ACTIVE = (btndel) => {
        const tr = $(btndel).closest("tr");
        const spi_id = tr.find('#spi_id').text();
        g_G.send_eDB_KT_CAPTIVE_SPLASH_ACTIVE(spi_id, (data) => {
            if (data.error) {
                alert('error: 45622 :' + data.error.toString());
                return;
            }

        });
    }
    g_G.send_eDB_KT_CAPTIVE_SPLASH_ACTIVE = (spi_id, CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_ACTIVE`;
        const body = {
            "spi_id": spi_id,
        };

        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            data: JSON.stringify(body),
            success: function(data) {
                if (typeof data == 'string') {
                    data = JSON.parse(data);
                }

                console.log('eDB_KT_CAPTIVE_SPLASH_ACT IVE ', data);
                return CB(data);
            }
        });


    }

    g_G.call_eDB_KT_CAPTIVE_SPLASH_UPDATE = () => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_UPDATE`;
        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            data: JSON.stringify(g_G.splash_page_info),
            success: function(data) {
                if (typeof data == 'string') {
                    data = JSON.parse(data);
                }
                if (data.error) {
                    if (g_G.ARCUS_EDITOR) {
                        console.log('error: 768 :' + data.error.toString);
                        alert('저장에 실패 하였습니다.1');
                        return;
                    }
                    alert('저장에 실패 하였습니다.2');
                    //g_G.showAlert('error: 768 :' + data.error.toString);
                    return;
                }
                g_G.log('eDB_KT_CAPTIVE_SPLASH_UPDATE save ok ', data, g_G.splash_page_info);
                g_G.is_modifyed_splash_page_info = false;
            }
        });


    }



    // splash_editor.html
    g_G.send_eDB_KT_CAPTIVE_SPLASH_DEL = (spi_id, CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_DEL`;
        const body = {
            "spi_id": spi_id,
        };

        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            data: JSON.stringify(body),
            success: function(data) {
                if (typeof data == 'string') {
                    data = JSON.parse(data);
                }
                console.log('eDB_KT_ CAPTIVE_SPLASH_DEL ', data);
                return CB(data);
            }
        });
    }




    g_G.call_eDB_KT_CAPTIVE_SPLASH_NEW = () => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_NEW`;
        const body = {
            "ssid": g_G.current_ssid(),
            "company_id": g_G.current_company_id(),
            "network_id": g_G.current_network_id(),
            "name": " ",
            "desc": " ",
            "page_type": "default",
            "page_order_list": "logo,title,notice,agree,survey,login,image",
            "theme_image_id": -1,
            "theme_top_image_id": -1,
            "theme_bg_color": "#ffffff",
            "logo_image_id": 1, // 1 ~ 3 은 기본 이미지를 보여줌.
            "banner_image_id": -1,
            "titleBig": " ",
            "title": " ",
            "survey_sheet_id": "-1",
            "login_type": "click-through", // 'click-through' => 그냥 로긴,  'passwd' => 암호 입력 로긴, 'qr' , 'meraki'=> meraki cloud login
            "reg_user_id": 9999
        };

        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            data: JSON.stringify(body),
            success: function(data) {
                console.log('call_eDB_KT_CAPTIVE_SPLASH_NEW ', data);
                if (typeof data == 'string') {
                    data = JSON.parse(data);
                }
                if (data.error) {
                    alert('error: 23434 :' + data.error.toString);
                    return;
                }
                const splash_page_info = data.result;
                g_G.eDB_KT_CAPTIVE_SPLASH_LIST.push(splash_page_info);
                const html = g_G.html.get_splash_list_row(splash_page_info, -1);
                $('#splash_table_body').append(html);
            }
        });

    }

    g_G.call_eDB_KT_CAPTIVE_SPLASH_SEARCH = () => {
        const search_text = $("#search_text").val();
        console.log('search_text = ', search_text);
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SPLASH_SEARCH`;
        const body = {
            "search_text": search_text,
            "company_id": g_G.current_company_id(),
            "network_id": g_G.current_network_id(),
            "ssid": g_G.current_ssid(),
        };


        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            data: JSON.stringify(body),
            success: function(data) {
                if (typeof data == 'string') {
                    data = JSON.parse(data);
                }
                console.log('eDB_KT_CAPTIVE_SPLASH_SEARCH ', data);
                if (data.error) {
                    alert('error: 45622 :' + data.error.toString());
                    return;
                }
                g_G.eDB_KT_CAPTIVE_SPLASH_LIST = data.result;
                let i = 0;
                $('#splash_table_body *').remove();
                if (g_G.eDB_KT_CAPTIVE_SPLASH_LIST.length < 10)
                    document.getElementById("sencod_new_button").style.display = "none";
                else
                    document.getElementById("sencod_new_button").style.display = "block";

                for (const splash_page_info of g_G.eDB_KT_CAPTIVE_SPLASH_LIST) {
                    const html = g_G.html.get_splash_list_row(splash_page_info, ++i % 2);
                    $('#splash_table_body').append(html);
                }
            }
        });

    }

    // 테마 미리보기

    g_G.updateAll_theme_bg_color = (splash_page_info) => {
        // g_G.log('updateAll_theme_bg_color');
        document.querySelectorAll(g_G.bg_target).forEach(function(p) {
            if (splash_page_info.theme_bg_color == null || splash_page_info.theme_bg_color == '') {
                splash_page_info.theme_bg_color = "#ffffff";
            }
            p.style.backgroundColor = splash_page_info.theme_bg_color;
        });
    }

    g_G.setup_preview_ui_theme_config = (splash_page_info) => {
            let url;
            if (splash_page_info.theme_image_id == -1) {
                url = `none`;
            } else {
                url = `${API_URL_HEADER}/eFILE_IMAGE_GET?pti_id=` + splash_page_info.theme_image_id;
            }

            let css;
            if (splash_page_info.theme_top_image_id == 0) {
                css = `url('/static/assets/splash_editor/free/images/top_bg.png'), url('${url}')`;
            } else if (splash_page_info.theme_top_image_id > 0) {
                const top_url = `${API_URL_HEADER}/eFILE_IMAGE_GET?pti_id=` + splash_page_info.theme_top_image_id;
                css = `url('${top_url}'), url('${url}')`;
            } else {
                if (splash_page_info.theme_image_id == -1) {
                    css = `none`;
                } else {
                    css = `url('${url}')`;
                }
            }
            $('#wrap').css({ "background-image": css });
            g_G.log('g_G.setup_previe w_ui_theme_config = ', url, ' css = ', css);


            g_G.updateAll_theme_bg_color(splash_page_info);
        }
        /*

        background-image: url(/static/assets/splash_editor/img/theme1.png);

        */

    g_G.call_eDB_KT_CAPTIVE_AGREE_INFO_DEL = (ap_id, CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_AGREE_INFO_DEL`;
        const body = {
            "ap_id": ap_id,
        };

        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            data: JSON.stringify(body),
            success: function(data) {
                if (typeof data == 'string') {
                    data = JSON.parse(data);
                }
                console.log('eDB_KT_ eDB_KT_CAPTIVE_AGREE_INFO_DEL ', data);
                CB(data);
            }
        });

    }
    g_G.call_eDB_KT_CAPTIVE_AGREE_INFO_NEW = (CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_AGREE_INFO_NEW`;
        const body = {
            "company_id": g_G.splash_page_info.company_id,
            "network_id": g_G.splash_page_info.network_id,
            "ssid": g_G.splash_page_info.ssid,
            "spi_id": g_G.splash_page_info.spi_id,
            "name": "내용을 입력하세요.",
            "contents": "<h5>내용 ... </h5>"
        }

        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            data: JSON.stringify(body),
            success: function(data) {
                if (typeof data == 'string') {
                    data = JSON.parse(data);
                }
                console.log('eDB_KT_ eDB_KT_CAPTIVE_AGREE_INFO_NEW ', data);
                CB(data);
            }
        });

    }
    g_G.call_eDB_KT_CAPTIVE_AGREE_INFO_UPDATE = (agreement_page, CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_AGREE_INFO_UPDATE`;
        const body = agreement_page;

        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            data: JSON.stringify(body),
            success: function(data) {
                if (typeof data == 'string') {
                    data = JSON.parse(data);
                }
                console.log('eDB_KT_CAPTIVE _AGREE_INFO_UPDATE ', data);
                CB(data);
            }
        });

    }

    g_G.call_eDB_KT_CAPTIVE_SURVEY_LIST = (spi_id, CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SURVEY_LIST?spi_id=${spi_id}`;
        g_G.logLoy('======= eDB_KT_CAP TIVE_SURVEY_LIST  url= ', url);
        var jqxhr = $.get(url, (data) => {
            if (typeof data == 'string') {
                data = JSON.parse(data);
            }
            g_G.logLoy('data = ', data);
            CB(data);
        });
    }


    g_G.call_eDB_KT_CAPTIVE_SURVEY_GET = (ss_id, CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SURVEY_GET?ss_id=${ss_id}`;
        g_G.logLoy('eDB_KT_C APTIVE_SURVEY_GET = ss_id', ss_id);
        var jqxhr = $.get(url, (data) => {
            if (typeof data == 'string') {
                data = JSON.parse(data);
            }
            g_G.logLoy('data = ', data);
            return CB(data);
        });
    }
    g_G.call_eDB_KT_CAPTIVE_SURVEY_DEL = (ss_id, CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_SURVEY_DEL?ss_id=${ss_id}`;
        $.post(url, {
            ss_id: ss_id,
        }, (data) => {
            return CB(data);
        });
        return CB(null);
    }

    g_G.call_eDB_KT_CAPTIVE_LOGIN = (loginData, CB) => {
        const url = `${API_URL_HEADER}/eDB_KT_CAPTIVE_LOGIN`;
        if (loginData.qr_scan_code) {
            //loginData.qr_scan_code = sha1(loginData.qr_scan_code);
            loginData.qr_scan_code = g_G.encryptRSA_Message(loginData.qr_scan_code, g_G.pubKey_RSA);
        }
        const body = loginData;
        //console.log('call_eDB_KT_CA PTIVE_LOGIN body=', body);

        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            data: JSON.stringify(body),
            success: function(data) {
                if (typeof data == 'string') {
                    data = JSON.parse(data);
                }
                g_G.log('eDB_KT_CA PTIVE_LOGIN ', data);
                CB(data);
            },
            error: function(error) {
                g_G.showAlert('안내 : 인증오류');

            }
        });

    }

});

function goto_splash_editor_page(btnEdit) {
    const tr = $(btnEdit).closest("tr");
    const spi_id = tr.find('#spi_id').text();
    const url = `/static/assets/splash_editor/page/editor/index.html?spi_id=${encodeURIComponent(spi_id)}`;
    //g_G.logLoy(url);
    window.location.href = url;

}