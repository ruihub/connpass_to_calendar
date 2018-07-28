require "net/http"
require "uri"
require "json"
require "date"

module ConnpassToCalendar
  module Api
    module Connpass
      class Event
        def self.get(params)
          begin
            validation params
            params = URI.encode_www_form params
            uri = URI.parse("https://connpass.com/api/v1/event/?#{params}")
            response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) { |http|
              request = Net::HTTP::Get.new uri
              http.request request
            }
            JSON.parse response.body
          rescue ArgumentError => e
            puts e.message
            exit
          rescue IOError => e
            puts e.message
            exit
          rescue Timeout::Error => e
            puts e.message
            exit
          rescue JSON::ParserError => e
            puts e.message
            exit
          rescue => e
            puts e.message
            exit
          end
        end

        def self.validation(params)
          params = Hash[params.map { |k, v| [k.to_sym, v] }]
          params.each do |key, value|
            case key
            when :event_id
              unless value.kind_of?(Array)
                value = Array[value]
              end
              value.each do |event_id|
                unless event_id =~ /^[0-9]+$/
                  raise ArgumentError, "event_id validation error"
                end
              end
            when :keyword
            when :keyword_or
            when :ym
              unless value.kind_of?(Array)
                value = Array[value]
              end
              format = "%Y%m"
              begin
                value.each do |ym|
                  DateTime.strptime(ym, format)
                end
              rescue ArgumentError
                raise ArgumentError, "ym validation error"
              end
            when :ymd
              unless value.kind_of?(Array)
                value = Array[value]
              end
              format = "%Y%m%d"
              begin
                value.each do |ymd|
                  DateTime.strptime(ymd, format)
                end
              rescue ArgumentError
                raise ArgumentError, "ymd validation error"
              end
            when :nickname
            when :owner_nickname
            when :series_id
              unless value.kind_of?(Array)
                value = Array[value]
              end
              value.each do |series_id|
                unless series_id =~ /^[0-9]+$/
                  raise ArgumentError, "series_id validation error"
                end
              end
            when :start
              unless value =~ /^[0-9]+$/
                raise ArgumentError, "start validation error"
              end
            when :order
              unless value =~ /^[1-3]$/
                raise ArgumentError, "order validation error"
              end
            when :count
              unless value =~ /^[0-9]+$/
                raise ArgumentError, "count validation error"
              end
              if value.to_i < 0 || 100 < value.to_i
                raise ArgumentError, "count validation error"
              end
            else
              raise ArgumentError, "parameter not exist"
            end
          end
        end

        private_class_method :validation
      end
    end
  end
end
