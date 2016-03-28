        Rails.application.routes.draw do

          devise_for :users

          concern :paginatable do
            get '(page/:page)', :action => :index, :on => :collection, :as => ''
          end



          match 'albums/select' => 'albums/select', via: [:get, :post]
          #get 'albums/show_stat' => 'albums#show_stat'
          resources :albums, :concerns => :paginatable


          #match "photos/(year/:year)/(month/:month)/(day/:day)/(country/:country)" => "photos#index", :via => [:post, :get]
          match "photos/(q/*query)" => "photos#index", :via => [:post, :get]
          resources :photos, :except => [:create, :index]
          get '/photos/:id/image/:size' => 'photos#image'
          get '/photos/:id/rotate/(:degrees)' => 'photos#rotate'
          #get '/photos/:id/display' => 'photos#display'

          resources :catalogs
          get '/catalogs/:id/dashboard' => 'catalogs#dashboard'
          get '/catalogs/:id/get_catalog' => 'catalogs#get_catalog'
          match "/catalogs/:id/edit" => "catalogs#edit", via: [:get, :post]
          get "/catalogs/:id/destroy" => "catalogs#destroy"
          get '/catalogs/authorize' => 'catalogs#authorize'
          get '/catalogs/authorize_callback' => 'catalogs#authorize_callback'
          match '/catalogs/:id/import' => 'catalogs#import', via: [:get, :post]

          get '/locations/lookup'
          resources :locations, :concerns => :paginatable
          get '/locations/:id/view' => 'locations#view'


          post 'bucket/:id/add' => 'bucket#add'
          post 'bucket/:id/remove' => 'bucket#remove'
          get  'bucket/list' => 'bucket#list'
          get  'bucket' => 'bucket#index'
          get  'bucket/clear' => 'bucket#clear'
          get  'bucket/count' => 'bucket#count'
          get  'bucket/save' => 'bucket#save_to_album'
          get  'bucket/delete_photos' => 'bucket#delete_photos'
          get '/bucket/rotate/(:degrees)' => 'bucket#rotate'
          get  'bucket/edit' => 'bucket#edit'
          patch  'bucket/update' => 'bucket#update'

          get 'doubles/find'
          get 'doubles/index'
          get 'doubles/:doubles_id/delete/:photo_id' => 'doubles#delete'

          get 'administration/generate_albums'
          get 'administration/jobs_pending'
          get 'administration/list_jobs'

          post 'jobs/list' => 'jobs#list'
          resources :jobs

          require 'resque/server'
          mount Resque::Server.new, at: "/resque"


          root to: 'photos#index'

        end
