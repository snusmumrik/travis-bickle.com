class TransferSlip < ActiveRecord::Base
  belongs_to :report
  attr_accessible :credit, :credit_amount, :debit, :debit_amount, :note,  :report_id
end
