# frozen_string_literal: true

module SocialMiner
  module HashExtension
    refine Hash do
      def fetch_nested(*keys)
        val = fetch(keys.shift)
        return val if keys.empty?

        val.fetch_nested(*keys)
      end
    end
  end
end
