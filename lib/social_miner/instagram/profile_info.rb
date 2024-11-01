# frozen_string_literal: true

module SocialMiner
  module Instagram
    class ProfileInfo < Base
      using HashExtension

      URL = "#{API_URL}/users/web_profile_info/".freeze

      def call(username:, mapper: ProfileMapper)
        uri = URI(URL)
        uri.query = URI.encode_www_form([
                                          [:username, username]
                                        ])

        response = Net::HTTP.get_response(uri, request_headers)

        case response
        when Net::HTTPSuccess
          JSON.parse(response.body)
              .then { |data|  data.fetch_nested("data", "user") }
              .then { |attrs| mapper.call(attrs) }
        else
          raise Net::HTTPError.new("Request Failed #{response.code}", response)
        end
      end
    end
  end
end
