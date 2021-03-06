$(function(){
  withoutIcon();
  loadData();
})

function loadData(){
  var accountName = $("#account-id").val();
  if(accountName != null && accountName.toString().length>1){
      loadAccDetail(accountName);
  }else{
      //初始化表头
      configTable(null);
  }
}

function loadAccDetail(accountName){
  $.post("/oss/api/players/accdetail", {
    accountId:accountName
  },
  function(data, status) {
    if(data.code==1){
      $("#account-not-exist").css("display", "block");
      setTimeout('$("#account-not-exist").css("display", "none")', 5000);
      configTable(null);
      return;   
    }
    configTable(data)
  });
}

$("#btn-query").click(function(){
    var accountName = $("#account-id").val();
    if(accountName==null||accountName==""){
        alert("输入不能为空");
        return;
    }
    loadAccDetail(accountName);
});

function configTable(data) {
    $('#data-table-detail-first').dataTable().fnClearTable();
    $('#data-table-detail-second').dataTable().fnClearTable();
    $("#data-table-detail-second > tbody > tr > td > span[title]").tooltip({"delay":0,"track":true,"fade":250});
    $('#data-table-detail-first').dataTable({
        "destroy": true,
        "data": data==null?null:data.device,
        "dom": '',
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
    $('#data-table-detail-second').dataTable({
        "destroy": true,
        "data": data==null?null:data.detail,
        "dom": '',
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
        },
        "columnDefs": [ {
           "targets": 2,
           "render": function ( data, type, full, meta ) {
                var weekday = getWeekdayFromDate(data);
                return '<span title='+weekday+'>'+data+'</span>';
            }
         },
         {
           "targets": 3,
           "render": function ( data, type, full, meta ) {
                var weekday = getWeekdayFromDate(data);
                return '<span title='+weekday+'>'+data+'</span>';
            }
         }]
    });
}
//锁死图标选择下拉菜单 清除按钮
$("button.btn.btn-default.btn-circle").attr('disabled',"true");
$("ul.dropdown-menu.iconBar > li").addClass("disabled");
$("li.btn-icons").unbind("click");
$('input').iCheck('disable');
$("li.disabled > button.btn.btn-primary").attr('disabled',"true");