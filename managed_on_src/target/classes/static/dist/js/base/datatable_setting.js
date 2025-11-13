var DATATABLE_SETTING = {};

DATATABLE_SETTING.COLUMN = {};

DATATABLE_SETTING.COLUMN.SEQ = { 
    'data': 'seq',
    'className': 'dt-center',
    'orderable': false,
    render: function(data, type, row, meta) {
        return meta.row + meta.settings._iDisplayStart + 1;
    }
};

DATATABLE_SETTING.COLUMN.LINK = function(fieldName, url, keyFieldName, queryString, columnClass) { 
    if (! queryString)
        queryString = '';
    if (! columnClass)
        columnClass = 'dt-center';

    return {
        'data': fieldName,
        fnCreatedCell: function (nTd, sData, oData, iRow, iCol) {
            if (oData[fieldName]) {
                $(nTd).html('<a href="'+ url + oData[keyFieldName] + queryString +'">' + oData[fieldName] + '</a>');
            }
        },
        'class': columnClass,
    }
}

DATATABLE_SETTING.COLUMN.ARCUS_ASSET_STATUS = function(fieldName, url, keyFieldName, queryString, columnClass) { 
    return {
        data: fieldName,
        fnCreatedCell: function (nTd, sData, data, iRow, iCol) {
            let status = sData
            if ( status >= 2 )
                $(nTd).html('<div class="bullet badge-danger">')
            else if ( status >= 1 )
                $(nTd).html('<div class="bullet badge-warning">')
            else if ( status >= 0 )
                $(nTd).html('<div class="bullet badge-success">')
            else if ( status == -1 )
                $(nTd).html('<div class="bullet badge-secondary">')
            else 
                $(nTd).html('<div class="bullet badge-secondary">')
        },
        searchable: false,
        className: "dt-center"
    }
}

DATATABLE_SETTING.COLUMN.ARCUS_ALERT_STATUS = function(fieldName, url, keyFieldName, queryString, columnClass) { 
    return {
        data:   fieldName,
        render: function ( data, type, row ) {
            if ( data > 0 ) {
                if (! row.severity)
                    return '<span class="bullet badge-danger">'

                if (row.severity == 'critical')
                    return '<span class="bullet badge-danger">'
                else if (row.severity == 'warning')
                    return '<span class="bullet badge-warning">'
                else
                    return '<span class="bullet badge-secondary">'
            } else {
                return '<span class="bullet badge-success">'
            }
        },
        searchable: false,
        className: "dt-center"	
    }
}

DATATABLE_SETTING.COLUMN.ARCUS_ASSET_LINK = function(displayFieldName, assetIdFieldName, modelFieldName, columnClass) { 
    return { 
        'data': displayFieldName,
        fnCreatedCell: function (nTd, sData, oData, iRow, iCol) {
            var displayField = oData[displayFieldName]
            var assetId = oData[assetIdFieldName]
            var model = oData[modelFieldName]
            var deviceType = oData['deviceType']
            if (assetId) {
                if (model == null) {
                    $(nTd).html(displayField);
                    return;
                }

                if (model.startsWith('MR'))
                    $(nTd).html('<a href="/meraki_device/ap_detail_view/' + assetId + '">' + displayField + '</a>');
                else if (model.startsWith('MX'))
                    $(nTd).html('<a href="/meraki_device/appliance_detail_view/' + assetId + '">' + displayField + '</a>');
                else if (model.startsWith('MS'))
                    $(nTd).html('<a href="/meraki_device/switch_detail_view/' + assetId + '">' + displayField + '</a>');
                else
                    if (deviceType == 'Line')
                        $(nTd).html('<a href="/line_asset/detail_view_by_line_num/' + assetId + '">' + displayField + '</a>');
                    else
                        $(nTd).html(displayField);
            }
        },
        'className': 'dt-center'
    }
}

DATATABLE_SETTING.COLUMN.BUTTON = function(fieldName, label, url) { 
    return {
        'data': fieldName,
        render: function(data, type, row, meta) {
            return '<button onclick="location.href=\''+ url +'\'">'+ label +'</button>';
        }
    }
}

DATATABLE_SETTING.SEARCH_FUNC = function() {
    $('.dataTable').dataTable().fnFilter($('.dataTables_filter input').val());
	//$('.dataTable').dataTable().api().search($('.dataTables_filter input').val()).draw();
}

