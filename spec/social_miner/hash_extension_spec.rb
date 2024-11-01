# frozen_string_literal: true

RSpec.describe SocialMiner::HashExtension do
  using described_class

  describe "#fetch_nested" do
    let(:hash) do
      {
        "data" => {
          "user" => {
            "profile" => {
              "name" => "John Doe"
            }
          }
        }
      }
    end

    it "fetches nested value successfully" do
      expect(hash.fetch_nested("data", "user", "profile", "name")).to eq("John Doe")
    end

    it "raises KeyError when key does not exist" do
      expect { hash.fetch_nested("data", "invalid", "name") }.to raise_error(KeyError)
    end
  end
end
