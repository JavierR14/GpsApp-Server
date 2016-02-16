class TestController < ApplicationController
  def index
    render json: {hello: :team}
  end
end
