class TestsController < ApplicationController
  skip_authorization_check

  def test
    case current_user
    when Administrator
      redirect_to companies_url
    when Staff
      redirect_to products_url
    end
  end
end
