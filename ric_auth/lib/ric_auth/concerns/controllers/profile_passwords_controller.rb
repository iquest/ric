# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Passwords
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module Controllers
			module ProfilePasswordsController extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					prepend_before_action :disable_password_enforcement if self.instance_methods.include?(:disable_password_enforcement)
					before_action :authenticate_user!
					before_action :set_user

				end

				def edit
				end

				def update
					if @user.update_with_password(user_params)
						sign_in @user, :bypass => true
						path = stored_location_for(:user) || ric_auth.edit_profile_path
						redirect_to path, notice: I18n.t("activerecord.notices.models.#{RicAuth.user_model.model_name.i18n_key}.update_password")
					else
						render "edit"
					end
				end

			protected

				def set_user
					@user = current_user
					if @user.nil?
						redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAuth.user_model.model_name.i18n_key}.not_found")
					end
				end

				# 
				# Never trust parameters from the scary internet, only allow the white list through.
				#
				def user_params
					params.require(:user).permit(
						:current_password, 
						:password, 
						:password_confirmation
					)
				end

			end
		end
	end
end
