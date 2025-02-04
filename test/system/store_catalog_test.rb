require "application_system_test_case"

class StoreCatalogTest < ApplicationSystemTestCase
  setup do
    I18n.locale = I18n.default_locale
  end
  teardown do
    I18n.locale = I18n.default_locale
  end

  test "visiting the home page" do
    visit "/"
    store_index_english_assertions!
  end

  test "adding first item to cart and emptying cart in English" do
    @first_product = Product.where(locale: "en").order(:title).first
    visit store_index_path(locale: "en")
    store_index_english_assertions!
    click_on "Add to Cart", match: :first
    assert_selector "div h2", text: "Your Cart"
    assert_selector "div table tr.line-item-highlight td", text: @first_product.title
    click_on "Empty Cart"
    assert_text "Your cart is currently empty"
  end


  test "adding first item to cart and emptying cart in Spanish" do
    @first_product = Product.where(locale: "es").order(:title).first
    visit store_index_path(locale: "es")
    store_index_spanish_assertions!

    click_on "Añadir al Carrito", match: :first
    assert_selector "div h2", text: "Carrito de la Compra"
    assert_selector "div table tr.line-item-highlight td", text: @first_product.title
    click_on "Vaciar Carrito"
    assert_text "Su carrito está vacío"
  end

  test "adding first item to cart and emptying cart in Pirate" do
    @first_product = Product.where(locale: "pirate").order(:title).first
    visit store_index_path(locale: "pirate")
    store_index_pirate_assertions!

    click_on "Add to Booty", match: :first
    assert_selector "div h2", text: "Yer Cart"
    assert_selector "div table tr.line-item-highlight td", text: @first_product.title
    click_on "Scuttle Cart"
    assert_text "Arrrr, yer cart be scuttled..."
  end

  test "using the locale switcher" do
    # starts in English
    visit store_index_path
    store_index_english_assertions!

    # Spanish
    select "Español", from: "set_locale"
    store_index_spanish_assertions!

    # Pirate
    select "Pirate", from: "set_locale"
    store_index_pirate_assertions!

    # Back to English
    select "English", from: "set_locale"
    store_index_english_assertions!
  end

  private
    def store_index_english_assertions!
      assert_selector "h1", text: "Your Pragmatic Catalog"
      assert_selector "h2", text: "The Pragmatic Programmer"
      assert_selector "h2", text: "Rails Scales!"
      assert_selector "h2", text: "Programming Ruby 3.3 (5th Edition)"
      assert_selector "h2", text: "Modern Front-End Development for Rails, Second Edition"
      assert_selector "nav a", text: "Home"
      assert_selector "nav a", text: "Questions"
      assert_selector "nav a", text: "News"
      assert_selector "nav a", text: "Contact"
    end

    def store_index_spanish_assertions!
      assert_selector "h1", text: "Su Catálogo de Pragmatic"
      assert_selector "h2", text: "Don Quixote"
      assert_selector "nav a", text: "Inicio"
      assert_selector "nav a", text: "Preguntas"
      assert_selector "nav a", text: "Noticias"
      assert_selector "nav a", text: "Contacto"
      assert_text "Añadir al Carrito"
    end

    def store_index_pirate_assertions!
      assert_selector "h1", text: "Yer Pragmatic Catalog"
      assert_selector "h2", text: "Treasure Island"
      assert_selector "nav a", text: "Captain's Cabin"
      assert_selector "nav a", text: "Yer Questions"
      assert_selector "nav a", text: "Scuttlebutt"
      assert_selector "nav a", text: "Hollar"
      assert_text "Add to Booty"
    end
end
