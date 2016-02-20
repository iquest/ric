# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicCustomer
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

# Engines
require "ric_customer/admin_engine"

# Models
require "ric_customer/concerns/models/customer"


module RicCustomer

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
	# Customer model
	#
	mattr_accessor :customer_model
	def self.customer_model
		return @@customer_model.constantize
	end
	@@customer_model = "RicCustomer::Customer"

end
