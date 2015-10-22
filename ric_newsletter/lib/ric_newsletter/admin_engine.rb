# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_newsletter/concerns/controllers/admin/newsletters_controller'
		require 'ric_newsletter/concerns/controllers/admin/sent_newsletters_controller'
		
		#
		# Namespace
		#
		isolate_namespace RicNewsletter

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
