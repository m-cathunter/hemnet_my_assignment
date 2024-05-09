require 'rails_helper'

RSpec.describe PriceHistory do
  let!(:package_premium) { Package.create!(name: "Premium") }
  let!(:package_basic) { Package.create!(name: "Basic") }
  let!(:municipality_stockholm) { Municipality.create!(name: "Stockholm") }
  let!(:municipality_goteborg) { Municipality.create!(name: "Göteborg") }

  before do
    # Prices for Premium in Stockholm
    Price.create!(package: package_premium, municipality: municipality_stockholm, amount_cents: 100_00, created_at: "2023-04-01")
    Price.create!(package: package_premium, municipality: municipality_stockholm, amount_cents: 125_00, created_at: "2023-08-02")
    Price.create!(package: package_premium, municipality: municipality_stockholm, amount_cents: 175_00, created_at: "2023-12-24")

    # Prices for Premium in Göteborg
    Price.create!(package: package_premium, municipality: municipality_goteborg, amount_cents: 25_00, created_at: "2022-09-01")
    Price.create!(package: package_premium, municipality: municipality_goteborg, amount_cents: 50_00, created_at: "2023-02-03")
    Price.create!(package: package_premium, municipality: municipality_goteborg, amount_cents: 75_00, created_at: "2023-05-20")

    # Prices for Basic in Göteborg
    Price.create!(package: package_basic, municipality: municipality_goteborg, amount_cents: 100_00, created_at: "2023-06-01")
  end

  describe ".call" do
    context "without specifying a municipality" do
      it "returns price history for all municipalities for the specified year and package" do
        result = PriceHistory.call(year: "2023", package_name: "premium")
        expect(result).to eq({
          "Stockholm" => [100_00, 125_00, 175_00],
          "Göteborg" => [50_00, 75_00]
        })
      end
    end

    context "when specifying a municipality" do
      it "returns price history only for the specified municipality" do
        result = PriceHistory.call(year: "2023", package_name: "premium", municipality_name: "göteborg")
        expect(result).to eq({
          "Göteborg" => [50_00, 75_00]
        })
      end
    end
  end
end
