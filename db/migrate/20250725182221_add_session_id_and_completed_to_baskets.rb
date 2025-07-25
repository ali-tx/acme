class AddSessionIdAndCompletedToBaskets < ActiveRecord::Migration[6.1]
  def change
    add_column :baskets, :session_id, :string
    add_column :baskets, :completed, :boolean, default: false

    # Add index for better performance
    add_index :baskets, :session_id
    add_index :baskets, :completed
  end
end