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




$(document).on('turbo:load', function() {
    // main view navigation
    $("#sub_nav").on("click", ".nav-item", function (e) {
        $("#sub_nav .active").removeClass("active");
        $("a", this).addClass('active');
        $(this).css("border-color: black");
    });
});






$(document).on('turbo:load', function() {

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