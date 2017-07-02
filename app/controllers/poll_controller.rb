class PollController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
  end

  def votes
    poll = Poll.find(params[:id])
    render json: poll.jsonify_vote_counts
  end

  def boy
    poll = Poll.find(params[:id])
    boy_vote = poll.vote.new(vote: 0)
    boy_vote.save!
    render json: poll.jsonify_vote_counts
  end

  def girl
    poll = Poll.find(params[:id])
    girl_vote = poll.vote.new(vote: 1)
    girl_vote.save!
    render json: poll.jsonify_vote_counts
  end
end
