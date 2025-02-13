class SupportRequest < ApplicationRecord
  has_and_belongs_to_many :orders
  has_rich_text :response
end
