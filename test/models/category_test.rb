require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  setup do
    @category = categories(:one)
  end
  
  test "2+2 = 4" do
    assert_equal(4, 2+2, "2+2 should equal 4") 
  end

  test "should create category object and save it to db" do
    category = Category.create(name:"Food", description: "Money spent on food.")
    assert_equal(category.description, Category.find(category.id).description, "There is problem with object creation")
  end

  # Tests model validation
  test "name should be present" do
    category = Category.new(name: "", description: "Some description")
    category.invalid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "name should be unique" do
    category1 = Category.new(name: @category.name, description: @category.description)
    category1.invalid?
    assert_includes category1.errors[:name], "has already been taken"
  end

  test "name should be unique case insensitive" do
    category1 = Category.new(name: @category.name.downcase, description: @category.description)
    category1.invalid?
    assert_includes category1.errors[:name], "has already been taken"
  end

  test "description should be present" do
    @category.description = ""
    @category.valid?
    assert_includes @category.errors[:description], "can't be blank"
  end

end
