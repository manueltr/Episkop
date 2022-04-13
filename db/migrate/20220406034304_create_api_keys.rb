class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys do |t|

      t.belongs_to :user, foreign_key: true

      t.string :purpose
      t.boolean :in_req_mode
      t.boolean :accepted
      t.text :explanation

      t.timestamps
    end
  end
end
