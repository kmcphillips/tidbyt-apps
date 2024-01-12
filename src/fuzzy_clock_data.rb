#!/usr/bin/ruby
# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "erb"
  gem "dotenv"
  gem "open-weather-ruby-client"
  gem "activesupport"
end

require "dotenv/load"

require "active_support"
require "active_support/core_ext"
require "active_support/cache"


# cache_path = File.join(File.dirname(__FILE__), "../tmp/cache")
# data_cache = ActiveSupport::Cache::FileStore.new(cache_path)

# c.fetch("c", expires_in: 8.seconds) { get_the_data }
# expires_in: 15.minutes

# data = {
#   temperature: "",
# }

# # Weather
# begin
#   weather_client = OpenWeather::Client.new(api_key: ENV["OPEN_WEATHER_API_KEY"])
#   weather_response = weather_client.current_weather(city: "Ottawa", units: "metric")
#   data[:temperature] = weather_response.main.temp.round.to_s
# rescue => e
#   puts "Error getting weather: #{e}"
# end


class CachedData
  attr_reader :data

  def initialize(cache_path:)
    @data = {}
    ActiveSupport::Cache.format_version = 7.1
    @cache = ActiveSupport::Cache::FileStore.new(cache_path)
  end

  def value(key, expires_in: 15.minutes)
    begin
      @data[key.to_s] = @cache.fetch(key, expires_in: expires_in) do
        puts "Refreshing '#{ key }'"
        yield
      end
    rescue => e
      puts "Error getting '#{ key }': #{e}"
      @data[key.to_s] = ""
    end
  end
end


class StarlarkFileWriter
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

  def erb_filename = File.join(File.dirname(__FILE__), "fuzzy_clock_data.star.erb")
  def output_filename = File.join(File.dirname(__FILE__), "fuzzy_clock_data.star")

  def write(data)
    result = ERB.new(File.read(erb_filename)).result(Context.new(data).get_binding)
    File.write(output_filename, result)
  end
end


cache = CachedData.new(cache_path: File.join(File.dirname(__FILE__), "../tmp/cache"))

# Fetch the temperature
cache.value("weather", expires_in: 15.minutes) do
  weather_client = OpenWeather::Client.new(api_key: ENV["OPEN_WEATHER_API_KEY"])
  weather_response = weather_client.current_weather(city: "Ottawa", units: "metric")
  weather_response.main.temp.round.to_s
end

# Write the file with the data
writer = StarlarkFileWriter.new
puts "Writing '#{ writer.output_filename }' with DATA = #{cache.data}"
writer.write(cache.data)

puts "Done"
