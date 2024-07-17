ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :status, :total_price, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:status, :total_price, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :status, :total_price, :user_id, :province_id

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :total_price
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :user
      row :status
      row :total_price
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :price
      end
    end

    panel "Order Tax" do
      attributes_table_for order.order_tax do
        row :gst
        row :pst
        row :hst
        row :qst
      end
    end
  end

  filter :user
  filter :status
  filter :total_price
  filter :created_at

end
