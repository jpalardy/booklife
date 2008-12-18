class UsersController < ApplicationController

  def new
  end

  def create
    @username = params[:username]
    @openid = params[:openid_url]

    user = User.new(:username => @username, :openid => @openid)

    unless user.valid?
      flash[:error] = user.errors.full_messages.first
      render :action => 'new' and return
    end

    # will be used to actually create the user on the way back
    session[:picked_username] = @username

    begin
      request = openid_consumer.begin(user.openid)
    rescue
      flash[:error] = 'invalid openid url'
      render :action => 'new' and return
    end

    if request.send_redirect?(root_url, complete_openid_url)
      redirect_to request.redirect_url(root_url, complete_openid_url) and return
    end
  end

  protected

  def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session, OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid"))
  end

end
