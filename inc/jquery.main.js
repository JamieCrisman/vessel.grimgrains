$(document).ready(function() {

	$(document).on('keydown', 'input.search', function(e) {
	    if(e.which == 13) {
	    	window.location = "http://grimgrains.com/"+$("input.search").val();
	        return false;
	    }
	});

	responsiveResponse();

});

$(window).resize(function() {

	responsiveResponse();

});

$(window).load(function() {

	responsiveResponse();

});


$(window).scroll(function () {

});

// Mobile LOD
function responsiveResponse(){

	scrollPosition = $("body").scrollTop();

	if($("html").width() < 500){
		$("html").addClass("mobile");
		$("html").addClass("phone");
	}
	else if($("html").width() < 940){
		$("html").addClass("mobile");
		$("html").removeClass("phone");
	}
	else{
		$("html").removeClass("mobile");
		$("html").removeClass("phone");
	}

}
