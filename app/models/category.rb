class Category < ApplicationRecord
  has_many :operations, dependent: :destroy
  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :description, presence: true
end
