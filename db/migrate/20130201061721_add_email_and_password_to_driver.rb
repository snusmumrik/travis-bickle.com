class AddEmailAndPasswordToDriver < ActiveRecord::Migration
  def change
    add_column :drivers, :email, :string, :after => :name
    add_column :drivers, :password_digest, :string, :after => :email
  end
end
