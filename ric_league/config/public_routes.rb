# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

RicLeague::PublicEngine.routes.draw do

	# Active teams
	resources :active_teams, only: [:index, :show], controller: "public_active_teams"

	#
	# Active league
	#
	get "active_league/results", to: "public_active_league#results"
	get "active_league/schedule", to: "public_active_league#schedule"

end