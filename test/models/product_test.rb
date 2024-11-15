require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:pickaxe)
    @lorem = { io: File.open("test/fixtures/files/lorem.jpg"),
      filename: "lorem.jpg", content_type: "image/jpeg" }
    @new_product = Product.new(title: "My Book Title", description: "yyy", price: 1)
    @product_with_image = Product.new(title: "My Book Title", description: "zzz", price: 2)
    @product_with_image.image.attach(@lorem)
  end

  test "has valid fixtures" do
    run_model_fixture_tests Product
  end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image].any?
  end

  test "product price must be positive" do
    err_message = "must be greater than or equal to 0.01"
    @product.price = -1
    assert @product.invalid?
    assert_equal [ err_message ], @product.errors[:price]

    @product.price = 0
    assert @product.invalid?
    assert_equal [ err_message ], @product.errors[:price]

    @product.price = 0.004
    assert @product.invalid?
    assert_equal [ err_message ], @product.errors[:price]

    @product.price = 1
    assert @product.valid?
  end

  test "image url" do
    product = @new_product.dup
    product.image.attach(@lorem)
    assert product.valid?, "image/jpeg must be valid"

    product = @new_product.dup
    product.image.attach(io: File.open("test/fixtures/files/logo.svg"),
      filename: "lorem.jpg", content_type: "image/svg+xml")
    assert_not product.valid?, "image/svg+xml must be invalid"
  end

  test "product is not valid without a unique title" do
    @product_with_image.title = @product.title
    assert @product_with_image.invalid?
    assert_equal [ "has already been taken" ], @product_with_image.errors[:title]
  end

  test "product is not valid without a unique title - i18n" do
    @product_with_image.title = @product.title
    assert @product_with_image.invalid?
    assert_equal [ I18n.translate("errors.messages.taken") ],
            @product_with_image.errors[:title]
  end
end
