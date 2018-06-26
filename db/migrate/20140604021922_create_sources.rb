class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.integer :user_id
      t.string :oauth_token
      t.string :oauth_secret
      t.datetime :oauth_expires_at

      t.timestamps
    end
  end
end
