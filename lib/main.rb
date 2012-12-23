# encoding: utf-8

require 'wunderground'
require_relative 'config_loader'

CONFIG = ConfigLoader.new

# geolocate browser user
location = CONFIG["test user"]["location"]

# read weather using the API
# docs:
# https://github.com/wnadeau/wunderground_ruby
# http://www.wunderground.com/weather/api/d/docs?d=data/index

def get_api
	api_key = CONFIG["Wunderground"]["api key"]
	return Wunderground.new(api_key)
end
w_api = get_api

conditions_info = w_api.conditions_for(location)
current_temp = conditions_info['current_observation']['temp_c']
current_weather = conditions_info['current_observation']['weather']
current_weather_icon = conditions_info['current_observation']['icon_url']

wunderground_link = "http://www.wunderground.com/cgi-bin/findweather/getForecast?query=" + location

puts "location: #{location}"
puts "Today's Weather"
puts "current temperature: #{current_temp} °C"
puts "current weather: #{current_weather} (icon: #{current_weather_icon})"
puts "more info: #{wunderground_link}"