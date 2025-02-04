require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:pickaxe)
    @title = "Stateless Coding"
    @image_file = fixture_file_upload("stateless_logo_256.png", "image/png")
    login_as users(:one)
  end

  test "should not allowed access for public" do
    # logout
    assert_difference("Session.count", -1) do
      delete session_url
    end

    # try the different product routes and ensure no access
    # index
    get products_url
    no_access_assertions!

    # new
    get new_product_url
    no_access_assertions!

    # create
    assert_no_difference("Product.count") do
      post products_url, params: {
        product: {
          description: @product.description, price: @product.price,
          title: @title,
          image: @image_file
        }
      }
    end
    no_access_assertions!

    # show
    get product_url(@product)
    no_access_assertions!

    # edit
    get edit_product_url(@product)
    no_access_assertions!

    # update
    patch product_url(@product), params: {
      product: {
        description: @product.description,
        price: @product.price,
        title: @title,
        image: @image_file
      }
    }
    no_access_assertions!

    # destroy
    assert_no_difference("Product.count") do
      delete product_url(products(:rails_scales))
    end
    no_access_assertions!
  end

  test "should get index" do
    get products_url
    assert_response :success
    assert_select "nav a", minimum: 4
    assert_select "main table tbody tr", 6
    assert_select "main ul li", 18 # 3 per fixture
    assert_select "h1", "Products"
    assert_select "tr td p", /\$[,\d]+\.\d\d/
  end

  test "should get new" do
    get new_product_url
    assert_response :success

    assert_select "h1", "New product"
    assert_select "a", "Back to products"
    form_assertions!
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: {
        product: {
          description: @product.description, price: @product.price,
          title: @title,
          image: @image_file
        }
      }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success

    assert_select "p", /Programming Ruby 3\.3 \(5th Edition\)/
    assert_select "p", /\$33\.95/
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success

    assert_select "h1", "Editing product"
    assert_select "a", "Back to products"
    assert_select "a", "Show this product"
    form_assertions!
  end

  test "should update product" do
    patch product_url(@product), params: {
      product: {
        description: @product.description,
        price: @product.price,
        title: @title,
        image: @image_file
      }
    }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product if no line items" do
    assert_difference("Product.count", -1) do
      delete product_url(products(:rails_scales))
    end

    assert_redirected_to products_url
  end

  test "should fail to destroy product if line items present" do
    assert_raises ActiveRecord::RecordNotDestroyed do
      delete product_url(@product)
    end

    assert Product.exists?(@product.id)
  end

  private
    def form_assertions!
      assert_select "form div label", "Title"
      assert_select "form div label", "Description"
      assert_select "form div label", "Image"
      assert_select "form div label", "Price"
    end

    def no_access_assertions!
      assert_redirected_to new_session_url
      assert_equal "You must login first.", flash[:notice]
    end
end
