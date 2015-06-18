# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User mailer
# *
# * Author: Matěj Outlý
# * Date  : 18. 6. 2015
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Mailers
			module UserMailer extend ActiveSupport::Concern

				#
				# New password
				#
				def new_password(user, new_password)
					@user = user
					@password = new_password
					mail(to: user.email, subject: I18n.t("activerecord.mailers.ric_user.user.new_password.subject"))
				end

			end
		end
	end
end
