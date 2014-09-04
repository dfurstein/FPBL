// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(
	function() {
		$("[id*='boxscore-modal']").click(
			function(event) {
				$.get('/boxscores/' + event.target.id.substring('boxscore-modal'.length) + '.php', function(data) {
					$(event.target).parent().find('p').html('<pre>' + $(data).text().trim() + '</pre>');
				}, 'text');
		});

    $("#hitting-stats").tablesorter({
      theme: "bootstrap",
      widthFixed: true,
      sortList: [[13,1],[0,0]]
    });

    $("#pitching-stats").tablesorter({
      theme: "bootstrap",
      widthFixed: true,
      sortList: [[15,0],[0,0]]
    }); 
  } 
); 
