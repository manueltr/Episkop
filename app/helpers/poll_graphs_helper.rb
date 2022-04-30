module PollGraphsHelper
    def delete_button(is_users)
        html = ''
        if is_users
            html += '<i data-delete="<%=graphs_delete_url(poll_graph.id)%>" class="graph-delete fa-solid fa-xmark"></i>'
        else
            html += '<i></i>'
        end
        return raw(html)
    end
end
