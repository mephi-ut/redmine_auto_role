require 'redmine'

require_dependency 'auto_role_hook'
require_dependency 'auto_role_patch'

Redmine::Plugin.register :redmine_auto_role do
	name 'Redmine Auto role plugin'
	author 'Dmitry Yu Okunev'
	description 'This plugin is a hook to add users to the project membership list automatically when they are assigned to some task.'
	version '0.0.1'

	project_module :auto_roles do
		permission :edit_projects,
			{ :projects => [:setassigneeautorole, :getassigneeautorole, :setauthorautorole, :getauthorautorole, ] },
			:require => :loggedin, :public => true
	end

	settings :default => {
			:assignee_autorole_custom_field_id	=> nil,
			:author_autorole_custom_field_id	=> nil
		 },
		 :partial => 'auto_roles/settings'
end

Rails.configuration.to_prepare do
	unless ProjectsHelper.included_modules.include?(AutoRolesProjectsHelperPatch)
		ProjectsHelper.send(:include, AutoRolesProjectsHelperPatch)
	end
end

