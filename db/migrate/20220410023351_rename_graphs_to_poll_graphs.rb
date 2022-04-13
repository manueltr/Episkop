class RenameGraphsToPollGraphs < ActiveRecord::Migration[7.0]
  def change
    rename_table :graphs, :poll_graphs
  end
end
