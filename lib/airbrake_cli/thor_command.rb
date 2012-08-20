require 'thor'

module AirbrakeCli
   class ThorCommand < Thor
      include Thor::Actions

      desc "pluck error_id path", "retrieves and lists a single attribute from all notices of an error"
      method_option :all, :type => :boolean, :aliases => "-a", :desc => "display all data for an object, not just it's keys"
      def pluck(error_id, path="")
         configure!

         parts = path.gsub("\\.", "\0").split(".").map {|x| x.gsub("\0", ".") }

         AirbrakeAPI.notices(error_id).each do |notice|
            # sometimes the api returns a nil notice, not sure why, this guards against that
            if notice == nil
               puts "<missing data>"
               next
            end

            # if left a blank string only display the keys of the root node, 
            # otherwise look down the path and retrieve that data
            if parts.empty?
               match = options[:all] ? notice : notice.keys
            else
               match = parts.inject(notice) {|node, part| node ? node[part] : nil }
            end

            case match
               when String, Fixnum, Float, BigDecimal
                  puts match.to_s
               when Hashie::Mash
                  if options[:all]
                     puts match.to_hash.inspect
                  else
                     puts match.to_hash.keys.inspect
                  end
               else
                  puts match.inspect
            end
         end
      end

   private

      def configure!
         if not Configuration.configured?
            say "Looks like we need to set up your api details...one sec!"

            Configuration.account = ask "account name:"
            Configuration.auth_token = ask "API token:"
            Configuration.secure = yes? "Use a secure connection? (yes or no): "

            say "alright all done! lets move on..."
         end

         Configuration.configure_api_client!
      end
   end
end