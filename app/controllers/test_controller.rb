class TestController < ApplicationController
  def index
    render json: {hello: :team}
    puts "hello"
  end
end
