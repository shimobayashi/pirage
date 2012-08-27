class RegistrationsController < Devise::RegistrationsController
  before_filter :whitelist

  def whitelist
    if Rails.env.production?
      ips = ENV['WHITELIST'] ? ENV['WHITELIST'].split(' ') : []
      unless ips.include?(request.remote_ip)
        render(:text => 'access denied', :status => :unauthorized) unless user_signed_in?
      end
    end
  end

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end
end
