# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Order
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicEshop
	module Concerns
		module Models
			module Order extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# One-to-many relation with order items
					#
					has_many :order_items, class_name: RicEshop.order_item_model.to_s, dependent: :destroy
					
					# *********************************************************
					# Enums
					# *********************************************************

					#
					# Payment type
					#
					enum_column :payment_type, config(:payment_types)

					#
					# Delivery type
					#
					enum_column :delivery_type, config(:delivery_types)

					#
					# Currency
					#
					enum_column :currency, config(:currencies)

					# *********************************************************
					# Addresses
					# *********************************************************

					#
					# Billing address
					#
					address_column :billing_address

					# *********************************************************
					# Virtual attributes
					# *********************************************************

					#
					# Accept terms
					#
					attr_accessor :accept_terms

					# *********************************************************
					# Callbacks
					# *********************************************************

					before_create :synchronize_customer

					after_create :synchronize_items

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Payment and delivery type
					#
					validates_presence_of :payment_type, :delivery_type, :if => :basic_step?

					#
					# Apply custom validator
					#
					validate :validate_accept_terms

					# *********************************************************
					# JSON
					# *********************************************************

					#
					# Define additional methods to JSON export
					#
					add_methods_to_json [:price]

				end

				module ClassMethods

					# *********************************************************
					# Steps
					# *********************************************************

					#
					# Define new step
					#
					def step(new_step)
						@steps = [] if @steps.nil?
						@steps << new_step.to_s

						# Check method
						define_method((new_step.to_s + "_step?").to_sym) do
							step = new_step
							return self.current_step == step.to_s
						end
					end

					#
					# Get all defined steps
					#
					def steps
						@steps = [] if @steps.nil?
						return @steps
					end

				end

				# *************************************************************
				# Payment
				# *************************************************************

				#
				# Locked for update?
				#
				def locked?
					return false
				end

				#
				# Total price
				#
				def price
					result = 0
					self.order_items.each do |order_item|
						result += order_item.price
					end
					return result
				end

				# *************************************************************
				# Terms
				# *************************************************************

				#
				# Override accept terms validation
				#
				def override_accept_terms
					self.accept_terms = true
				end

				# *************************************************************
				# Cart
				# *************************************************************

				#
				# Get cart object
				#
				def cart
					if @cart.nil?
						@cart = RicEshop.cart_model.find(self.session_id)
					end
					return @cart
				end

				# *************************************************************
				# Payment
				# *************************************************************

				#
				# Get all defined steps
				#
				def steps
					return self.class.steps
				end

				#
				# Current step
				#
				attr_writer :current_step
				def current_step
					@current_step || steps.first
				end

				#
				# Set to next step
				#
				def next_step
					self.current_step = self.steps[self.steps.index(self.current_step) + 1]
				end

				#
				# Set to preview step
				#
				def previous_step
					self.current_step = self.steps[self.steps.index(self.current_step) - 1]
				end

				#
				# Is this first step?
				#
				def first_step?
					return self.current_step == self.steps.first
				end

				#
				# Is this last step?
				#
				def last_step?
					return self.current_step == self.steps.last
				end

				#
				# Validate all steps
				#
				def all_valid?
					result = true
					tmp_step = self.current_step
					self.steps.all? do |step|
						self.current_step = step
						result = valid? && result
					end
					self.current_step = tmp_step
					return result
				end
				
			protected

				# *************************************************************
				# Callbacks
				# *************************************************************

				#
				# Copy relevant attributes from binded customer to order
				#
				def synchronize_customer
					if !self.customer_id.blank?
						self.product_name = self.customer.name
						self.product_email = self.customer.email
						self.product_phone = self.customer.phone
					end
				end

				#
				# Move items from cart to order
				#
				def synchronize_items
					if !self.session_id.blank?
						self.cart.cart_items.each do |cart_item|
							self.order_items.create(product_id: cart_item.product_id, sub_product_ids: cart_item.sub_product_ids, amount: cart_item.amount)
						end
						self.cart.virtual_items.each do |virtual_item|
							self.order_items.create(product_name: virtual_item.name, product_price: virtual_item.price, product_currency: virtual_item.currency, amount: 1)
						end
						self.cart.clear
					end
				end

				# *************************************************************
				# Validators
				# *************************************************************

				#
				# Validate if accept terms is set to true
				#
				def validate_accept_terms

					# Not basic step => no validation
					if !self.basic_step?
						return
					end
					
					# Accept terms must be set to true	
					if self.accept_terms != true && self.accept_terms != "1"
						errors.add(:accept_terms, I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.attributes.accept_terms.not_true"))
					end
				
				end

			end
		end
	end
end