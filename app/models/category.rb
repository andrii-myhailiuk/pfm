class Category < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :description, presence: true
end
