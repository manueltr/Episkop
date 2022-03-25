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
$(document).on('turbo:load', function() {

    $("body").on("dblclick", function (e) {
        console.log("why not");

    });

    $("#directory").on("mousedown", ".poll", function(e) {
        if(e.detail > 1) {
            e.preventDefault();
            // of course, you still do not know what you prevent here...
            // You could also check event.ctrlKey/event.shiftKey/event.altKey
            // to not prevent something useful.
        }
    });

    $("#directory").on("dblclick", ".poll", function (e) {
        
        let url = "/polls/" + $(this).attr('id').split("_")[1];
        window.location.href = url;

    });


    // directory functionality

    $('#directories').on('contextmenu', function(e) {
        var top = e.pageY - 10;
        var left = e.pageX + 25;
        $("#directory-context-menu").css({
          display: "block",
          top: top,
          left: left
        }).addClass("show");
        return false; //blocks default Webbrowser right click menu
      }).on("click", function() {
        $("#directory-context-menu").removeClass("show").hide();
      });
      
      $("#directory-context-menu a").on("click", function() {
        $(this).parent().removeClass("show").hide();
    });

    $('#directory').on('click', function(e) {
        $("#directory-context-menu").removeClass("show").hide();
    });


    $("#directory").on("mousedown", ".directory", function(e) {
        if(e.detail > 1) {
            e.preventDefault();
            // of course, you still do not know what you prevent here...
            // You could also check event.ctrlKey/event.shiftKey/event.altKey
            // to not prevent something useful.
        }
    });

    $("#directory").on("dblclick", ".directory", function (e) {
        
        let id = $(this).attr('id').split("_")[1];
        $.ajax({
            type: "GET",
            url: "/directories/" + id + ".js"
        })
    });

    // create new directory
    $("#directory").on('keyup', '#directory_name', function (e) {
        if (e.key == "Enter") {

            let d_name = $("#directory_name").val()

            $.ajax({
                type: "POST",
                url: "/directories.js",
                data: {directory: {name: d_name}}
            })
        }
        if(e.key == "Escape") {
            $("#directory_temp").remove()
        }
    });

    $("#directory").on('click', "#remove_new_directory", function(e) {
        $("#directory_temp").remove()
    });

    $("#directory").on('click', "#new_directory_link", function(e) {

        if(!$("#directory_temp").length) {
            
            $("#directories").prepend(`
            <div class="row" id="directory_temp">
                <div class="col">
                    <i class="fa-solid fa-folder" aria-hidden="true" style="display: inline;"></i>
                    <input class="form-control w-25" type="text" id="directory_name" style="display: inline;">
                    <i id="remove_new_directory" class="fa-solid fa-xmark" ></i>
                </div>
            </div>
            `);
        }
    });

});