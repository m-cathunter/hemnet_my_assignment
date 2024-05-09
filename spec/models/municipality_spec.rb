# frozen_string_literal: true

require "spec_helper"

RSpec.describe Municipality do
  it "validates the presence of name" do
    municipality = Municipality.new(name: nil)
    expect(municipality.valid?).to be false
    expect(municipality.errors[:name]).to include("can't be blank")
  end

  it "validates the uniqueness of name" do
    Municipality.create!(name: "Göteborg")
    new_municipality = Municipality.new(name: "Göteborg")

    expect(new_municipality.valid?).to be false
    expect(new_municipality.errors[:name]).to include("has already been taken")
  end
end
