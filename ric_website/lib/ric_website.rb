# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicWebsite
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

# Railtie
require 'ric_website/railtie' if defined?(Rails)

# Engines
require "ric_website/admin_engine"
require "ric_website/public_engine"

# Middlewares
require 'ric_website/middlewares/locale'
require 'ric_website/middlewares/slug'

# Models
require 'ric_website/concerns/models/page'
require 'ric_website/concerns/models/menu'
require 'ric_website/concerns/models/text'
require 'ric_website/concerns/models/text_attachment'
require 'ric_website/concerns/models/slug'
require 'ric_website/concerns/models/setting'
require 'ric_website/concerns/models/settings_collection'

# Helpers
require 'ric_website/helpers/locale_helper'
require 'ric_website/helpers/slug_helper'
require 'ric_website/helpers/setting_helper'

module RicWebsite

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Text model
	#
	mattr_accessor :text_model
	def self.text_model
		if @@text_model.nil?
			return RicWebsite::Text
		else
			return @@text_model.constantize
		end
	end

	#
	# Text attachment model
	#
	mattr_accessor :text_attachment_model
	def self.text_attachment_model
		if @@text_attachment_model.nil?
			return RicWebsite::TextAttachment
		else
			return @@text_attachment_model.constantize
		end
	end

	#
	# Page model
	#
	mattr_accessor :page_model
	def self.page_model
		if @@page_model.nil?
			return RicWebsite::Page
		else
			return @@page_model.constantize
		end
	end

	#
	# Menu model
	#
	mattr_accessor :menu_model
	def self.menu_model
		if @@menu_model.nil?
			return RicWebsite::Menu
		else
			return @@menu_model.constantize
		end
	end

	#
	# Slug model
	#
	mattr_accessor :slug_model
	def self.slug_model
		if @@slug_model.nil?
			return RicWebsite::Slug
		else
			return @@slug_model.constantize
		end
	end

	#
	# Setting model
	#
	mattr_accessor :setting_model
	def self.setting_model
		if @@setting_model.nil?
			return RicWebsite::Setting
		else
			return @@setting_model.constantize
		end
	end

	#
	# Settings collection model
	#
	mattr_accessor :settings_collection_model
	def self.settings_collection_model
		if @@settings_collection_model.nil?
			return RicWebsite::SettingsCollection
		else
			return @@settings_collection_model.constantize
		end
	end

end
