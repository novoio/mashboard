class AddRefreshTokenToSource < ActiveRecord::Migration
  def change
    add_column :sources, :refresh_token, :string
  end
end
