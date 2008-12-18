class OwnershipsController < ApplicationController
  before_filter :set_vars, :validate_isbn, :find_user
  before_filter :find_ownership, :only => [:show, :edit, :update, :destroy]
  before_filter :check_ownership, :only => [:edit, :update, :destroy]
  before_filter :authorize, :except => [:index, :show]
  after_filter :save_location

  ############################################################

  def index
    respond_to do |format|
      format.html do
        @mode = params[:mode] || 'grid'

        case
        when params[:q]
          @status = 'all'
          @ownerships = @user.ownerships.find_with_ferret(params[:q])
        when params[:status] == 'all'
          @status = params[:status]
          @ownerships = @user.ownerships.all(:include => :book)
        else
          @status = params[:status] || 'in progress'
          @ownerships = @user.ownerships.find_all_by_status(@status, :include => :book)
        end
      end

      format.atom do
        @events = @user.events.all(:order => 'created_at DESC', :limit => 50, :include => ['user', 'book'])
      end
    end
  end

  ############################################################

  def show
    unless @ownership
      redirect_to new_ownership_path(@username, :isbn => @isbn) and return
    end
  end

  ############################################################

  def edit
  end

  ############################################################

  def update
    old_status = @ownership.status

    if @ownership.update_attributes(:status => params[:status])
      flash[:success] = "status updated from '#{old_status}' to '#{params[:status]}'"
      redirect_to ownership_path(@username, @isbn)
    else
      flash[:error] = "invalid status #{params[:status]}"
      redirect_to edit_ownership_path(@username, @isbn)
    end
  end

  ############################################################

  def destroy
    @ownership.destroy
    flash[:success] = "book #{@template.link_to @isbn, ownership_path(@username, @isbn)} successfully deleted"
    redirect_to ownerships_path(:status => @ownership.status)
  end

  ############################################################

  def new
    book = Book::Amazon.find_by_isbn(@isbn)

    unless book
      flash[:error] = "could not find that book"
      redirect_to ownerships_path(@username) and return
    end

    @ownership = @user.ownerships.new(:book => book, :status => 'heard of')
  end

  ############################################################

  def create
    book = Book.find_by_isbn(@isbn) || Book::Amazon.find_by_isbn(@isbn)

    unless book
      flash[:error] = "could not find that book"
      redirect_to ownerships_path(@username) and return
    end

    ownership = @user.ownerships.new(:book => book, :status => params[:status])

    if ownership.save
      flash[:success] = "book added with status '#{params[:status]}'"
      redirect_to ownership_path(@username, @isbn)
    else
      flash[:error] = "invalid status '#{params[:status]}'"
      redirect_to new_ownership_path(@username, :isbn => @isbn)
    end
  end

  ############################################################
  private
  ############################################################

  def set_vars
    @username = params[:username]
    @isbn = params[:isbn] || params[:id]
  end

  #-------------------------------------------------

  def validate_isbn
    if @isbn && !RBook::ISBN::valid_isbn?(@isbn)
      flash[:error] = "invalid ISBN #{@isbn}"
      redirect_to ownerships_path(@username)
    end
  end

  #-------------------------------------------------

  def find_user
    @user = User.find_by_username(@username)

    unless @user
      flash[:error] = "user #{@username} does not exist"
      redirect_to login_path
    end
  end

  #-------------------------------------------------

  def find_ownership
    @ownership = @user.ownerships.find_by_isbn(@isbn, :include => :book)
    @status = @ownership.status if @ownership
  end

  def check_ownership
    unless @ownership
      flash[:error] = "you do not own that book"
      redirect_to ownerships_path(@username)
    end
  end

  #-------------------------------------------------

  def authorize
    unless logged_in? && myself == @username
      flash[:error] = "unauthorized access"
      redirect_to ownerships_path(@username)
    end
  end

  #-------------------------------------------------

  def save_location
    session[:previous_location] = request.url
  end

end
