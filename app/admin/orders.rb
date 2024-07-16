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
    column :status
    column :total_price
    column :user
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: ['new', 'paid', 'shipped']
      f.input :total_price
      f.input :user
      f.input :province
    end
    f.actions
  end

end
