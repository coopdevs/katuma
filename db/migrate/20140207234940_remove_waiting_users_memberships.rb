require_relative '20131109193141_create_waiting_list_memberships'

class RemoveWaitingUsersMemberships < ActiveRecord::Migration
  def change
    revert do
      change_table :waiting_list_memberships do |t|
        t.rename :customer_id, :group_id
      end
    end

    revert CreateWaitingListMemberships
  end
end
