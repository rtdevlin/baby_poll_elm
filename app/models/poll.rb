class Poll < ApplicationRecord
  belongs_to :account
  has_many :vote

  def jsonify_vote_counts
    boy_votes = votes.where(vote: 0)
    girl_votes = votes.where(vote: 1)
    votes_hash = {
      boy_votes: boy_votes,
      girl_votes: girl_votes
    }
    votes_hash.to_json
  end
end
