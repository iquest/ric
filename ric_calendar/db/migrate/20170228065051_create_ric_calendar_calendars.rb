class CreateRicCalendarCalendars < ActiveRecord::Migration
	def change
		create_table :calendars do |t|

			# Timestamps
			t.timestamps null: true

			# Model
			t.string :model

			# Path to controller for showing event
			t.string :show_action, null: true

			# If editable, path to controller (such as "event_path")
			t.string :edit_action, null: true

			# Title
			t.string :title

			# Color
			t.string :color

		end
	end
end