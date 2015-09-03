# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

RicAssortment::AdminEngine.routes.draw do

	# Products
	resources :products, controller: "admin_products"

	# Product attachments
	resources :product_attachments, controller: "admin_product_attachments"

	# Product attachment relations
	resources :product_attachment_relations, only: [:edit, :update, :destroy], controller: "admin_product_attachment_relations"

	# Product categories
	resources :product_categories, controller: "admin_product_categories"

	# Product category relations
	resources :product_category_relations, only: [:edit, :update, :destroy], controller: "admin_product_category_relations"

	# Product photos
	resources :product_photos, only: [:show, :new, :edit, :create, :update, :destroy], controller: "admin_product_photos"

	# Product tickers
	resources :product_tickers, controller: "admin_product_tickers"

	# Product ticker relations
	resources :product_ticker_relations, only: [:edit, :update, :destroy], controller: "admin_product_ticker_relations"

end