class TestController < ApplicationController
  def index
      render json: {hello: :team, jitin: :isHere}
  end
end
