# frozen_string_literal: true

class UpdatePackagePrice
  def self.call(package, new_price_cents, municipality, **options)
    Package.transaction do
      Price.create!(package: package, amount_cents: new_price_cents, municipality: municipality)
    end
  end
end
