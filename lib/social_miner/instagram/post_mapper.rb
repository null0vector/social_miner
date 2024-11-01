# frozen_string_literal: true

module SocialMiner
  module Instagram
    class PostMapper < Mapper
      map "id",          to: :social_id
      map "display_url", to: :image_url
      map "shortcode",   to: :shortcode

      map %w[location name], to: :location_name, optional: true

      map %w[edge_media_to_caption edges], to: :description do |val|
        edge = val&.first
        edge&.dig("node", "text")
      end

      map "taken_at_timestamp", to: :published_at do |val|
        Time.at(val) if val
      end
    end
  end
end
