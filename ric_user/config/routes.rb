# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

RicUser::AdminEngine.routes.draw do

	# Users
	resources :users, controller: "admin_users"

	# User passwords
	resources :user_passwords, controller: "admin_user_passwords", only: [:edit, :update] do
		member do
			get "regenerate"
			put "regenerate"
		end
	end

end