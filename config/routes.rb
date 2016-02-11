Rails.application.routes.draw do

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  root to: 'albums#index'

  get 'albums/select' => 'albums/select'
  post 'albums/select' => 'albums/select'

  resources :albums, :concerns => :paginatable
  get 'albums/:id/grid' => 'albums#grid'


  resources :photos, :concerns => :paginatable
  get '/photos/:id/display' => 'photos#display'
  get '/photos/:id/image/:size' => 'photos#image'


  get '/catalogs/test' => 'catalogs#test'
  match "/catalogs/:id/manage" => "catalogs#manage", via: [:get, :post]
  #get '/catalogs/:id/manage' => 'catalogs#manage'
  resources :catalogs, :concerns => :paginatable
  resources :catalogdropboxes, controller: 'catalogs', type: 'DropboxCatalog', :concerns => :paginatable
  resources :cataloglocals, controller: 'catalogs', type: 'LocalCatalog', :concerns => :paginatable


  get '/catalogs/:id/import' => 'catalogs#import'
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
