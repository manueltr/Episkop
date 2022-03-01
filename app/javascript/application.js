// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./src/jquery"
import "./theme/typed"
import "./theme/jquery.singlePageNav.min"
import * as bootstrap from "bootstrap"
import "./theme/custom"
import "./utils/test"
import "jquery-ujs"

const axios = require('axios').default;

// Directory features
$(function() {

    $(".poll").on("mousedown", function(e) {
        if(e.detail > 1) {
            e.preventDefault();
            // of course, you still do not know what you prevent here...
            // You could also check event.ctrlKey/event.shiftKey/event.altKey
            // to not prevent something useful.
        }
    });

    $(".poll").on("dblclick", function (e) {
        
        let url = "/polls/" + $(this).attr('id').split("_")[1];
        window.location.href = url;
        
        // axios.get(url)
        //     .then((response) => {
        //         console.log(response);
        //      });
    });

});