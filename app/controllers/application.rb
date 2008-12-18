class ApplicationController < ActionController::Base
  helper :all
  before_filter :check_cache

  protect_from_forgery

  #-------------------------------------------------
  protected
  #-------------------------------------------------

  helper_method :logged_in?, :myself

  def logged_in?
    !session[:username].nil?
  end

  def myself
    session[:username]
  end

  def check_cache
    CACHE.stats
    logger.info "**** CACHE is alive..."
  rescue
    logger.error "**** CACHE is dead!!!"
    CACHE.reset
  end

end
