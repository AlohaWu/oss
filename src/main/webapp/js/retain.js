var retainChart = echarts.init(document.getElementById('newPlayers-retain-chart'));

$(function(){
    initTimeSelector();
    loadData();
});

function loadData() {

    $.post("/oss/api/players/retain", {
        icon:getIcons(),
        startDate:$("input#startDate").attr("value"),
        endDate:validateDate($("input#endDate").attr("value"))
    },
    function(data, status) {
        showPlayerNote(data);
        configChart(data);
        configTable(data);
    });
}

function configChart(data) {
    var recData = data.data;
    retainChart.clear();
    retainChart.setOption({
        tooltip: {
            trigger: 'axis',
            formatter:function(params) {  
               var relVal = params[0].name;  
               for (var i = 0, l = params.length; i < l; i++) {  
                    relVal += '<br/>' + params[i].seriesName + ' : ' + params[i].value+"%";  
                }  
               return relVal;  
            } 
        },
        legend: {
            data: data.type
        },
        toolbox: {
            show: true,
            feature: {
                dataZoom: {
                    yAxisIndex: 'none'
                },
                dataView: {
                    readOnly: false
                },
                magicType: {
                    type: ['line', 'bar']
                },
                restore: {},
                saveAsImage: {}
            }
        },
        dataZoom: [{
            type: 'slider',
            start: 0,
            end: 100
        },
        {
            type: 'inside',
            start: 10,
            end: 50
        }],
        xAxis: {
            type: 'category',
            data: function() {
                for (var key in data.category) {
                    return data.category[key];
                }
            } ()
        },
        yAxis: {
            type: 'value',
            axisLabel: {
                formatter: '{value} %'
            }
        },
        series: function() {
            var serie = [];
            for (var key in recData) {
                var item = {
                    name: key,
                    type: "line",
                    data: recData[key]
                }
                serie.push(item);
            };
            return serie;
        } ()

    });
}

function configTable(data) {
    appendTableHeader(data);
    var tableData = dealTableData(data);
    $('#data-table-newPlayers-retain').dataTable({
        destroy: true,
        // retrive:true,
        "data": tableData,
        "dom": '<"top"f>rt<"left"lip>',
        'language': {
            'emptyTable': '没有数据',
            'loadingRecords': '加载中...',
            'processing': '查询中...',
            'search': '查询:',
            'lengthMenu': '每页显示 _MENU_ 条记录',
            'zeroRecords': '没有数据',
            "sInfo": "(共 _TOTAL_ 条记录)",
            'infoEmpty': '没有数据',
            'infoFiltered': '(过滤总件数 _MAX_ 条)'
        }
    });
}
//处理表格对应的列数据
function dealTableData(data) {
    var type = data.type;
    var categories;
    var addPlayers;
    var activeDevice;
    var addDevice;

    for (var key in data.category) {
        categories = data.category[key];
    }
    for (var key in data.addPlayer){
        addPlayers = data.addPlayer[key];
    }
    for (var key in data.activeDevice){
        activeDevice = data.activeDevice[key];
    }
    for(var key in data.addDevice){
        addDevice = data.addDevice[key];
    }
    var serie = data.data;
    var dataArray = [];

    for (var i = 0; i < categories.length; i++) {
        var item = [];
        item.push(categories[i]);
        item.push(addPlayers[i]);
        item.push(activeDevice[i]);
        item.push(addDevice[i]);
        for (var j = 0; j < type.length; j++) {
            item.push(serie[type[j]][i] + '%');
        }
        dataArray.push(item);
    }
    return dataArray;
}

function showPlayerNote(data){
    var nDRRateAvg = data.nDRRateAvg;
    var sDRRateAvg = data.sDRRateAvg;
    var mRRateAvg = data.mRRateAvg;
    $("#nR").text(nDRRateAvg + '%');
    $("#sR").text(sDRRateAvg + '%');
    $("#mR").text(mRRateAvg + '%');
}
//处理表格对应的 头列
function appendTableHeader(data) {
    var type = data.type;
    var category = data.category;
    var addPlayer = data.addPlayer;
    var activeDevice = data.activeDevice;
    var addDevice = data.addDevice;
    var txt = "";
    //表头 时间
    for (var key in category) {
        txt = "<th><span>" + key + "</span></th>";
    }
    //表头 新增玩家
    for (var key in addPlayer) {
        txt = txt + "<th><span>" + key + "</span></th>";
    }
    //表头 激活设备
    for (var key in activeDevice) {
        txt = txt + "<th><span>" + key + "</span></th>";
    }
    //表头 新增设备
    for (var key in addDevice) {
        txt = txt + "<th><span>" + key + "</span></th>";
    }
    //表头 留存
    for (var i = 0; i < type.length; i++) {
        txt = txt + "<th><span>" + type[i] + "</span></th>"
    }
    if ($("table#data-table-newPlayers-retain > thead").length != 0) {
        $("table#data-table-newPlayers-retain > thead").remove();
        $("#data-table-newPlayers-retain").prepend("<thead><tr>" + txt + "</tr></thead>");
        // var spans = $("table#effective-table > thead").find("span");
        // for(var i=1;i<spans.length;i++){
        //     $(spans[i]).text(type[i]);
        // }
        return;

    }
    $("#data-table-newPlayers-retain").append("<thead><tr>" + txt + "</tr></thead>");
}

//默认选择前七天,在留存统计中 选择前14天
function initTimeSelector(){
       var startDate = getFormatDate(13);
       var endDate = getFormatDate(0);
       $("#startDate").attr('value',startDate);
       $('#date_seletor').text(startDate + ' 至 ' + endDate);
}

//留存统计只对前两天有效,因此需要判断日期去除当前日期和昨天日期
function validateDate(date) {
    var today = getFormatDate(0);
    var yesterday = getFormatDate(1);
    if(date==today || yesterday==date) {
        date=getFormatDate(2);
        var startDate = $("#startDate").attr("value");
        $("#endDate").attr("value",date);
        $('#date_seletor').text(startDate + ' 至 ' + date);
    }
    return date;
}

$("div.nav-tab.retain-tab > ul > li > a").click(function(){
    var href = $(this).attr("href");
    $(this).attr("href",href + "?icon=" + getIcons());
});