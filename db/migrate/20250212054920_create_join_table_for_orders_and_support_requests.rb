class CreateJoinTableForOrdersAndSupportRequests < ActiveRecord::Migration[8.0]
  # need to ensure before running the up migration
  # - the has_and_belongs_to_many relationships are on the models
  # - the inverse relationships of belongs_to and has_many are removed from the models
  def up
    # remove the foreign key order_id from support_requests
    remove_column :support_requests, :order_id
    # add the join table
    create_join_table :orders, :support_requests do |t|
      t.index :order_id
    end
    add_index :orders_support_requests, [ :support_request_id, :order_id ], unique: true
    # add join records based on email
    orders = Order.all
    support_requests = SupportRequest.all
    # this is a small enough data set that this will work. It would not scale.
    support_requests.each do |support_request|
      support_request.orders << orders.where(email: support_request.email)
      support_request.save!
    end
  end

  # need to ensure before running the up migration
  # - the inverse relationships of belongs_to and has_many are restored to the models
  # - the has_and_belongs_to_many relationships are removed from the models
  def down
    # remove the join table
    drop_table :orders_support_requests
    # add the foreign key order_id back to support_requests
    add_reference :support_requests, :order, foreign_key: true, comment: "their most recent order, if applicable"
    # update support requests to match last order if applicable
    orders = Order.order(created_at: :desc)
    support_requests = SupportRequest.all
    # this is a small enough data set that this will work. It would not scale.
    support_requests.each do |support_request|
      support_request.order = orders.where(email: support_request.email).first
      support_request.save!
    end
  end
end
