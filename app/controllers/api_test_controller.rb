class ApiTestController < ApplicationController
  skip_authorization_check

  layout 'plane'

  def index
  end
end
