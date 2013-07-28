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
//= require twitter/bootstrap
//= require_tree .

var cycle_last_var = null;
var cycle = function(var1, var2) {
	if (cycle_last_var == null || cycle_last_var == var2) {
		cycle_last_var = var1;
	}
	else {
		cycle_last_var = var2;
	}

	return cycle_last_var;
};

var cycle_reset = function() {
	cycle_last_var = null;
}

var draw_angel_wings = function(left_container, right_container, job_seeker_url_words, job_description_url_words, highest_count, max_graph_width) {

	var left_graph = '';
	var right_graph = '';
	
	for (var i = 0; i < job_seeker_url_words.length; i++) {
		var word = job_seeker_url_words[i][0];
		var word_count = job_seeker_url_words[i][1];
		var width = (word_count * max_graph_width) / highest_count;

		if (width > 0) {
			width = Math.max(width, 25);
		}

		left_graph += ' \
			<li> \
				<div> \
					<div class="word"> \
						<div class="word-container"> \
							' + word + ' \
						</div> \
					</div> \
					<div class="row-wrapper"> \
						<div class="graph ' + cycle('even', 'odd') + '" style="width: ' + width + 'px; "> \
							<div class="word-count"> \
								' + word_count + ' \
							</div> \
						</div> \
					</div> \
					<div style="clear: both;"></div> \
				</div> \
			</li> \
		';
	}

	cycle_reset();

	for (var i = 0; i < job_description_url_words.length; i++) {
		var word = job_description_url_words[i][0];
		var word_count = job_description_url_words[i][1];
		var width = (word_count * max_graph_width) / highest_count;
		
		if (width > 0) {
			width = Math.max(width, 25);
		}

		right_graph += ' \
			<li> \
				<div> \
					<div class="word"> \
						<div class="word-container"> \
							' + word + ' \
						</div> \
					</div> \
					<div class="graph ' + cycle('even', 'odd') + '" style="width: ' + width + 'px;"> \
						<div class="word-count"> \
							' + word_count + ' \
						</div> \
					</div> \
					<div style="clear: both;"></div> \
				</div> \
			</li> \
		';
	}

	left_container.delay(100).css('opacity', '0.0').html(left_graph).animate({'opacity': '1.0'}, 1000);
	right_container.delay(100).css('opacity', '0.0').html(right_graph).animate({'opacity': '1.0'}, 1000);
}