#!/usr/bin/ruby
# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "erb"
  gem "dotenv"
  gem "open-weather-ruby-client"
end

require "dotenv/load"

erb_filename = File.join(File.dirname(__FILE__), "fuzzy_clock_data.star.erb")
output_filename = File.join(File.dirname(__FILE__), "fuzzy_clock_data.star")
data = {
  temperature: "",
}

# Weather
begin
  weather_client = OpenWeather::Client.new(api_key: ENV["OPEN_WEATHER_API_KEY"])
  weather_response = weather_client.current_weather(city: "Ottawa", units: "metric")
  data[:temperature] = weather_response.main.temp.round.to_s
rescue => e
  puts "Error getting weather: #{e}"
end

# Write the Starlark file
class Context
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def data_as_starlark_dict
    "{ #{ data.map { |k, v| "\"#{k}\": \"#{v}\"" }.join(", ") } }"
  end

  def get_binding
    binding
  end
end

puts "Writing '#{ output_filename }' with DATA = #{data}"

result = ERB.new(File.read(erb_filename)).result(Context.new(data).get_binding)
File.write(output_filename, result)

puts "Done"
