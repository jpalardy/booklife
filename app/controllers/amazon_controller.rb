class AmazonController < ApplicationController

  def index
    unless logged_in?
      flash[:notice] = 'please login first'
      redirect_to login_path and return
    end

    @mode = params[:mode] || 'grid'

    if params[:q]
      @books = Book::Amazon.find_all(params[:q])
    end

  end

end
