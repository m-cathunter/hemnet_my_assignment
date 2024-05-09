# frozen_string_literal: true

require "spec_helper"

RSpec.describe Package do
  it "validates the presence of name" do
    package = Package.new(name: nil)
    expect(package.validate).to eq(false)
    expect(package.errors[:name]).to be_present
  end
end
