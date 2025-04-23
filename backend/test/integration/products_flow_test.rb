require "test_helper"

class ProductsFlowTest < ActionDispatch::IntegrationTest
  test "can create, read, update, and delete a product" do
    # Create a product
    post "/products", params: {
      product: {
        name: "Hat",
        description: "A nice sun hat",
        price: 12.99,
        available: true
      }
    }
    assert_response :created
    product = JSON.parse(@response.body)
    id = product["id"]

    # Read the product
    get "/products/#{id}"
    assert_response :success
    assert_equal "Hat", JSON.parse(@response.body)["name"]

    # Update the product
    patch "/products/#{id}", params: {
      product: {
        name: "Sun Hat"
      }
    }
    assert_response :success
    assert_equal "Sun Hat", JSON.parse(@response.body)["name"]

    # Delete the product
    delete "/products/#{id}"
    assert_response :no_content
  end
end