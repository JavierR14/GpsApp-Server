Rails.application.routes.draw do
	get 'test/index'
	
	post 'api/signup'
	post 'api/signin'

	get 'api/get_token'
	get 'api/clear_token'

	match "*path", to: "application#page_not_found_found", via: :all
end
