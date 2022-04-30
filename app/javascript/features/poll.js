
// poll delete | with modal confirmation if server responds with warning
$(document).on('click', "#delete-poll-btn", function (e) {
    let poll_id = $(e.target).attr("data-poll");
    let redirect_url = $(e.target).attr("data-url")

    $.ajax({
        type: "DELETE",
        url: `/polls/${poll_id}.json`,
        error: (err) => {
            console.log(err);
        },
        success: (res) => {
            if(res.type === "warning") {
                //show confirmation modal
                $("#settings_confirm_delete").modal("show");    
            } 
            else {
                window.location = redirect_url;
            }
        }
    });
});

// poll deletion | after confirmation modal confirmation
$(document).on('click', "#delete-poll-btn-confirm", function (e) {
    let poll_id = $(e.target).attr("data-poll");
    let redirect_url = $(e.target).attr("data-url")

    $.ajax({
        type: "DELETE",
        url: `/polls/${poll_id}.json?delete=true`,
        error: (err) => {
            console.log(err);
        },
        success: (res) => {
            console.log(res);
            window.location = redirect_url;
        }
    });
});


/*  ---------------------  */


// poll navigation | participation poll click
$(document).on('click','.participated-poll-row', function (e) {
    let url = "/polls/" + $(this).attr('data-token') + "/main";
    window.location.href = url;
});


/*  ---------------------  */


// poll edit | show poll question title editing
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
});

// poll edit | cancel question title editing by cancel button
$(document).on('click', ".cancel-question-title", function(e) {
    let question_id = $(this).attr("data-*");
    let title = $(`#question-title-show-${question_id}`).find(".question-title-span").html();
    $(`#question-title-form-${question_id} input`).val(title);
    $(`#question-title-form-${question_id}`).hide()
    $(`#question-title-show-${question_id}`).show();      
});

// poll edit | handler for edit question title submission
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