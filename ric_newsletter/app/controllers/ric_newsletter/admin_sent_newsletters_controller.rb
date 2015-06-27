# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sent newsletters
# *
# * Author: Matěj Outlý
# * Date  : 17. 2. 2015
# *
# *****************************************************************************

require_dependency "ric_newsletter/admin_controller"

module RicNewsletter
	class AdminSentNewslettersController < AdminController
		include RicNewsletter::Concerns::Controllers::Admin::SentNewslettersController
	end
end