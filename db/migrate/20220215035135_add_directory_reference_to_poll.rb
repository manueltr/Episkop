class AddDirectoryReferenceToPoll < ActiveRecord::Migration[7.0]
  def change
    add_reference :polls, :directory, index: true
  end
end
