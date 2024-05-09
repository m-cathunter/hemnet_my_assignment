# frozen_string_literal: true

class Package < ApplicationRecord
  has_many :prices, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def latest_price(municipality)
    prices.where(municipality: municipality).order(:created_at).last&.amount_cents
  end
end
