class CreateGraphs < ActiveRecord::Migration[7.0]
  def change
    create_table :graphs do |t|

      t.belongs_to :poll
      t.string :graph_type
      t.string :questions
      t.timestamps
      
    end
  end
end
