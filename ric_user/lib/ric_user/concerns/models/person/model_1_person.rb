# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Person with single user, user has max one person associated
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module Model1Person extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_one :user, class_name: RicUser.user_model.to_s, as: :person

				end

				def create_user(user_params = {})
					if !self.user.nil?
						return self.user
					end

					# Build user
					user_params = synchronized_params.merge(user_params)
					user_params[:email] = self.email
					user_params[:role] = self.person_role
					user = self.build_user(user_params)

					# Password
					new_password = user.regenerate_password(notification: false)
					
					# Return invalid user with error messages
					return user if !user.errors.empty?
					if !new_password
						# TODO user.errors.add(...)
						return nil
					end

					# Notification
					RicNotification.notify(["#{self.person_role}_welcome".to_sym, self, new_password], user) if !(defined?(RicNotification).nil?)
					return user
				end

				def destroy_user
					if !self.user.nil?
						self.user.destroy
					end
				end

			end
		end
	end
end