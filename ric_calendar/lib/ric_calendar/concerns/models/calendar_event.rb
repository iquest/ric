# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module CalendarEvent extend ActiveSupport::Concern

				included do

					# *************************************************************************
					# Structure
					# *************************************************************************

					belongs_to :calendar_data, class_name: RicCalendar.calendar_data_model.to_s
					belongs_to :calendar_event_template, class_name: RicCalendar.calendar_event_template_model.to_s

					accepts_nested_attributes_for :calendar_data

					# TODO After destroy
				end

				module ClassMethods

					# *************************************************************************
					# Columns
					# *************************************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:start_date,
							:start_time,
							:end_date,
							:end_time,
							:all_day,
							:calendar_event_template_id,
							:is_modified,
							:calendar_data_id,

							:title,
							:description
						]
					end

					# *************************************************************************
					# Queries
					# *************************************************************************

					#
					# Return all events between given dates
					#
					def schedule(start_date, end_date)
						where("start_date >= ? AND end_date <= ?", start_date, end_date)
					end

				end

				# *************************************************************************
				# Calendar data
				# *************************************************************************

				# TODO: After destroy


				# *************************************************************************
				# Shotcuts
				# *************************************************************************

				def start_datetime
					if self.start_time
						self.start_date.to_datetime + self.start_time.seconds_since_midnight.seconds
					else
						self.start_date.to_datetime
					end
				end

				def end_datetime
					if self.end_time
						self.end_date.to_datetime + self.end_time.seconds_since_midnight.seconds
					else
						self.end_date.to_datetime
					end
				end

				# *************************************************************************
				# Conversions
				# *************************************************************************

				def to_fullcalendar
					{
						id: "RicCalendar::CalendarEvent<#{self.id}>",
						objectId: self.id,
						title: self.calendar_data.title,
						start: self.start_datetime,
						end: self.end_datetime,
						allDay: self.all_day,
					}
				end


			end

		end
	end
end