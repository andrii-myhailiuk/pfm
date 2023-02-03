class Operation < ApplicationRecord
  belongs_to :category
  validates :amount, numericality: { greater_than: 0 }
  validates :odate, presence: true
  validates :description, presence: true
  validates :otype, presence: true

  enum otype: {
    income: 10,
    passive_income: 20,
    special_income: 30,
    expense: 40,
    special_expense: 50,
    state_expense: 60,
    charity: 70
  }

end
