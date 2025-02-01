require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  setup do
    I18n.locale = I18n.default_locale
  end
  teardown do
    I18n.locale = I18n.default_locale
  end

  test "should get index without locale" do
    get store_index_url

    locale_agnostic_assertions!
    english_store_assertions!
  end

  test "should get index with English locale" do
    get store_index_url(locale: "en")

    locale_agnostic_assertions!
    english_store_assertions!
  end

  test "should get index with Spanish locale" do
    get store_index_url(locale: "es")

    locale_agnostic_assertions!
    assert_select "h1", "Su Catálogo de Pragmatic"
    assert_select "nav a", "Inicio"
    assert_select "nav a", "Preguntas"
    assert_select "nav a", "Noticias"
    assert_select "nav a", "Contacto"
    assert_select "button", "Añadir al Carrito"
    # the non-breaking space isn't matching \s so using .
    assert_select "div span.price", /[\.\d]+,\d\d.\$US/
  end

  test "should get index with Pirate locale" do
    get store_index_url(locale: "pirate")

    locale_agnostic_assertions!
    assert_select "h1", "Yer Pragmatic Catalog"
    assert_select "nav a", "Captain's Cabin"
    assert_select "nav a", "Yer Questions"
    assert_select "nav a", "Scuttlebutt"
    assert_select "nav a", "Hollar"
    assert_select "button", "Add to Booty"
    assert_select "div span.price", /\A[,\d]+\.\d\d\sUS\spieces\so\'8\z/
  end

  test "should get index and notify with invalid locale" do
    get store_index_url(locale: "klingon")

    locale_agnostic_assertions!
    english_store_assertions!

    # will keep default locale and have notice about unavailable translation
    assert_equal "klingon translation not available", flash[:notice]
  end

  private
    def locale_agnostic_assertions!
      assert_response :success
      assert_select "nav a", minimum: 4
      assert_select "main ul li", 4
      assert_select "h2", "The Pragmatic Programmer"
    end

    def english_store_assertions!
      assert_select "h1", "Your Pragmatic Catalog"
      assert_select "nav a", "Home"
      assert_select "nav a", "Questions"
      assert_select "nav a", "News"
      assert_select "nav a", "Contact"
      assert_select "button", "Add to Cart"
      assert_select "div span.price", /\$[,\d]+\.\d\d/
    end
end
