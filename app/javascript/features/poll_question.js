// poll question create | add form handler
$(document).on('click', "#new_question_btn", function(e) {
    $(this).hide();
});


// poll question delete | delete poll question handler
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