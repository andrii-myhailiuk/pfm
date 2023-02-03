require "test_helper"

class OperationTest < ActiveSupport::TestCase
  setup do
    @operation = operations(:one)
    @category = categories(:two)
  end

  test "should create operation object and save it to db" do
    operation = Operation.create(
      amount: 5.99, description: "Test description", 
      otype: "income", odate: "2022-12-31", category: @category)
    assert_equal(operation.description, Operation.find(operation.id).description)
  end

  test "shouldn't create operation object without category" do
    operation = Operation.new(
      amount: 5.99, description: "Test description", 
      otype: "income", odate: "2022-12-31")
    operation.valid?
    assert_includes(operation.errors[:category], "must exist")
  end

  # Testing Operation validation
  test "shouldn't create operation with amount less than zero" do
    operation = Operation.new(
      amount: -5.99, description: "Test description", 
      otype: "income", odate: "2022-12-31", category: @category)
    operation.valid?
    assert_includes(operation.errors[:amount], "must be greater than 0")
  end

  test "shouldn't create operation with non numerical amount" do
    operation = Operation.new(
      amount: "A lot", description: "Test description", 
      otype: "income", odate: "2022-12-31", category: @category)
    operation.valid?
    assert_includes(operation.errors[:amount], "is not a number")
  end

  test "shouldn't create operation without date" do
    operation = Operation.new(
      amount: 5.99, description: "Test description", 
      otype: "income", category: @category)
    operation.valid?
    assert_includes(operation.errors[:odate], "can't be blank")
  end

  test "shouldn't create operation without description" do
    operation = Operation.new(
      amount: 5.99, description: "", 
      otype: "income", odate: "2022-12-31", category: @category)
    operation.valid?
    assert_includes(operation.errors[:description], "can't be blank")
  end

  test "shouldn't create operation without operation type" do
    operation = Operation.new(
      amount: 5.99, description: "Test description", 
      otype: "", odate: "2022-12-31", category: @category)
    operation.valid?
    assert_includes(operation.errors[:otype], "can't be blank")
  end

  test "should raise exception if wrong operation type was given" do
    assert_raises(ArgumentError) do
      operation = Operation.new(
        amount: 5.99, description: "Test description", 
        otype: "wrong type", odate: "2022-12-31", category: @category)
    end
  end

  # Testing delete / update
  test "should update existing operation" do
    updated_description = "Updated description"
    @operation.description = updated_description
    @operation.save
    assert_equal(Operation.find(@operation.id).description, updated_description)
  end

  test "should delete existing model" do
    number_of_operations = Operation.count
    @operation.delete
    # assert_raises
    assert_equal(number_of_operations-1, Operation.count)
  end

end
