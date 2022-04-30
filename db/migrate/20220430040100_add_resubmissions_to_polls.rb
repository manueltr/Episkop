class AddResubmissionsToPolls < ActiveRecord::Migration[7.0]
  def change
    add_column :polls, :resubmits, :boolean
  end
end
