class FixPublishedName < ActiveRecord::Migration[7.0]
  def change
    rename_column :polls, :published, :publish
  end
end
