# frozen_string_literal: true

RSpec.describe SocialMiner::Mapper do
  let(:test_mapper) do
    Class.new(described_class) do
      map "id", to: :user_id
      map %w[profile name], to: :full_name
      map "age", to: :age, optional: true
      map "created_at", to: :timestamp do |val|
        Time.at(val)
      end
    end
  end

  describe ".call" do
    let(:attributes) do
      {
        "id" => 123,
        "profile" => { "name" => "John Doe" },
        "created_at" => 1_634_567_890
      }
    end

    it "maps attributes correctly" do
      result = test_mapper.call(attributes)

      expect(result).to include(
        user_id: 123,
        full_name: "John Doe",
        timestamp: Time.at(1_634_567_890)
      )
    end

    it "handles optional attributes" do
      result = test_mapper.call(attributes)
      expect(result[:age]).to be_nil
    end
  end
end
