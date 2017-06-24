class Poll < ApplicationRecord
  belongs_to :account
  has_many :vote
end
