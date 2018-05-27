Rails.application.routes.draw do
	resources :shorten_urls do
		get :upload_csv, :on => :collection
		post :parse_csv, :on => :collection
	end
	get '/:slug' => 'shorten_urls#show'
	get '/' => 'shorten_urls#index'
	
end
