class CreatePolls < ActiveRecord::Migration[5.1]
  def change
    create_table :polls do |t|
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
