class SessionController < ApplicationController

  def new
    @users = User.find(:all, :order => 'username')
  end

  def create
    user = User.find_by_username(params[:username])

    unless user
      flash[:error] = "No user with username: '#{params[:username]}'."
      redirect_to login_path and return
    end

    request = openid_consumer.begin(user.openid)

    if request.send_redirect?(root_url, complete_openid_url)
      redirect_to request.redirect_url(root_url, complete_openid_url) and return
    end
  end

  def complete
    response = openid_consumer.complete(params.reject{|k,v|request.path_parameters[k]}, complete_openid_url)

    if response.status == OpenID::Consumer::SUCCESS
      user = User.find_by_openid(response.identity_url)

      unless user
        if session[:picked_username]
          user = User.create(:username => session[:picked_username], :openid => response.identity_url)
          flash[:success] = "Successfully created user '#{user.username}'."
        else
          flash[:error] = "No user associated with the url: '#{response.identity_url}'."
          redirect_to login_path and return
        end
      end

      session[:username] = user.username
      flash[:success] ||= 'Successfully logged in.'
      redirect_to session[:previous_location] || ownerships_path(session[:username]) and return
    end

    flash[:error] = 'Could not log on with your OpenID.'
    redirect_to login_path
  end

  def destroy
    reset_session
    flash[:success] = 'Successfully logged out.'
    redirect_to login_path
  end

  protected

  def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session, OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid"))
  end

end
