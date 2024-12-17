class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy

  # could really dive into this
  # - numericality of routing number nine digits
  # - numericality of account number max 17 digits
  # - format of credit card number
  # - format of expriration date
  # - expriration date month cannot be in past (would need handling for making updates to historical orders)
  validates :routing_number, :account_number, presence: true, if: :paid_with_check?
  validates :credit_card_number, :expiration_date, presence: true, if: :paid_with_card?
  validates :po_number, presence: true, if: :paid_with_purchase_order?

  enum :pay_type, {
    "Check"           => 0,
    "Credit card"     => 1,
    "Purchase order"  => 2
  }

  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def paid_with_check?
    pay_type == "Check"
  end

  def paid_with_card?
    pay_type == "Credit card"
  end

  def paid_with_purchase_order?
    pay_type == "Purchase order"
  end
end
