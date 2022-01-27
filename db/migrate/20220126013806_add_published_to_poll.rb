class AddPublishedToPoll < ActiveRecord::Migration[7.0]
  def change
    add_column :polls, :published, :boolean
  end
end
