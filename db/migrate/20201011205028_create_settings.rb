class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.boolean :enable_email, default: true
      t.boolean :enable_sms, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
