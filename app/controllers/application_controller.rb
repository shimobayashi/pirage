class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def whitelist
    if Rails.env.production?
      ips = ENV['WHITELIST'] ? ENV['WHITELIST'].split(' ') : []
      unless ips.include?(request.remote_ip)
        render(:text => 'access denied', :status => :unauthorized) unless user_signed_in?
      end
    end
  end
end
