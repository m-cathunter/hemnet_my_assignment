require "spec_helper"

RSpec.describe UpdatePackagePrice do
  it "updates the current price of the provided package for the given municipality" do
    package = Package.create!(name: "Basic")
    municipality_goteborg = Municipality.create!(name: "Göteborg")
    municipality_stockholm = Municipality.create!(name: "Stockholm")

    UpdatePackagePrice.call(package, 200_00, municipality_goteborg)
    UpdatePackagePrice.call(package, 150_00, municipality_stockholm)

    expect(package.latest_price(municipality_goteborg)).to eq(200_00)
    expect(package.latest_price(municipality_stockholm)).to eq(150_00)
  end

  it "only updates the passed package price" do
    municipality = Municipality.create!(name: "Göteborg")

    package = Package.create!(name: "Premium")
    package.prices.create!(amount_cents: 100_00, municipality: municipality)

    other_package = Package.create!(name: "Basic")
    other_package.prices.create!(amount_cents: 100_00, municipality: municipality)

    expect {
      UpdatePackagePrice.call(package, 200_00, municipality)
    }.not_to change {
      other_package.latest_price(municipality)
    }
  end

  it "stores the old price of the provided package in its price history" do
    municipality = Municipality.create!(name: "Stockholm")

    package = Package.create!(name: "Premium")
    package.prices.create!(amount_cents: 100_00, municipality: municipality, created_at: "2023-04-01")

    UpdatePackagePrice.call(package, 200_00, municipality)

    price_first = package.prices.where(municipality: municipality).order(:created_at).first.amount_cents
    price_last = package.latest_price(municipality)
    expect(price_first).to eq(100_00)
    expect(price_last).to eq(200_00)
  end
end
