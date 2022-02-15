class CreateDirectories < ActiveRecord::Migration[7.0]
  def change
    create_table :directories do |t|
      
      t.belongs_to :user
      t.string :name

      t.timestamps
    end
  end
end
