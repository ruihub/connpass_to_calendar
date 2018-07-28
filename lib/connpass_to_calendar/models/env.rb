require "active_record"

module ConnpassToCalendar
  module Models
    class Env < ActiveRecord::Base
      KEYS_LIST = ["application_name", "credentials_path", "token_path", "user_id"].freeze
    end
  end
end
