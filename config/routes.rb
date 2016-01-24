Rails.application.routes.draw do

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  root to: 'albums#index'

  resources :albums, :concerns => :paginatable
  get 'albums/show'  => 'photos#index'

  
  resources :photos, :concerns => :paginatable
  get '/photos/:id/display' => 'photos#display'
  get '/photos/:id/image/:size' => 'photos#image'


  resources :catalogs, :concerns => :paginatable
  get '/catalogs/:id/addphotos' => 'catalogs#addphotos'

  resources :locations, :concerns => :paginatable

  get 'doubles/find'
  get 'doubles/index'
  get 'doubles/:doubles_id/delete/:photo_id' => 'doubles#delete'


  get 'locations/index'
end
