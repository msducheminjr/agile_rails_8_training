require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cart = carts(:sams)
    I18n.locale = I18n.default_locale
  end
  teardown do
    I18n.locale = I18n.default_locale
  end

  test "should get index" do
    login_as users(:sam)
    get carts_url
    assert_response :success
  end

  test "should get new" do
    login_as users(:sam)
    get new_cart_url
    assert_response :success
  end

  test "should create cart" do
    assert_difference("Cart.count") do
      post carts_url, params: { cart: {} }
    end

    assert_redirected_to cart_url(Cart.last, locale: I18n.locale)
  end

  test "should show cart without locale" do
    login_as users(:one)
    get cart_url(@cart)

    locale_agnostic_cart_assertions!
    english_cart_assertions!
  end

  test "should show cart with English locale" do
    login_as users(:one)
    get cart_url(@cart, locale: "en")

    locale_agnostic_cart_assertions!
    english_cart_assertions!
  end

  test "should show cart with Spanish locale" do
    login_as users(:one)
    get cart_url(@cart, locale: "es")

    locale_agnostic_cart_assertions!
    spanish_cart_assertions!
  end

  test "should show cart with Pirate locale" do
    login_as users(:one)
    get cart_url(@cart, locale: "pirate")

    locale_agnostic_cart_assertions!
    pirate_cart_assertions!
  end

  test "should redirect to catalog if invalid cart" do
    login_as users(:sam)
    get cart_url("notarealid")
    assert_redirected_to store_index_url(locale: I18n.locale)
    assert_equal "Invalid cart", flash[:notice]
  end

  test "should get edit" do
    login_as users(:sam)
    get edit_cart_url(@cart)
    assert_response :success
  end

  test "should update cart" do
    patch cart_url(@cart), params: { cart: {} }
    assert_redirected_to cart_url(@cart, locale: I18n.locale)
  end

  test "should destroy cart" do
    post line_items_url, params: { product_id: products(:pragprog).id }
    @cart = Cart.find(session[:cart_id])
    assert_difference("Cart.count", -1) do
      delete cart_url(@cart)
    end

    assert_redirected_to store_index_url(locale: I18n.locale)
    assert_equal "Your cart is currently empty", flash[:notice]
  end

  test "should fail to destroy another user's cart" do
    assert_no_difference("Cart.count") do
      delete cart_url(@cart)
    end

    assert_redirected_to store_index_url(locale: I18n.locale)
    assert_equal "Invalid cart", flash[:notice]
  end

  private
    def locale_agnostic_cart_assertions!
      assert_response :success
      # use main to avoid sidebar cart duplication selection
      # two line items and the total
      assert_select "main table tr", 3
    end

    def english_cart_assertions!
      assert_select "h2", "Your Cart"
      assert_select "table tfoot tr th", "Total:"
      assert_select "button", "Empty Cart"
      assert_select "button", "Checkout"
      assert_select "tbody tr td.font-bold", "$33.95"
      assert_select "tbody tr td.font-bold", "$39.99"
      assert_select "tfoot tr td.font-bold", "$73.94"
    end

    def spanish_cart_assertions!
      assert_select "h2", "Carrito de la Compra"
      assert_select "table tfoot tr th", "Total:"
      assert_select "button", "Vaciar Carrito"
      assert_select "button", "Comprar"
      assert_select "main table tr td.font-bold", /32,59.€/
      assert_select "main table tr td.font-bold", /38,39.€/
      assert_select "main tfoot tr td.font-bold", /70,98.€/
    end

    def pirate_cart_assertions!
      assert_select "h2", "Yer Cart"
      assert_select "table tfoot tr th", "Yer Total:"
      assert_select "button", "Scuttle Cart"
      assert_select "button", "Checkout! Arrr!"
      assert_select "main table tr td.font-bold", "271.60 pieces o'8"
      assert_select "main table tr td.font-bold", "319.92 pieces o'8"
      assert_select "main tfoot tr td.font-bold", "591.52 pieces o'8"
    end
end
