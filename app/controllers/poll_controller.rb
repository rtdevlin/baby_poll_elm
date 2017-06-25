class PollController < ApplicationController
  def show
  end

  def boy
    poll = Poll.find(:id)
    boy_vote = Vote.build(vote: 0)
    boy_vote.save
    render json: poll.jsonify_vote_counts
  end

  def girl
    poll = Poll.find(:id)
    girl_vote = Vote.build(vote: 1)
    girl_vote.save
    render json: poll.jsonify_vote_counts
  end
end
