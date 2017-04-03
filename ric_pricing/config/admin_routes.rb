# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

RicPricing::AdminEngine.routes.draw do

	# Price lists
	resources :price_lists, controller: "admin_price_lists" do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end

		# Prices
		resources :prices, controller: "admin_prices", only: [:new, :edit, :create, :update, :destroy] do
			member do
				put "move/:relation/:destination_id", action: "move", as: "move"
			end
		end
		
	end

end