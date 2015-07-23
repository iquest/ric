# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Railtie for view helpers integration
# *
# * Author: Matěj Outlý
# * Date  : 22. 7. 2015
# *
# *****************************************************************************

require 'ric_website/helpers/slug_helper'

module RicWebsite
	class Railtie < Rails::Railtie
		initializer "ric_website.helpers" do
			ActionView::Base.send :include, Helpers::SlugHelper
		end
	end
end