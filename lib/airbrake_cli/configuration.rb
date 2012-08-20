require 'multi_json'
require 'airbrake_api'

module AirbrakeCli
   module Configuration
      extend self

      def configured?
         File.exist?(datafile)
      end

      def configure_api_client!
         raise 'not yet configured' unless configured?

         AirbrakeAPI.configure do |config|
            config.account = self.account
            config.auth_token = self.auth_token
            config.secure = self.secure
         end
      end

      def account
         fetch "account"
      end

      def account=(value)
         update "account", value
      end

      def auth_token
         fetch "auth_token"
      end

      def auth_token=(value)
         update "auth_token", value
      end

      def secure
         fetch "secure" || true
      end

      def secure=(value)
         update "secure", value
      end

   private
      def fetch(key)
         data[key]
      end

      def update(key, value)
         data[key] = value
         save!
      end

      def save!
         File.open(datafile, "w+") {|f| f.write MultiJson.dump(@data) }
      end

      def data
         @data ||= MultiJson.load(File.read(datafile)) rescue {}
      end

      def datafile
         File.expand_path(".airbrake-cli", ENV["HOME"])
      end
   end
end
