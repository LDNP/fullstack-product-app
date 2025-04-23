require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = Product.create!(
      name: "Test Product",
      description: "Sample description",
      price: 10.0,
      available: true
    )
  end

  test "should get index" do
    get products_url, as: :json
    assert_response :success
    assert_includes @response.body, @product.name
  end

  test "should show product" do
    get product_url(@product), as: :json
    assert_response :success
    assert_includes @response.body, @product.description
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: {
        product: {
          name: "New Item",
          description: "A brand new item",
          price: 5.99,
          available: false
        }
      }, as: :json
    end

    assert_response :created
  end

  test "should update product" do
    patch product_url(@product), params: {
      product: {
        name: "Updated Name"
      }
    }, as: :json
    assert_response :success
    @product.reload
    assert_equal "Updated Name", @product.name
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product), as: :json
    end
    assert_response :no_content
  end
end