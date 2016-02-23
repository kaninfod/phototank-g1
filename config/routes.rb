Rails.application.routes.draw do

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  root to: 'albums#index'

  get 'albums/select' => 'albums/select'
  post 'albums/select' => 'albums/select'

  resources :albums, :concerns => :paginatable
  get 'albums/:id/grid' => 'albums#grid'


  match '/photos/search' => 'photos#search', via: [:get, :post]
  resources :photos, :except => [:index], :concerns => :paginatable
  get '/photos/:id/display' => 'photos#display'
  get '/photos/:id/image/:size' => 'photos#image'



  get '/catalogs/:id/get_catalog' => 'catalogs#get_catalog'
  match "/catalogs/:id/manage" => "catalogs#manage", via: [:get, :post]
  get "/catalogs/:id/destroy" => "catalogs#destroy"
  #get '/catalogs/:id/manage' => 'catalogs#manage'
  resources :catalogs, :concerns => :paginatable
  #resources :catalogdropboxes, controller: 'catalogs', type: 'DropboxCatalog', :concerns => :paginatable
  resources :localcatalogs, controller: 'catalogs', type: 'LocalCatalog', :concerns => :paginatable

  match '/catalogs/:id/import' => 'catalogs#import', via: [:get, :post]
  get '/catalogs/:id/import_to_master' => 'catalogs#import_to_master'
  get '/catalogs/:id/import_to_slave' => 'catalogs#import_to_slave'

  post '/catalogs/:id/bucket' => 'catalogs#bucket'


  get '/locations/lookup'
  resources :locations, :concerns => :paginatable
  get '/locations/:id/view' => 'locations#view'


  post 'bucket/:id/add' => 'bucket#add'
  post 'bucket/:id/remove' => 'bucket#remove'
  get  'bucket' => 'bucket#index'
  get  'bucket/clear' => 'bucket#clear'
  get  'bucket/count' => 'bucket#count'
  get  'bucket/save' => 'bucket#save_to_album'
  get  'bucket/delete_photos' => 'bucket#delete_photos'

  get 'doubles/find'
  get 'doubles/index'
  get 'doubles/:doubles_id/delete/:photo_id' => 'doubles#delete'

  get 'administration/generate_albums'
  get 'administration/jobs_pending'

  get 'synchronizers/dropbox'


  require 'resque/server'

  mount Resque::Server.new, at: "/jobs"


end
