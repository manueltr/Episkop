$(document).on('turbo:load', function() {


    $("#sub_nav").on("click", ".nav-item", function (e) {
        $("#sub_nav .active").removeClass("active");
        $("a", this).addClass('active');
    })




});