class CreateRicSettingsSettings < ActiveRecord::Migration
	def change
		create_table :settings do |t|

			t.timestamps null: true

			# Ordering
			t.integer :position
			
			# Identification
			t.string :key, index: true
			t.string :value
			t.string :kind
			
			# Category
			t.string :category
		end
	end
end