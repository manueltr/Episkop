Rails.application.routes.draw do

  root 'application#welcome'

  #API keys
  resources :api_keys

  #Poll answers
  resources :poll_answers

  #Polls 
  resources :polls, shallow: true do
    resources :poll_questions
  end
  get '/polls/:invite_token/settings', to: 'polls#settings', as: 'poll_settings'
  get '/polls/:invite_token/main', to: 'polls#main', as: 'poll_main_page'
  get '/polls/:invite_token/json', to: 'polls#write_json', as: 'poll_download_json'
  
  #Directories
  resources :directories, only: [:show, :create, :destroy, :update]
  put '/directory/drop_poll', to: 'directories#drop_poll'
  put '/directory/drop_directory', to: 'directories#drop_directory'
   
  #email invitations
  get '/pollsinvite/sendinvite', to: 'polls#send_email_invite', as: 'send_email_invite'

  #Authentication
  get '/homepage', to: 'application#account', as: 'logged_in'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#omniauth'

  #Directory
  get '/application/directory', to: 'application#directory', as: 'directory_home'
  get '/application/directory/back', to: 'application#directory_back', as: 'directory_back'

  #FormVoting
  get '/polls/:invite_token/form', to: 'polls#form', as: 'form'
  get '/polls/:invite_token/results', to: 'polls#results', as: 'results'
  post '/polls/:invite_token/submit', to: 'poll_votes#submit', as: 'poll_submit'
  get '/polls/:invite_token/qr_code', to: 'poll_votes#qr', as: 'form_qr'

  #PollQuestionResults
  get '/poll_questions/:id/results', to: 'poll_questions#results', as: 'poll_question_results'
  get '/poll_questions/:questions/:poll_id/yes_no/results', to: 'poll_questions#yesNo', as: 'yes_no_graph_results'

  #PollGraphs
  post '/poll_graphs/:id', to: 'poll_graphs#create', as: 'graphs_create'
  delete '/poll_graphs/:id', to: 'poll_graphs#destroy', as: 'graphs_delete'
  
  # API KEY routes
  get '/polls_api', to: 'api#index', as: 'polls_api_index'
  get '/polls_api_simple', to: 'api#index_non_db', as: 'polls_api_non_db'
  get '/settings', to: 'application#settings', as: 'settings'

  #Download JSON/CSV
  get '/poll_questions/:id/results/json', to: 'poll_questions#write_json', as: 'download_json_results'
  get '/poll_questions/:id/results/csv', to: 'poll_questions#write_csv', as: 'download_csv_results', defaults: {format: :csv}
  
end
