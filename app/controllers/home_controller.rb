class HomeController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.all.limit(10)
  end
end
