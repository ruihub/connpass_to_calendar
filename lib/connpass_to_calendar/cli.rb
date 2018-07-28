require "thor"

module ConnpassToCalendar
  class Cli < Thor
    option :event_id
    option :keyword
    option :keyword_or
    option :ym
    option :ymd
    option :nickkey
    option :owner_nickkey
    option :series_id
    option :start
    option :order
    option :count
    desc "put [--event_id=<event_id>] [--keyword=<keyword>] [--keyword_or=<keyword list>] [--ym=<start date>] [--ymd=<start datetime>] [--nickname=<menber nickname>] [--owner_nickname=<owner nickname>] [--series_id=<series_id>] [--start=<sarch result from>] [--order=<1:update datetime | 2:starting datetime | 3:new>] [--count=<1 to 100>]", "event put on calendar"

    def put
      Command.put_on_event(options)
    end

    desc "config key value", "set environment"

    def config(key, value = nil)
      if Models::Env::KEYS_LIST.include? key
        if value
          Command.set_config(key, value)
        else
          Command.show_config(key)
        end
      elsif key == "--list" && value == nil
        Command.list_config()
      else
        puts "error: key does not contain a section: #{key}"
      end
    end
  end
end