// by designer
function applyPostSettings() {
    $('.dataTables_filter input').attr('placeholder','Search...');

    // DOM Manipulation to move datatable elements integrate to panel
	$('.panel-ctrls').append($('.dataTables_filter').addClass("pull-right")).find("label").addClass("panel-ctrls-center");
	$('.panel-ctrls').append("<i class='separator'></i>");
	$('.panel-ctrls').append($('.dataTables_length').addClass("pull-left")).find("label").addClass("panel-ctrls-center");

	$('.panel-footer > .clearfix').append($(".dataTable+.row"));
	$('.dataTables_paginate>ul.pagination').addClass("m-n");
}

function setCommonSettings(setting, customSetting) {
    // i don't think this is working <- hjchoi 20190217
    if (customSetting.order != undefined)
        setting.order = customSetting.order;
    if (customSetting.pagingDef != undefined)
        setting.lengthMenu = customSetting.pagingDef;
    if (customSetting.paging != undefined)
        setting.paging = customSetting.paging;
    if (customSetting.searching != undefined)
        setting.searching = false;
    if (customSetting.createdRow != undefined)
        setting.createdRow = customSetting.createdRow;
    if (customSetting.columnDefs != undefined)
        setting.columnDefs = customSetting.columnDefs;
    if (customSetting.rowCallback != undefined)
        setting.rowCallback = customSetting.rowCallback;
}

DATATABLE_SETTING.ERROR_HANDLER = function (xhr, option, error) {
    // xhr.responseText = 'datatable error';
    showAjaxError(xhr, option, 'datatable error');
}

DATATABLE_SETTING.getLocal = function (customSetting) {
    var setting;
    if (customSetting.ajaxUrl) {
        setting = {
            order: [],
            ajax: {
                url: customSetting.ajaxUrl,
                dataSrc: '',
                error: DATATABLE_SETTING.ERROR_HANDLER
            },
            columns: customSetting.columnDef,
            initComplete: function(settings, json) {
                applyPostSettings();
            },
        };
    } else {
        setting = {
            data: customSetting.localData,
            columns: customSetting.columnDef
        };
    }
    setCommonSettings(setting, customSetting);

    return setting;
};

DATATABLE_SETTING.getServerSide = function (customSetting) {
    var setting = {
        processing: true,
        serverSide: true,
        ajax: {
            contentType: 'application/json',
            type: 'POST',
            url: customSetting.ajaxUrl,
            data: function (d) {
                var $searchField = $('#searchField');
                d.searchField = $searchField.val() ? $searchField.val() : '';
                d.searchKeyword = d.search['value'];
                d.orderField = d.order[0]['column'];
                d.orderDir = d.order[0]['dir'];
                // page custome search fields
                var customSearchFields = [];
                if (customSetting.customSearchFields) {
                    $.each(customSetting.customSearchFields, function (i, v) {
                        var value = v.value ? v.value : $(v.valueQuery).val()
                        if (v.applyFunc)
                            value = v.applyFunc(value);
                        customSearchFields.push({
                            name: v.name,
                            // value: v.value ? v.value : $(v.valueQuery).val()
                            value: value
                        });
                    })
                    d.customSearchFields = customSearchFields;
                }
                return JSON.stringify(d);
            },
            beforeSend: customSetting.preAjaxCallback,
            error: DATATABLE_SETTING.ERROR_HANDLER
        },
        columns: customSetting.columnDef,
        initComplete: function(settings, json) {
            var $searchInput = $('.dataTables_filter input');
            $searchInput.unbind();
            $searchInput.bind('keyup', function(e) {
                if (e.keyCode == 13) {
                    $('.dataTable').dataTable().api().search(this.value).draw();
                    // $('.dataTable').DataTable().search(this.value).draw();   // shows other way to access datatable api
                }
            });
            if (customSetting.searchFieldOptions) {
                var $selSearch = $('<select id="searchField" class="form-control" style="visibility: visible">');
                $selSearch.append('<option value=""></option>');
                for (var i in customSetting.searchFieldOptions) {
                    var option = customSetting.searchFieldOptions[i];
                    $selSearch.append('<option value="'+ option.value +'">'+ option.name +'</option>');
                }
                $selSearch.insertBefore($searchInput);
            }

            applyPostSettings();
        }
    };
    setCommonSettings(setting, customSetting);

    return setting;
}