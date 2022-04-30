class AddAnonymousAndShowResultToPoll < ActiveRecord::Migration[7.0]
  def change

    add_column :polls, :anonymous, :boolean
    add_column :polls, :show_results, :boolean
    
  end
end
