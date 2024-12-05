class LineItemsController < ApplicationController
  include CurrentCart

  before_action :set_cart, only: %i[ create destroy ]
  before_action :set_line_item, only: %i[ show edit update destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart_or_line_item

  # GET /line_items or /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1 or /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.turbo_stream { @current_item = @line_item }
        format.html { redirect_to store_index_url }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: "Line item was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    unless @cart.id == @line_item.cart_id
      invalid_cart_or_line_item
      return
    end
    title = @line_item.product.title
    result_line_item = @cart.remove_product!(@line_item.product)
    @cart.reload
    notice_text = "Quantity of #{title} was successfully decreased"
    if @cart.line_items.empty?
      notice_text = "Your cart is currently empty"
    elsif result_line_item.destroyed?
      notice_text = "#{title} was successfully removed"
    end
    respond_to do |format|
      format.html { redirect_to store_index_url, status: :see_other, notice: notice_text }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.expect(line_item: [ :product_id ])
    end

    def invalid_cart_or_line_item
      logger.error "Attempt to access invalid cart or line_item #{params}"
      redirect_to store_index_url, notice: "Invalid cart or line item"
    end
end
