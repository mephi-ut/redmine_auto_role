# Hooks to attach to the Redmine Issues.

module AutoWatchHookModule
	class AutoWatchHook < Redmine::Hook::Listener
		def controller_issues_edit_before_save(context = {})
			issue = context[:issue]

			add_assignee_and_author(issue)
		end

		def controller_issues_new_before_save(context = {})
			add_assignee_and_author(context[:issue])
		end


		def controller_issues_bulk_edit_before_save(context = {})
			issue = context[:issue]

			add_assignee_and_author(issue)
		end

		private
		def add_assignee_and_author(issue)
			project = Project.find_by_id(issue['project_id'])
			if project.module_enabled?("auto_roles")
				Rails.logger.warn("Project ID: #{issue['project_id']}")
				assignee_role_id = project.custom_field_value(Setting.plugin_redmine_auto_role['assignee_autorole_custom_field_id'])
				unless assignee_role_id.nil? || assignee_role_id.empty? || assignee_role_id == '1'
					Rails.logger.warn("Adding. Role ID: #{assignee_role_id}")
					member         = Member.new
					member.user    = issue.assigned_to
					member.project = project
					member.roles  += [Role.find(assignee_role_id)]
					member.save
				end
				author_role_id = project.custom_field_value(Setting.plugin_redmine_auto_role['author_autorole_custom_field_id'])
				unless author_role_id.nil? || author_role_id.empty? || author_role_id == '1'
					Rails.logger.warn("Adding. Role ID: #{author_role_id}")
					member         = Member.new
					member.user    = issue.author
					member.project = project
					member.roles  += [Role.find(author_role_id)]
					member.save
				end
			end
		end
	end
end
