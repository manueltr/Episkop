// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./src/jquery"
import "./theme/typed"
import "./theme/jquery.singlePageNav.min"
import * as bootstrap from "bootstrap"
import "./theme/custom"
import "jquery-ujs"

const axios = require('axios').default;
axios.defaults.withCredentials = true;

import "./features/poll"
import "./features/poll_question"
import "./features/directory"
import "./features/poll_answer"




$(document).on('turbo:load', function() {

    // main view navigation
    $("#sub_nav").on("click", ".nav-item", function (e) {
        $("#sub_nav .active").removeClass("active");
        $("a", this).addClass('active');
        $(this).css("border-color: black");
    });

    // API Key adding
    $(".new_key_btn").on('click', function(e) {
        $(this).hide();
    });
});