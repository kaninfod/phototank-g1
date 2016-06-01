Rails.application.routes.draw do

  devise_for :users


  match 'albums/select' => 'albums/select', via: [:get, :post]
  resources :albums



  match "photos/(q/*query)" => "photos#index", :via => [:post, :get]
  resources :photos, :except => [:create, :index]
  get '/photos/:id/image/:size' => 'photos#image'
  get '/photos/:id/rotate/(:degrees)' => 'photos#rotate'


  get '/catalogs/migrate' => 'catalogs#migrate'
  get '/catalogs/authorize' => 'catalogs#authorize'
  put '/catalogs/authorize' => 'catalogs#authorize'
  get '/catalogs/authorize_callback' => 'catalogs#authorize_callback'
  resources :catalogs
  get '/catalogs/:id/dashboard' => 'catalogs#dashboard'
  get '/catalogs/:id/get_catalog' => 'catalogs#get_catalog'
  match "/catalogs/:id/edit" => "catalogs#edit", via: [:get, :post]
  get "/catalogs/:id/destroy" => "catalogs#destroy"
  match '/catalogs/:id/import' => 'catalogs#import', via: [:get, :post]

  get '/locations/create'
  get '/locations/new'
  get '/locations/lookup_address'
  get '/locations/lookup'
  get 'locations/new_from_coordinate_string' => 'locations#new_from_coordinate_string'
  get 'locations/typeahead/:query' => 'locations#typeahead'
  resources :locations
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

  resources :photofiles
  get 'photofiles/:id/photoserve' => 'photofiles#photoserve'
  patch 'photofiles/:id/rotate' => 'photofiles#rotate'
  get 'photofiles/:id/phash' => 'photofiles#phash'


  get 'administration/generate_albums'
  get 'administration/jobs_pending'
  get 'administration/list_jobs'

  post 'jobs/list' => 'jobs#list'
  resources :jobs

  require 'resque/server'
  mount Resque::Server.new, at: "/resque"


  root to: 'photos#index'

end
