
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