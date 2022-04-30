module PollsHelper

    def show_poll_icons(poll)
        icons = ''
        if poll.is_closed?
            icons += '<i class="fa-solid fa-lock"></i>'
        elsif !poll.resubmits
            icons += '<i class="fa-solid fa-lock"></i>'
        else
            icons += '<i class="fa-solid fa-unlock"></i>'
        end
        if poll.is_anonymous?
            icons += '<i class="fa-solid fa-user-ninja"></i>'
        end
        if poll.results_closed?
            icons += '<i class="fa-solid fa-eye-slash"></i>'
        else 
            icons += '<i class="fa-solid fa-square-poll-vertical"></i>'
        end
        puts(icons)
        return raw(icons)
    end

    def show_anonymous_icon(poll)
        icons = ''
        if poll.is_anonymous?
            icons += '<i class="fa-solid fa-user-ninja"></i><p>submission is anonymous</p>'
        end
        return raw(icons)
    end

    # def default_check_show_results(poll)
    #     if poll.show_results != nil && poll.show_results == false
    #         return false
    #     else
    #         return true
    #     end
    # end

end
