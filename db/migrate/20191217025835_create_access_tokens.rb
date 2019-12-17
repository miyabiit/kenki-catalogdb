class CreateAccessTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :access_tokens do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.string :token, null: false

      t.timestamps null: false
    end
  end
end
