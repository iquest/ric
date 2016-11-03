# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicUrl
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

# Railtie
require "ric_url/railtie" if defined?(Rails)

# Engines
require "ric_url/admin_engine"

# Middlewares
require "ric_url/middlewares/locale"
require "ric_url/middlewares/slug"

# Models
require "ric_url/concerns/models/slug"

# Helpers
require "ric_url/helpers/locale_helper"
require "ric_url/helpers/slug_helper"

module RicUrl

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Default way to setup module
	#
	def self.setup
		yield self
	end

	# *************************************************************************
	# Config options
	# *************************************************************************

	#
	# Slug model
	#
	mattr_accessor :slug_model
	def self.slug_model
		return @@slug_model.constantize
	end
	@@slug_model = "RicUrl::Slug"

	#
	# Enable slugs subsystem
	#
	mattr_accessor :enable_slugs
	@@enable_sluggification = true

	#
	# Enable localization subsystem
	#
	mattr_accessor :enable_locales
	@@enable_localization = true

end