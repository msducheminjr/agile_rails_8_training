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
      assert_select "div", /\$[,\d]+\.\d\d/
    end

    def english_store_assertions!
      assert_select "h1", "Your Pragmatic Catalog"
      assert_select "h2", "The Pragmatic Programmer"
      assert_select "nav a", "Home"
      assert_select "nav a", "Questions"
      assert_select "nav a", "News"
      assert_select "nav a", "Contact"
    end
end
