# frozen_string_literal: true

module SocialMiner
  module Instagram
    class ProfilePosts < Base
      using HashExtension

      PER_PAGE = 12
      QUERY_HASH = "69cba40317214236af40e7efa697781d"

      def call(user_id:, cursor: nil, mapper: PostMapper)
        uri = URI(GRAPHQL_URL)

        variables = { id: user_id, first: PER_PAGE }
        variables[:after] = cursor if cursor

        uri.query = URI.encode_www_form([
                                          [:query_hash, QUERY_HASH],
                                          [:variables, variables.to_json]
                                        ])

        response = Net::HTTP.get_response(uri, request_headers)

        case response
        when Net::HTTPSuccess
          response_data  = JSON.parse(response.body)
          timeline_media = response_data.fetch_nested(
            "data",
            "user",
            "edge_owner_to_timeline_media"
          )

          {
            cursor: timeline_media.fetch_nested("page_info", "end_cursor"),
            records: timeline_media.fetch("edges")
                                   .map  { |attrs| attrs.fetch("node") }
                                   .map  { |attrs| mapper.call(attrs) }
          }
        else
          raise Net::HTTPError.new("Request Failed #{response.code}", response)
        end
      end
    end
  end
end
