// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./src/jquery"
import "./theme/typed"
import "./theme/jquery.singlePageNav.min"
import * as bootstrap from "bootstrap"
import "./theme/custom"
import "./utils/test"
import "./poll/main"
import "jquery-ujs"

const axios = require('axios').default;

// Directory features
$(document).on('turbo:load', function() {

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
    let dirName = $("#current_dir").text().trim();
    if(dirName == "Home") {
        $("#directory-back").hide();
    }


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




$(document).on('turbo:load', function() {
    // Poll question adding
    $(document).on('click', "#new_question_btn", function(e) {
        $(this).hide();
    });

    //Poll question deleting
    $(document).on('click', ".question-del", function(e){
        let que_id = $(this).attr("data-*");
        let quediv = `#poll_question_${que_id}`;
        $.ajax({
                type: "DELETE",
                url: `/poll_questions/${que_id}.json`,
                success: function(res){
                    $(quediv).remove();
                }
            });
    });

    //showpoll question editing
    $(document).on('click', ".question-edit-icon", function(e){
        let question_id = $(this).attr("data-*");

        if ($(`#question-title-show-${question_id}`).is(":visible")) {
            $(`#question-title-show-${question_id}`).hide();
            $(`#question-title-form-${question_id}`).show();            
        } 
        else {
            $(`#question-title-show-${question_id}`).show();
            $(`#question-title-form-${question_id}`).hide();
        }

        // $.ajax({
        //         type: "DELETE",
        //         url: `/poll_answers/${ans_id}.json`,
        //         success: function(res){
        //             $(answerdiv).remove();
        //         }
        // });
    });

    $(document).on('click', ".cancel-question-title", function(e) {
        let question_id = $(this).attr("data-*");
        let title = $(`#question-title-show-${question_id}`).find(".question-title-span").html();
        $(`#question-title-form-${question_id} input`).val(title);
        $(`#question-title-form-${question_id}`).hide()
        $(`#question-title-show-${question_id}`).show();      
    });

    $(document).on('click', '.update-question-title', function(e) {
        let question_id = $(this).attr("data-*");
        let old_question_title = $(`#question-title-show-${question_id}`).find(".question-title-span").html();
        let new_question_title = $(`#question-title-form-${question_id} input`).val();

         $.ajax({
            type: "PUT",
            url: `/poll_questions/${question_id}.json`,
            data: {poll_question: {content: new_question_title}},
            success: res => {
                $(`#question-title-show-${question_id}`).find(".question-title-span").html(new_question_title);  
                $(`#question-title-show-${question_id}`).show();
                $(`#question-title-form-${question_id} input`).val(new_question_title);  
                $(`#question-title-form-${question_id}`).hide();
            }
        })
        .fail(err => {
            console.log(err);
            $(`#question-title-form-${question_id}`).hide();
            $(`#question-title-show-${question_id}`).show();
        });

    });
});


$(document).on('turbo:load', function() {
    // Poll answer adding
    $(document).on('click',".new_answer_btn", function(e) {
            $(this).hide();
    });

    //Poll answer deleting
    $(document).on('click', ".delete_answer_icon", function(e){
        let ans_id = $(this).attr("data-*");
        let answerdiv = `#poll_answer_${ans_id}`;
        $.ajax({
                type: "DELETE",
                url: `/poll_answers/${ans_id}.json`,
                success: function(res){
                    $(answerdiv).remove();
                }
        });
    });

});


// API Key adding
$(document).on('turbo:load', function() {
    $(".new_key_btn").on('click', function(e) {
            $(this).hide();
    });


    $(document).on('click', "a.show_answers", function(e) {
        
        if($(this).children().first().hasClass('fa-minus')) {
            $(this).children().first().removeClass('fa-minus').addClass('fa-plus')
        }
        else {
            $(this).children().first().removeClass('fa-plus').addClass('fa-minus')
        }
    });

});