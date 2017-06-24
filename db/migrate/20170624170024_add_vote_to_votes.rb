class AddVoteToVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :vote, :integer
  end
end
