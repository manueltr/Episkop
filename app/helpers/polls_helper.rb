module PollsHelper

    def show_poll_icons(poll)
        icons = ''
        if poll.is_closed?
            icons += '<i class="fa-solid fa-lock"></i>'
        end
        if poll.is_anonymous?
            icons += '<i class="fa-solid fa-user-ninja"></i>'
        end
        if poll.results_closed?
            icons += '<i class="fa-solid fa-eye-slash"></i>'
        end
        puts(icons)
        return raw(icons)
    end
end
