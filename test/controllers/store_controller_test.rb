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
    spanish_store_assertions!
  end

  test "should get index with Pirate locale" do
    get store_index_url(locale: "pirate")

    locale_agnostic_assertions!
    pirate_store_assertions!
  end

  test "should get index and notify with invalid locale" do
    get store_index_url(locale: "klingon")

    locale_agnostic_assertions!
    english_store_assertions!

    # will keep default locale and have notice about unavailable translation
    assert_equal "klingon translation not available", flash[:notice]
  end

  test "should post from locale switcher form" do
    post store_index_url(set_locale: "es")

    # will redirect to Spanish
    assert_redirected_to store_index_url(locale: "es")
    follow_redirect!
    locale_agnostic_assertions!
    spanish_store_assertions!

    post store_index_url(set_locale: "pirate")

    # will redirect to Pirate
    assert_redirected_to store_index_url(locale: "pirate")
    follow_redirect!
    locale_agnostic_assertions!
    pirate_store_assertions!

    post store_index_url(set_locale: "en")

    # will redirect to English
    assert_redirected_to store_index_url(locale: "en")
    follow_redirect!
    locale_agnostic_assertions!
    english_store_assertions!
  end

  test "should notify for bad locale on post request" do
    post store_index_url(set_locale: "klingon")

    # will first attempt to redirect to klingon
    assert_redirected_to store_index_url(locale: "klingon")
    follow_redirect!

    # now similiar to get example above
    locale_agnostic_assertions!
    english_store_assertions!

    # will keep default locale and have notice about unavailable translation
    assert_equal "klingon translation not available", flash[:notice]
  end

  private
    def locale_agnostic_assertions!
      assert_response :success
      assert_select "nav a", minimum: 4
    end

    def english_store_assertions!
      assert_select "h1", "Your Pragmatic Catalog"
      assert_select "h2", "The Pragmatic Programmer"
      assert_select "nav a", "Home"
      assert_select "nav a", "Questions"
      assert_select "nav a", "News"
      assert_select "nav a", "Contact"
      assert_select "button", "Add to Cart"
      assert_select "main ul li", 4
      assert_select "div span.price", /\$[,\d]+\.\d\d/
    end

    def spanish_store_assertions!
      assert_select "h1", "Su Catálogo de Pragmatic"
      assert_select "h2", "Don Quixote"
      assert_select "nav a", "Inicio"
      assert_select "nav a", "Preguntas"
      assert_select "nav a", "Noticias"
      assert_select "nav a", "Contacto"
      assert_select "button", "Añadir al Carrito"
      assert_select "main ul li", 1
      # the non-breaking space isn't matching \s so using .
      assert_select "div span.price", /[\.\d]+,\d\d.\$US/
    end

    def pirate_store_assertions!
      assert_select "h1", "Yer Pragmatic Catalog"
      assert_select "h2", "Treasure Island"
      assert_select "nav a", "Captain's Cabin"
      assert_select "nav a", "Yer Questions"
      assert_select "nav a", "Scuttlebutt"
      assert_select "nav a", "Hollar"
      assert_select "button", "Add to Booty"
      assert_select "main ul li", 1
      assert_select "div span.price", /\A[,\d]+\.\d\d\sUS\spieces\so\'8\z/
    end
end
