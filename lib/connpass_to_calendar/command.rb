module ConnpassToCalendar
  class Command
    def self.put_on_event(params)
      check_env

      DB.prepare

      result = Api::Connpass::Event.get(params)
      events = result["events"]
      events.each do |event|
        event_id = event["event_id"]
        summary = event["title"]
        location = "#{event["address"]} #{event["place"]}"
        description = "#{event["catch"]}
イベントURL:#{event["event_url"]}
定員:#{event["limit"]}"
        start_date_time = event["started_at"]
        end_date_time = event["ended_at"]

        puts summary
        puts location
        puts description
        puts start_date_time
        puts end_date_time

        unless Models::Event.find_by(id: event_id)
          Models::Event.create(id: event_id, summary: summary, description: description, start_date_time: start_date_time, end_date_time: end_date_time)

          application_name = Models::Env.find_by(keyword: "application_name").value
          credentials_path = Models::Env.find_by(keyword: "credentials_path").value
          token_path = Models::Env.find_by(keyword: "token_path").value
          user_id = Models::Env.find_by(keyword: "user_id").value
          calendar = Api::GoogleApis::Calendar.new(application_name, credentials_path, token_path, user_id)
          calendar.create_event(summary, location, description, start_date_time, end_date_time)
        end
      end
    end

    def self.set_config(key, value)
      DB.prepare

      env = Models::Env.find_by(keyword: key)
      if env
        env.update(value: value)
      else
        Models::Env.create(keyword: key, value: value)
      end
    end

    def self.show_config(key)
      DB.prepare

      puts Models::Env.find_by(keyword: key).value
    end

    def self.list_config()
      DB.prepare

      envs = Models::Env.order(:keyword)
      envs.each do |env|
        puts "#{env.keyword}=#{env.value}"
      end
    end

    def self.check_env
      DB.prepare

      Models::Env::KEYS_LIST.each do |key|
        unless Models::Env.find_by(keyword: key)
          puts "Not enough env. Please use the [config] command to set the env."
          exit
        end
      end
    end

    private_class_method :check_env
  end
end
