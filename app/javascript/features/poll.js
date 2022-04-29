const axios = require('axios').default;
axios.defaults.withCredentials = true;

$(document).on('turbo:load', function() {

    // main view navigation
    $("#sub_nav").on("click", ".nav-item", function (e) {
        $("#sub_nav .active").removeClass("active");
        $("a", this).addClass('active');
        $(this).css("border-color: black");
    })

    

    //poll deletion with possible confirmation
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

    //poll deletion after confirmation
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

});