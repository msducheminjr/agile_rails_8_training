class StoreController < ApplicationController
  before_action :increment_counter

  def index
    @products = Product.order(:title)
    @visit_count = session[:counter]
  end

  private
    def increment_counter
      session[:counter] = 0 if session[:counter].nil?
      session[:counter] += 1
    end
end
