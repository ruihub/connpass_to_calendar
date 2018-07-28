require "fileutils"
require "active_record"

module ConnpassToCalendar
  module DB
    def self.prepare
      database_path = File.join(ENV["HOME"], ".connpass_to_calendar", "db", "connpass_to_calendar.sqlite3")

      connect_database database_path
      create_database_path database_path
      create_envs_table
      create_events_table
    end

    def self.connect_database(path)
      config = {adapter: "sqlite3", database: path}
      ActiveRecord::Base.establish_connection config
    end

    def self.create_envs_table
      connection = ActiveRecord::Base.connection

      return if connection.table_exists?(:envs)

      connection.create_table :envs do |t|
        t.column :keyword, :string, :null => false
        t.column :value, :string, :null => false
        t.timestamps
      end
      connection.add_index :envs, :keyword, unique: true
    end

    def self.create_events_table
      connection = ActiveRecord::Base.connection

      return if connection.table_exists?(:events)

      connection.create_table :events do |t|
        t.column :summary, :string
        t.column :location, :string
        t.column :description, :string
        t.column :start_date_time, :datetime
        t.column :end_date_time, :datetime
        t.timestamps
      end
    end

    def self.create_database_path(path)
      FileUtils.mkdir_p File.dirname(path)
    end

    private_class_method :connect_database, :create_envs_table, :create_events_table, :create_database_path
  end
end
