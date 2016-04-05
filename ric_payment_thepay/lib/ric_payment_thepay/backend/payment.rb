# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payment object
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		class Payment
			
			# *****************************************************************
			# Status values
			# *****************************************************************

			#
			# Payment in progress.
			#
			STATUS_IN_PROGRESS = 1

			#
			# Correctly paid.
			#
			STATUS_OK = 2
			
			#
			# Canceled by customer.
			#
			STATUS_CANCELED = 3
			
			#
			# Some error occurred during payment process. Probably not payed.
			#
			STATUS_ERROR = 4

			#
			# Payment was underpaid
			#
			STATUS_UNDERPAID = 6

			#
			# Payment was paid, but waiting for confirmation from payment system.
			#
			STATUS_WAITING = 7

			#
			# Payment was paid, but waiting for confirmation from payment system.
			#
			STATUS_STORNO = 8

			#
			# Payment amount is blocked on customer's account. Money is charged 
			# after sending paymentDeposit request through API. Used only for 
			# card payments.
			#
			STATUS_CARD_DEPOSIT = 9

			# *****************************************************************
			# Common attributes
			# *****************************************************************

			#
			# Value indicating the amount of money that should be paid
			#
			attr_accessor :value
			def value=(value)
				value = value.to_f
				if value < 0.0
					raise "Payment value can't be below zero."
				end
				@value = value
			end
			def value
				return sprintf('%.2f', @value.to_f)
			end

			#
			# Currency identifier
			#
			attr_accessor :currency

			#
			# Payment description that should be visible to the customer
			#
			attr_accessor :description

			#
			# Any merchant-specific data, that will be returned to the site 
			# after the payment has been completed
			#
			attr_accessor :merchant_data

			#
			# ID of payment method to use for paying. Setting this argument 
			# hould be result of user's selection, not merchant's selection
			#
			attr_accessor :method_id
			
			#
			# If card payment will be charged immediately or only blocked and 
			# charged later by paymentDeposit operation
			#
			attr_accessor :is_deposit

			#
			# If card payment is recurring
			#
			attr_accessor :is_recurring

			# *****************************************************************
			# Query specific attributes
			# *****************************************************************

			#
			# URL where to redirect the user after the payment has been 
			# completed. It defaults to value configured in administration 
			# interface, but can be overwritten using this property.
			#
			attr_accessor :return_url

			#
			# Customer’s e-mail address. Used to send payment info and payment 
			# link from the payment info page
			#
			attr_accessor :customer_email

			#
			# Numerical specific symbol (used only if payment method supports it).
			#
			attr_accessor :merchant_specific_symbol

			# *****************************************************************
			# Returned specific attributes
			# *****************************************************************

			#
			# Payment status. One of enum values specified in the ThePay API 
			# documentation.
			#
			attr_accessor :status
			def status=(status)
				@status = status.to_i
			end

			#
			# Unique payment ID in the ThePay system.
			#
			attr_accessor :payment_id
			def payment_id=(payment_id)
				@payment_id = payment_id.to_i
			end

			#
			# Unique payment ID in the ThePay system.
			#
			def id
				return self.payment_id
			end

			#
			# Threat rating of the IP address that sent the payment.
			#
			attr_accessor :ip_rating

			#
			# If payment method is offline or online.
			#
			attr_accessor :is_offline

			#
			# If payment needs additional confirmation about it's state - for 
			# online methods with additional confirmation
			#
			attr_accessor :need_confirm

			#
			# If actual action is confirmation about payment state - for
			# online methods with additional confirmation
			#
			attr_accessor :is_confirm

			#
			# For offline payments, variable symbol (or equivalent) that 
			# identifies the payment.
			#
			attr_accessor :variable_symbol

			#
			# Specific symbol from bank transaction. Used only for permanent 
			# payments.
			#
			attr_accessor :specific_symbol

			#
			# Number of customer's account in full format including bank code.
	 		# Is set only if merchant has turned on this functionality and 
	 		# account number is available for used payment method.
			#
			attr_accessor :customer_account_number

			#
			# Name of customer's account. Usually name and surname of customer, 
			# but it could be arbitrary name which he set for his account in 
			# internet banking of his bank. Is filled only for some payment 
			# methods.
			#
			attr_accessor :customer_account_name

			# *****************************************************************
			# Query
			# *****************************************************************

			QUERY_ARGS = {
				"value" => "value", 
				"currency" => "currency", 
				"description" => "description", 
				"merchantData" => "merchant_data",
				# Customer data (only for FerBuy order) TODO
				"customerEmail" => "customer_email", 
				"returnUrl" => "return_url",
				"methodId" => "method_id",
				"deposit" => "is_deposit",
				"isRecurring" => "is_recurring",
				"merchantSpecificSymbol" => "merchant_specific_symbol",
			}

			#
			# List arguments to put into the URL. Returns associative array of
			# arguments that should be contained in the ThePay gate call.
			#
			def query_data
				result = {}

				result["merchantId"] = Config.merchant_id
				result["accountId"] = Config.account_id
				QUERY_ARGS.each do |param_name, attribute_name|
					value = self.send(attribute_name)
					result[param_name] = value if !value.nil?
				end
				
				return result
			end

			#
			# Returns signature to authenticate the payment. The signature
			# consists of hash of all specified parameters and the merchant
			# password specified in the configuration. So no one can alter the
			# payment, because the password is not known.
			#
			def query_signature
				result = ""
				query_data.each do |key, value|
					result += key + "=" + value.to_s + "&"
				end
				result += "password=" + Config.password
				return hash_function(result)
			end

			#
			# Build the query part of the URL from payment data and optional
			# helper data.
			#
			def query(optional_data = {})
				result = []
				all_query_data = query_data.merge(optional_data).merge({"signature" => self.query_signature})
				all_query_data.each do |key, value|
					result << (CGI.escape(key.to_s).gsub("+", "%20") + "=" + CGI.escape(value.to_s).gsub("+", "%20"))
				end
				return result.join("&amp;")
			end

			# *****************************************************************
			# Returned
			# *****************************************************************

			RETURNED_REQUIRED_ARGS = {
				"value" => "value", 
				"currency" => "currency", 
				"methodId" => "method_id", 
				"description" => "description", 
				"merchantData" => "merchant_data",
				"status" => "status", 
				"paymentId" => "payment_id", 
				"ipRating" => "ip_rating", 
				"isOffline" => "is_offline", 
				"needConfirm" => "need_confirm"
			}

			RETURNED_OPTIONAL_ARGS = {
				"isConfirm" => "is_confirm", 
				"variableSymbol" => "variable_symbol", 
				"specificSymbol" => "specific_symbol", 
				"deposit" => "is_deposit", 
				"isRecurring" => "is_recurring", 
				"customerAccountNumber" => "customer_account_number", 
				"customerAccountName" => "customer_account_name",
			}

			def load_from_params(params)
				
				# Special params
				@returned_merchant_id = params["merchantId"].to_i if !params["merchantId"].blank?
				@returned_account_id = params["accountId"].to_i if !params["accountId"].blank?
				@returned_signature = params["signature"]

				# Required params
				RETURNED_REQUIRED_ARGS.each do |param_name, attribute_name|
					if params[param_name]
						self.send("#{attribute_name}=", params[param_name])
					else
						raise "Missing parameter #{param_name}."
					end
				end

				# Optional params
				RETURNED_OPTIONAL_ARGS.each do |param_name, attribute_name|
					if params[param_name]
						self.send("#{attribute_name}=", params[param_name])
					end
				end
				
			end

			#
			# Verify if signature loaded from params is correct
			#
			def verify_returned_signature
				if @returned_merchant_id != Config.merchant_id
					return false
				end
				if @returned_account_id != Config.account_id
					return false
				end

				# Compute signature from current data
				data_signature = []
				data_signature << "merchantId=" + @returned_merchant_id.to_s
				data_signature << "accountId=" + @returned_account_id.to_s
				RETURNED_REQUIRED_ARGS.merge(RETURNED_OPTIONAL_ARGS).each do |param_name, attribute_name|
					value = self.send(attribute_name)
					data_signature << (param_name + "=" + value.to_s) if !value.nil?
				end
				data_signature << "password=" + Config.password
				data_signature = self.hash_function(data_signature.join("&"))

				if data_signature == @returned_signature
					return true
				else
					return false
				end
			end

		protected

			#
			# Function that calculates hash
			#
			def hash_function(str)
				return Digest::MD5.hexdigest(str)
			end

		end
	end
end