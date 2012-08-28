class RegistrationsController < Devise::RegistrationsController
  before_filter :whitelist

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
