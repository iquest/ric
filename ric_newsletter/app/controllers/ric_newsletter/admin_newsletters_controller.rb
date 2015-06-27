# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newsletters
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

require_dependency "ric_newsletter/admin_controller"

module RicNewsletter
	class AdminNewslettersController < AdminController
		include RicNewsletter::Concerns::Controllers::Admin::NewslettersController
	end
end