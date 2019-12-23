class ApiTestController < ApplicationController
  skip_authorization_check

  layout 'header_nav_only'

  def index
  end
end
