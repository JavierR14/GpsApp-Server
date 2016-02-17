class TestController < ApplicationController
  def index
    render json: {hello: :team}
    render json: {Jitin: :is here}
  end
end
