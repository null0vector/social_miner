# frozen_string_literal: true

module SocialMiner
  module Instagram
    class PostComments < Base
      using HashExtension

      DOC_ID = "8845758582119845"

      def call(post_shortcode:, cursor: nil, mapper: CommentMapper)
        variables = { shortcode: post_shortcode }
        variables[:after] = cursor if cursor

        data = {
          "variables" => { shortcode: post_shortcode }.to_json,
          "doc_id" => DOC_ID
        }

        response = Net::HTTP.post_form(URI(GRAPHQL_URL), data)

        case response
        when Net::HTTPSuccess
          response_data = JSON.parse(response.body)
          edge_media = response_data.fetch_nested(
            "data",
            "xdt_shortcode_media",
            "edge_media_to_parent_comment"
          )

          {
            cursor: edge_media.fetch_nested("page_info", "end_cursor")
                              .then { |data| JSON.parse(data) }
                              .then { |data| data.fetch("server_cursor") },
            records: edge_media.fetch("edges").map { |edge| mapper.call edge.fetch("node") }
          }
        else
          raise Net::HTTPError.new("Request Failed #{response.code}", response)
        end
      end
    end
  end
end
