Rails.application.routes.draw do
  resources :answers
  resources :questions
  resources :lessons
  ##Static Page Routes
  root   'static_pages#home'
  #get    '/about',    to: 'static_pages#about'
  #get    '/faq',   to: 'static_pages#faq'
  #get    '/contact', to: 'static_pages#contact'
  ###Game Control Routes
  #get    '/login',   to: 'answering#new'
  post   '/submit',   to: 'answering#submit'
  post   '/start_lesson', to: 'answering#start_lesson'
  get    '/find_question', to: 'answering#find_question'
  get    '/superatum', to: 'answering#victory_screen', as: :victory_screen
  #delete '/logout',  to: 'answering#destroy'

  ###Admin User Controls 
  get     '/profile/:id', to: 'users#profile', as: :profile
  get     '/profile/:id/edit', to: 'users#edit_profile', as: :edit_profile
  post     '/profile/:id', to: 'users#update_profile', as: :update_profile
  get     '/profile_index', to: 'users#profile_index', as: :profile_index
  
  ###Feedback Form
  get     'feedback', to: 'feedback_msgs#new', as: :new_feedback_msg
  post    'feedback', to: 'feedback_msgs#create', as: :create_feedback_msg
  ###Users
  devise_for :users, :controllers => { :registrations => "registrations" } 
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'register', to: 'devise/registrations#new'
    delete '/logout', to: 'devise/sessions#destroy'
    #get 'confirmation.:id', to: 'devise/confirmations#show'
    #post 'confirmation.:user', to: 'devise/confirmations#new'
    #post 'confirmation', to: 'devise/confirmations#new'
  end
  resources :users, only: [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
