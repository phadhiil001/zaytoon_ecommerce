class ContactController < ApplicationController
  def show
    @page = Page.find_by(slug: 'contact')
    if @page
      render template: "pages/show"
    else
      redirect_to root_path, alert: "Contact page not found"
    end
  end
end
