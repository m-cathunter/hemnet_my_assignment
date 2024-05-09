# frozen_string_literal: true

class PriceHistory
  def self.call(year:, package_name:, municipality_name: nil)
    prices = Price.joins(:package, :municipality)
                  .where("strftime('%Y', prices.created_at) = ?", year) #for 'PostgreSQL' .where("EXTRACT(YEAR FROM prices.created_at) = ?")
                  .where(packages: { name: package_name.capitalize })
                  .order(:municipality_id, :created_at)

    prices = prices.where(municipalities: { name: municipality_name.capitalize }) if municipality_name

    format_prices(prices)
  end

  private

  def self.format_prices(prices)
    prices.each_with_object({}) do |price, result|
      municipality = price.municipality.name
      result[municipality] ||= []
      result[municipality] << price.amount_cents
    end
  end
end
