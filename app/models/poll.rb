class Poll < ApplicationRecord
  belongs_to :account
  has_many :vote

  def jsonify_vote_counts
    boy_votes = vote.where(vote: 0).count
    girl_votes = vote.where(vote: 1).count
    votes_hash = {
      boy_votes: boy_votes,
      girl_votes: girl_votes
    }
    votes_hash.to_json
  end
end
