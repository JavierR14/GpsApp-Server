class TestController < ApplicationController
  def index
    render json: {hello: :team}
    render "hello, it's Jitin!"
  end
end
