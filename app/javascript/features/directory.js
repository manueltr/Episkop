
$(document).on('turbo:load', function() {


    // Dashboard | Hide directory back button if on root directory
    let dirName = $("#current_dir").text().trim();
    if(dirName == "Home") {
        $("#directory-back").hide();
    }
    
    // Dashboard | route user to poll
    $("#directory").on("dblclick", ".poll", function (e) {
        
        let url = "/polls/" + $(this).attr('id').split("_")[1] + "/main";
        window.location.href = url;

    });


    /*  ---------------------  */


    /* Directory contextmenu  */
    // show context menu and set ids
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
    });

    // hide context menu on body click
    $('body').on("click", function() {
        $("#directory-context-menu").removeClass("show").hide();
    });

    // directory delete | delete directory after modal confirmation
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
      
    // directory delete |  with modal confirmation if server responds with a warning
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

    // directory rename | insert input field
    $("#directory-rename").on('click', (e) => {
        e.preventDefault();

        if(!$("#directory-rename-form").length) {
            let directory_id = $("#directory-rename").attr("data-id")
            let directory_name = $("#directory-rename").attr("data-name")

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

    // directory rename | key press handlers
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

    // directory rename | cancel icon handler
    $("#directory").on('click', "#remove_new_directory", function(e) {

        let directory_id = $(e.target).attr("data-id");
        $("#directory-rename-form").remove();
        $(`#directory_${directory_id}`).find('.col').show();
    });


    /*  ---------------------  */


    // directory navigation | prevent text from being highlighted
    $("#directory").on("mousedown", ".directory", function(e) {
        if(e.detail > 1) {
            e.preventDefault();
        }
    });

    // directory navigation  | display directory that was clicked on
    $("#directory").on("dblclick", ".directory", function (e) {
        
        let id = $(this).attr('id').split("_")[1];
        $.ajax({
            type: "GET",
            url: "/directories/" + id + ".js"
        })
    });


    /*  ---------------------  */


    // directory create | prevent multiple directory input field from being created
    $("#directory").on("mousedown", ".poll", function(e) {
        if(e.detail > 1) {
            e.preventDefault();
            // of course, you still do not know what you prevent here...
            // You could also check event.ctrlKey/event.shiftKey/event.altKey
            // to not prevent something useful.
        }
    });

    // directory create | key press handlers
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

    // directory create | remove input handler
    $("#directory").on('click', "#remove_new_directory", function(e) {
        $("#directory_temp").remove()
    });

    // directory create | create input handler
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


    /*  ---------------------  */


    // Directory drag and drop functionality
    $("#directory").on('dragstart', ".poll", function(e) {
        console.log("started dragging");
        $(this).addClass('dragging');
    });

    $("#directory").on('dragend', ".poll", function(e) {
        console.log("ended dragging");
        $(this).removeClass('dragging');
    });


    $("#directory").on('dragstart', ".directory", function(e) {
        console.log("started dragging");
        $(this).addClass('dragging');
    });

    $("#directory").on('dragend', ".directory", function(e) {
        console.log("ended dragging");
        $(this).removeClass('dragging');
    });

    // $("#directory").on('dragenter', ".directory", function(e) {
    //     if(!$(this).hasClass('dragging')) {
    //         this.style.background = "#a1cde6";
    //     }
    // });

    // $("#directory").on('dragleave', ".directory", function(e) {
    //     if(!$(this).hasClass('dragging') && $(this).hasClass("directory")) {
    //         this.style.background = "";
    //     }
    // });


    $("#directory").on('dragover', ".directory", function(e) {
        e.preventDefault();
    })

    $("#directory").on('drop', ".directory", function(e) {
        this.style.background = "";
        
        if($(".dragging").attr("data-id") != $(this).attr("data-id")) {
            if($(".dragging").hasClass("poll")) {
                let poll_token = $(".dragging").attr("id").split("_")[1];
                console.log(poll_token);
                let directory_id = $(this).attr("data-id");
                console.log(directory_id);

                let poll = $(".dragging")

                $.ajax({
                    type: "PUT",
                    url: `/directory/drop_poll.json?directory_id=${directory_id}&poll_token=${poll_token}`,
                    error: (err) => {
                        console.log(err);
                    },
                    success: (res) => {
                        poll.remove();
                    }
                });
            }
            else {

                let drop_id = $(".dragging").attr("data-id");
                let directory = $(".dragging");

                $.ajax({
                    type: "PUT",
                    url: `/directory/drop_directory.json?directory_id=${$(this).attr("data-id")}&drop_id=${drop_id}`,
                    error: (err) => {
                        console.log(err);
                    },
                    success: (res) => {
                        directory.remove();
                    }
                });

            }
        }

    });

    $("#directory").on('dragover', "#directory-back", function(e) {
        e.preventDefault();
    })

    $("#directory").on('drop', "#directory-back", function(e) {
        

        if($(".dragging").hasClass("poll")) {
            let poll_token = $(".dragging").attr("id").split("_")[1];
            let poll = $(".dragging");

            $.ajax({
                type: "PUT",
                url: `/directory/drop_poll.json?directory_id=parent&poll_token=${poll_token}`,
                error: (err) => {
                    console.log(err);
                },
                success: (res) => {
                    poll.remove();
                }
            });
        }
        else {

            let drop_id = $(".dragging").attr("data-id");
            let directory = $(".dragging");

            $.ajax({
                type: "PUT",
                url: `/directory/drop_directory.json?directory_id=parent&drop_id=${drop_id}`,
                error: (err) => {
                    console.log(err);
                },
                success: (res) => {
                    directory.remove();
                }
            });
        }

    });

});