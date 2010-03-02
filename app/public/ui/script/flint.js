$(document).ready(function() {
    // alert(document.documentElement.clientWidth);
  
    $('nav li').removeClass('active');
    var activeTab = $('#nav').attr('class');
    $('li.' + activeTab).addClass('active');
    
    // $('#toggle').live('mouseover', function(){$(this).css('cursor','pointer');});
    
    $("#toggle").live('click', function () {
        var myDetails = "#" + $(this).attr("name")
        // var myItem = "." +  $(this).attr("class");
        if ($(this).hasClass("expanded")) {
            $(this).removeClass("expanded");
            $(this).attr("src","/assets/toggle-expand.png")
            $(myDetails).hide();
        } else {
            $(this).attr("src","/assets/toggle.png")
            $(myDetails).show();
            $(this).addClass("expanded");
        }
    });

    light_up_clickable_test_results();
    light_up_hiddens();

    $(".dialog").dialog({autoOpen: false, width: 430});

    $(".new_report_button").click(function() {  $("#new_report_dialog").dialog('open'); });

    $("#upload_button").click(function() {
	$("#spinner").show(); 
        $('#upload_form').submit();
        return true;
     });
});

light_up_hiddens = function() { 
  $(".hidden").hide();
}

light_up_clickable_test_results = function (){
  
  $('a.test_result').click(function () {
      var id = $(this).attr('id');
      var target = this;
      $('*').removeClass("selected");
	    $(this).parent().addClass("selected");
      $.get('/test_result/' + id, function (data) {
	      $('.test_result_detail',
	      $(target).closest('.group_result')).html(data);
	});
    });

}
