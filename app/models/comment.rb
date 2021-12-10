class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :comment, length: { minimum: 6, maximum: 300 }
end
