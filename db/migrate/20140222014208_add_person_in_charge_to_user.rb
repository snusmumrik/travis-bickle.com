class AddPersonInChargeToUser < ActiveRecord::Migration
  def change
    add_column :users, :person_in_charge, :string, :after => :username
  end
end
