class AddUserReferenceToDirectory < ActiveRecord::Migration[7.0]
  def change
    add_reference :directories, :parent, index: true
  end
end
