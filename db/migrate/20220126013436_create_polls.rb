class CreatePolls < ActiveRecord::Migration[7.0]
  def change
    create_table :polls do |t|

      t.belongs_to :user
      t.string :title
      t.text :summary
      t.boolean :opened
      t.timestamp :ends_at

      t.timestamps
    end
  end
end
