Rails.application.routes.draw do
	root 'test#index'
	get 'test/index'

	post 'api/signup' #=> 'api#signup'
	post 'api/signin' #=> 'api#signin'

	get 'api/get_token'
	get 'api/clear_token'

	post 'api/post_location'

	match "*path", to: "application#page_not_found_found", via: :all
end
