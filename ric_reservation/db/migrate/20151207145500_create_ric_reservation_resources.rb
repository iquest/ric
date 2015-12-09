# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Create resource migration
# *
# * Author: Matěj Outlý
# * Date  : 25. 11. 2015
# *
# *****************************************************************************

class CreateRicReservationResources < ActiveRecord::Migration
	def change
		create_table :resources do |t|
			t.timestamps null: true

			# Single table inheritance
			t.string :type

			# Position
			t.integer :position

			# Identification
			t.string :name

			# Time window
			t.integer :time_window_soon
			t.integer :time_window_deadline

		end
	end
end