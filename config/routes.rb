Rails.application.routes.draw do

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  root to: 'albums#index'

  get 'albums/select' => 'albums/select'
  post 'albums/select' => 'albums/select'
    
  
  resources :albums, :concerns => :paginatable
  
  #get 'albums/show'  => 'photos#grid'

  
  resources :photos, :concerns => :paginatable
  get '/photos/:id/display' => 'photos#display'
  get '/photos/:id/image/:size' => 'photos#image'


  get '/catalogs/test' => 'catalogs#test'
  resources :catalogs, :concerns => :paginatable
  get '/catalogs/:id/import' => 'catalogs#import'
  post '/catalogs/:id/bucket' => 'catalogs#bucket'


  resources :locations, :concerns => :paginatable
  get '/locations/:id/view' => 'locations#view'
  get 'locations/index'

  post 'bucket/:id/add' => 'bucket#add'
  post 'bucket/:id/remove' => 'bucket#remove'
  get  'bucket' => 'bucket#index'
  get 'bucket/clear' => 'bucket#clear'
  get 'bucket/count' => 'bucket#count'
  get  'bucket/save' => 'bucket#save_to_album'

  get 'doubles/find'
  get 'doubles/index'
  get 'doubles/:doubles_id/delete/:photo_id' => 'doubles#delete'

  get 'administration/generate_timebased_albums'
  
  get 'synchronizers/dropbox'
  
  
  require 'resque/server'
  
  mount Resque::Server.new, at: "/resque"
  

end
