json.domain @domain

if @graph_type == "Yes no bar graph"
    json.data(@barResults) do |key, count|
        json.label key
        json.value count
    end
else 
    json.data(@results) do |user_id, position|
        json.label user_id
        json.value position
    end
end