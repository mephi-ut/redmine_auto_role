RedmineApp::Application.routes.draw do
	resources :projects do
		member do
			put   'assigneeautorole', :to => 'projects#setassigneeautorole'
			patch 'assigneeautorole', :to => 'projects#setassigneeautorole'
			get   'assigneeautorole', :to => 'projects#getassigneeautorole'
			put   'authorautorole', :to => 'projects#setauthorautorole'
			patch 'authorautorole', :to => 'projects#setauthorautorole'
			get   'authorautorole', :to => 'projects#getauthorautorole'
		end
	end
end
