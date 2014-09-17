# Hooks to attach to the Redmine Issues.

module AutoWatchHookModule
	class AutoWatchHook < Redmine::Hook::Listener
		def controller_issues_edit_before_save(context = {})
			issue = context[:issue]

			add_assignee(issue)
		end

		def controller_issues_new_before_save(context = {})
			add_assignee(context[:issue])
		end


		def controller_issues_bulk_edit_before_save(context = {})
			issue = context[:issue]

			add_assignee(issue)
		end

		private
		def add_assignee(issue)
			project = Project.find_by_id(issue['project_id'])
			if project.module_enabled?("auto_roles")
				Rails.logger.warn("Project ID: #{issue['project_id']}")
				role_id = project.custom_field_value(Setting.plugin_redmine_auto_role['autorole_custom_field_id'])
				unless role_id.nil? || role_id == '1'
					Rails.logger.warn("Adding")
					member         = Member.new
					member.user    = issue.assigned_to
					member.project = project
					member.roles  += [Role.find(role_id)]
					member.save
				end
			end
		end
	end
end
