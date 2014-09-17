RedmineApp::Application.routes.draw do
	resources :projects do
		member do
			put 'autorole', :to => 'projects#setautorole'
			get 'autorole', :to => 'projects#getautorole'
		end
	end
end
