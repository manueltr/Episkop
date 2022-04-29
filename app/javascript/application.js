// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./src/jquery"
import "./theme/typed"
import "./theme/jquery.singlePageNav.min"
import * as bootstrap from "bootstrap"
import "./theme/custom"
import "./features/poll"
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


    /* Directory contextmenu  */
    $("#directory").on('contextmenu', '.directory' , function(e) {
        var top = e.pageY - 10;
        var left = e.pageX + 15;
        $("#directory-context-menu").css({
          display: "block",
          top: top,
          left: left
        }).addClass("show");

        //set delete and rename a tags to have directory id
        let directory_id = $(this)[0].id.split("_")[1]
        let directory_name = $(e.target).find("strong").html();
        $("#directory-rename").attr("data-id", directory_id).attr("data-name", directory_name);;
        $("#directory-delete").attr("data-id", directory_id).attr("data-name", directory_name);
        $("#dashboard-delete-dir-btn-confirm").attr("data-id", directory_id);

        return false; //blocks default Webbrowser right click menu
    })

    $('body').on("click", function() {
        $("#directory-context-menu").removeClass("show").hide();
    });

    $("#dashboard-delete-dir-btn-confirm").on('click', (e) => {
        e.preventDefault();
        let directory_id = $("#dashboard-delete-dir-btn-confirm").attr("data-id");
        
        $.ajax({
            type: "DELETE",
            url: `/directories/${directory_id}.json?destroy=true`,
            error: (err) => {
                console.log(err);
            },
            success: (res) => {
                $(`#directory_${directory_id}`).remove();
            }
        });
    });
      

    $("#directory-delete").on('click', (e) => {

        e.preventDefault();
        let directory_id = $("#directory-delete").attr("data-id")
        
        $.ajax({
            type: "DELETE",
            url: `/directories/${directory_id}.json`,
            error: (err) => {
                console.log(err);
            },
            success: (res) => {
                console.log(res);
                if(res.type === "warning") {
                    //show confirmation modal
                    let directory_name = $("#directory-delete").attr("data-name")
                    $("#confirm_dir_name").html(directory_name);
                    $("#dashboard_confirm_directory_delete").modal("show");    
                } 
                else {
                    $(`#directory_${directory_id}`).remove();
                }
            }
        });

        $(this).parent().removeClass("show").hide();
    });

    $("#directory-rename").on('click', (e) => {
        e.preventDefault();

        if(!$("#directory-rename-form").length) {
            let directory_id = $("#directory-rename").attr("data-id")
            let directory_name = $("#directory-rename").attr("data-name")

            console.log(directory_id);
            $(`#directory_${directory_id}`).find('.col').hide()
            $(`#directory_${directory_id}`).append(
                `<div class="col" id="directory-rename-form" >
                    <i class="fa-solid fa-folder" aria-hidden="true" style="display: inline;"></i>
                        <input data-id="${directory_id}" value="${directory_name}" class="form-control w-25" type="text" id="directory_rename_input" style="line-height: 6px; display: inline;">
                    <i  data-id="${directory_id}" id="remove_new_directory" class="fa-solid fa-xmark" ></i>
                </div>`
            )  
        }
    });

    $("#directory").on('keyup', '#directory_rename_input', function (e) {

        let directory_id = $(e.target).attr("data-id");

        if (e.key == "Enter") {

            let name = $("#directory_rename_input").val()
            
            $.ajax({
                type: "PUT",
                url: `/directories/${directory_id}.json`,
                data: {directory: {name}},
                error: (err) => {
                    console.log(err);
                },
                success: (res) => {
                    if(res.type === "success") {
                        $(`#directory_${directory_id}`).find("strong").html(name);
                    }
                }
            });

            $("#directory-rename-form").remove();
            $(`#directory_${directory_id}`).find('.col').show();
        }
        if(e.key == "Escape") {
            $("#directory-rename-form").remove();
            $(`#directory_${directory_id}`).find('.col').show();
        }
    });

    $("#directory").on('click', "#remove_new_directory", function(e) {

        let directory_id = $(e.target).attr("data-id");
        $("#directory-rename-form").remove();
        $(`#directory_${directory_id}`).find('.col').show();
    });

    /*  ---------------------  */



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