ActiveAdmin.register Category do
  permit_params :name, :description, :image

  form do |f|
    f.semantic_errors *f.object.errors.full_messages

    f.inputs "Category Details" do
      f.input :name
      f.input :description
      f.input :image, as: :file
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :created_at
      row :updated_at
      row "Image" do |category|
        if category.image.attached?
          image_tag url_for(category.image), size: "100x100"
        else
          "No Image"
        end
      end
    end
  end
end
