Rails.application.routes.draw do

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  root to: 'albums#index'

  resources :albums, :concerns => :paginatable
  get 'albums/show'  => 'photos#index'

  get 'doubles/find'
  get 'doubles/index'
  get 'doubles/:doubles_id/delete/:photo_id' => 'doubles#delete'
  
  resources :photos, :concerns => :paginatable
  get '/photos/:id/display' => 'photos#display'
  get '/photos/:id/image/:size' => 'photos#image'


  get 'locations/index'
end
