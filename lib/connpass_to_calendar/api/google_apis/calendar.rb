require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"

module ConnpassToCalendar
  module Api
    module GoogleApis
      class Calendar
        OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
        SCOPE = "https://www.googleapis.com/auth/calendar"

        def initialize(application_name, credentials_path, token_path, user_id)
          @application_name = application_name
          @credentials_path = credentials_path
          @token_path = token_path
          @user_id = user_id
        end

        ##
        # Ensure valid credentials, either by restoring from the saved credentials
        # files or intitiating an OAuth2 authorization. If authorization is required,
        # the user's default browser will be launched to approve the request.
        #
        # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
        def authorize
          client_id = Google::Auth::ClientId.from_file(@credentials_path)
          token_store = Google::Auth::Stores::FileTokenStore.new(file: @token_path)
          authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
          credentials = authorizer.get_credentials(@user_id)
          if credentials.nil?
            url = authorizer.get_authorization_url(base_url: OOB_URI)
            puts "Open #{url} in your browser and enter the resulting code:"
            code = STDIN.gets.chomp
            credentials = authorizer.get_and_store_credentials_from_code(
              user_id: @user_id, code: code, base_url: OOB_URI,
            )
          end
          credentials
        end

        def create_event(summary, location, description, start_date_time, end_date_time)
          client = Google::Apis::CalendarV3::CalendarService.new
          client.client_options.application_name = @application_name
          client.authorization = authorize

          event = Google::Apis::CalendarV3::Event.new({
            summary: summary,
            location: location,
            description: description,
            start: {
              date_time: start_date_time,
              time_zone: "Japan",
            },
            end: {
              date_time: end_date_time,
              time_zone: "Japan",
            },
          })
          result = client.insert_event("primary", event)
          puts "Event created: #{result.html_link}"
        end

        private :authorize
      end
    end
  end
end
