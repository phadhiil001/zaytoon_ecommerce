ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :price, :category_id, :options, :served_with, :pieces, :extra
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :category_id, :options, :served_with, :pieces, :extra]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :name, :description, :price, :category_id, :options, :served_with, :pieces, :extra, images: []

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :category
      f.input :options
      f.input :served_with
      f.input :pieces
      f.input :extra
      f.input :images, as: :file, input_html: { multiple: true }
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :category
      row :options
      row :served_with
      row :pieces
      row :extra
      row :images do |product|
        ul do
          product.images.each do |image|
            li do
              image_tag url_for(image)
            end
          end
        end
      end
    end
    active_admin_comments
  end
end
