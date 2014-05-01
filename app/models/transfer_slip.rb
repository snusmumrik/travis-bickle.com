class TransferSlip < ActiveRecord::Base
  belongs_to :user
  belongs_to :report
  attr_accessible :credit, :credit_amount, :date, :debit, :debit_amount, :note, :report_id, :user_id, :whole_day

  acts_as_paranoid

  validates :debit, :credit, :presence => true
end
