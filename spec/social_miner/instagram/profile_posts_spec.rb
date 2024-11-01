# frozen_string_literal: true

RSpec.describe SocialMiner::Instagram::ProfilePosts do
  let(:user_id) { "user123" }
  let(:success_response) do
    {
      "data" => {
        "user" => {
          "edge_owner_to_timeline_media" => {
            "page_info" => {
              "end_cursor" => "next_page_token"
            },
            "edges" => [
              {
                "node" => {
                  "id" => "post123",
                  "display_url" => "https://example.com/post.jpg",
                  "shortcode" => "ABC123",
                  "taken_at_timestamp" => 1_634_567_890,
                  "edge_media_to_caption" => { "edges" => [{ "node" => { "text" => "Example" } }] }
                }
              }
            ]
          }
        }
      }
    }.to_json
  end

  describe "#call" do
    before do
      stub_request(:get, /#{described_class::GRAPHQL_URL}.*/)
        .with(
          query: hash_including(
            "query_hash" => described_class::QUERY_HASH,
            "variables" => { id: user_id, first: described_class::PER_PAGE }.to_json
          )
        )
        .to_return(status: 200, body: success_response)
    end

    it "fetches and maps posts correctly" do
      result = SocialMiner::Instagram.profile_posts(user_id: user_id)

      expect(result[:cursor]).to eq("next_page_token")
      expect(result[:records]).to contain_exactly(
        include(
          social_id: "post123",
          image_url: "https://example.com/post.jpg",
          shortcode: "ABC123",
          published_at: Time.at(1_634_567_890)
        )
      )
    end

    context "when request fails" do
      before do
        stub_request(:get, /#{described_class::GRAPHQL_URL}.*/)
          .to_return(status: 404, body: "Not Found")
      end

      it "raises an error" do
        expect { SocialMiner::Instagram.profile_posts(user_id: user_id) }
          .to raise_error(Net::HTTPError, /Request Failed 404/)
      end
    end
  end
end