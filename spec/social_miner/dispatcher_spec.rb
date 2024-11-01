# frozen_string_literal: true

RSpec.describe SocialMiner::Dispatcher do
  let(:test_class) do
    Class.new do
      attr_reader :request_options

      def initialize(**request_options)
        @request_options = request_options
      end

      def call(**args)
        { request_options: request_options, args: args }
      end
    end
  end

  describe ".call" do
    context "when request_options is empty" do
      it "initializes class without options" do
        result = described_class.call(test_class, request_options: {}, test_arg: "value")

        expect(result).to eq(
          request_options: {},
          args: { test_arg: "value" }
        )
      end
    end

    context "when request_options is provided" do
      it "initializes class with options" do
        result = described_class.call(
          test_class,
          request_options: { header: "Custom-Header" },
          test_arg: "value"
        )

        expect(result).to eq(
          request_options: { header: "Custom-Header" },
          args: { test_arg: "value" }
        )
      end
    end

    context "when additional arguments are provided" do
      it "passes them to the call method" do
        result = described_class.call(
          test_class,
          request_options: {},
          arg1: "value1",
          arg2: "value2"
        )

        expect(result).to eq(
          request_options: {},
          args: { arg1: "value1", arg2: "value2" }
        )
      end
    end
  end
end
