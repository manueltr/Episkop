Rails.application.routes.draw do
  resources :api_keys
  
  resources :poll_answers

  resources :polls, shallow: true do
    resources :poll_questions
  end
  
  resources :directories, only: [:show, :create]
   
  # email invitations
  get '/pollsinvite/sendinvite', to: 'polls#send_email_invite', as: 'send_email_invite'

  #Authentication
  get '/homepage', to: 'application#account', as: 'logged_in'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#omniauth'

  #Directory
  get '/application/directory', to: 'application#directory', as: 'directory_home'

  #FormVoting
  get '/polls/:invite_token/form', to: 'polls#form', as: 'form'
  get '/polls/:invite_token/results', to: 'polls#results', as: 'results'
  post '/polls/:invite_token/submit', to: 'poll_votes#submit', as: 'poll_submit'
  get '/polls/:invite_token/qr_code', to: 'poll_votes#qr', as: 'form_qr'
  
  #PollQuestionResults
  get '/poll_questions/:id/results', to: 'poll_questions#results', as: 'poll_question_results'

  #PollGraphs
  post '/poll_graphs/:id', to: 'poll_graphs#create', as: 'graphs_create'


  # API routes
  get '/polls_api', to: 'api#index', as: 'polls_api_index'
  get '/polls_api_simple', to: 'api#index_non_db', as: 'polls_api_non_db'

  get '/settings', to: 'application#settings', as: 'settings'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'application#welcome'
  # Defines the root path route ("/")
  #root "articles#index"



  
end
