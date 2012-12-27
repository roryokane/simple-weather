# encoding: utf-8

require 'wunderground'
require_relative 'config_loader'

CONFIG = ConfigLoader.new

# geolocate browser user
user = {
	location: CONFIG["test user"]["location"]
	temperature_units: CONFIG["test user"]["temperature units"]
}

# read weather using the API
# docs:
# https://github.com/wnadeau/wunderground_ruby
# http://www.wunderground.com/weather/api/d/docs?d=data/index

def get_api
	api_key = CONFIG["Wunderground"]["api key"]
	return Wunderground.new(api_key)
end
w_api = get_api()

# TODO make this return a hash of info
api_results = w_api.conditions_and_hourly_for(user[:location])
# api_results = w_api.conditions_and_hourly_and_forecast_and_yesterday_for(user[:location])
# require 'pry'; binding.pry
p api_results; exit
temperature_units_letter = {'english'=>'f', 'metric'=>'c'}
temperature_key = 'temp_' + temperature_units_letter[user[:temperature_units]]
current_temp = api_results['current_observation'][temperature_key].to_i
current_weather = api_results['current_observation']['weather']
current_weather_icon = api_results['current_observation']['icon_url']

hourly_forecast = api_results['hourly_forecast']
processed_hourly_forecast = hourly_forecast.map do |hour_forecast|
	{
		time: Time.new(hour_forecast['FCTTIME']['epoch'].to_i) ,
		temp: hour_forecast['temp'][user[:temperature_units]].to_i ,
		condition: hour_forecast['condition']
	}
end

wunderground_link = "http://www.wunderground.com/cgi-bin/findweather/getForecast?query=" + user[:location]

# TODO make this a text template that takes a hash
def hourly_forecasts_text_list(processed_hourly_forecast)
	processed_hourly_forecast.map do |hour|
		hour[:time].to_s + "-" + hour[:temp].to_s + "-" + hour[:condition]
	end.join(", ")
end
puts "location: #{user[:location]}"
puts ""
puts "Yesterday’s Weather"
puts "?"
puts ""
puts "Today’s Weather"
puts "current temperature: #{current_temp} °C"
puts "current weather: #{current_weather} (icon: #{current_weather_icon})"
puts "hourly forecasts (time, temperature, weather): #{hourly_forecasts_text_list(processed_hourly_forecast)}"
puts ""
puts "Tomorrow’s Weather"
puts "?"
puts ""
puts "more info: #{wunderground_link}"