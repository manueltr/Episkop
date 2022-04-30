
// poll answer create | hide poll answer button to prevent more forms from being added
$(document).on('click',".new_answer_btn", function(e) {
    $(this).hide();
});

//poll answer delete | handle request to server
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

//poll answer show | collapse all poll answers in edit page view
$(document).on('click', "a.show_answers", function(e) {
        
    if($(this).children().first().hasClass('fa-minus')) {
        $(this).children().first().removeClass('fa-minus').addClass('fa-plus')
    }
    else {
        $(this).children().first().removeClass('fa-plus').addClass('fa-minus')
    }
});