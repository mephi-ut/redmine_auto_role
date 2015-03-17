require_dependency 'projects_helper'

module AutoRolesProjectsHelperPatch
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			def setassigneeautorole
				logger.warn("[assignee] in auto-role id: #{params[:role][:id]}")
				@project.custom_field_values=({Setting.plugin_redmine_auto_role['assignee_autorole_custom_field_id'] => params[:role][:id]})
				@project.save_custom_field_values
				redirect_to :back
			end
			def getassigneeautorole
				redirect_to(
					:controller => 'projects',
					:action => 'settings',
					:id => @project.identifier
				)
			end
			def setauthorautorole
				logger.warn("[author] in auto-role id: #{params[:role][:id]}")
				@project.custom_field_values=({Setting.plugin_redmine_auto_role['author_autorole_custom_field_id'] => params[:role][:id]})
				@project.save_custom_field_values
				redirect_to :back
			end
			def getauthorautorole
				redirect_to(
					:controller => 'projects',
					:action => 'settings',
					:id => @project.identifier
				)
			end

			unloadable
			alias_method_chain :project_settings_tabs, :auto_roles
		end
	end

	module ClassMethods
	end

	module InstanceMethods
		def project_settings_tabs_with_auto_roles
			tabs = project_settings_tabs_without_auto_roles
			if @project.module_enabled?("auto_roles")
				tabs.push({
					:name    => :auto_roles,
					:action  => :auto_roles,
					:partial => 'projects/settings/auto_roles',
					:label   => :auto_roles
				})
			end
			return tabs
		end
	end
end
