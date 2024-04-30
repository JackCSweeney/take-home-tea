class CreateSubscription < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :title
      t.float :price
      t.integer :status
      t.integer :frequency

      t.timestamps
    end
  end
end
