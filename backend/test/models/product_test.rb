require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should not save product without name" do
    product = Product.new(price: 10.0)
    assert_not product.save, "Saved the product without a name"
  end

  test "should not save product with negative price" do
    product = Product.new(name: "Test", price: -5.0)
    assert_not product.save, "Saved the product with a negative price"
  end

  test "should save valid product" do
    product = Product.new(name: "Valid Product", price: 20.0, description: "Sample", available: true)
    assert product.save, "Couldn't save a valid product"
  end

  test "should default available to true" do
    product = Product.new(name: "Check Default", price: 5.0)
    product.save
    assert product.available, "Available did not default to true"
  end
end
