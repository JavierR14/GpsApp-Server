class ApiController < ApplicationController
	# http_basic_authenticate_with email:ENV["API_AUTH_EMAIL"], :only => [:signup, :signin, :get_token]
	#make sure any request that is not a signup, signin, or get_token has it's authtoken checked
	before_filter :check_for_valid_authtoken, :except => [:signup, :signin, :get_token, :post_location]

	def signin
	  if request.post?
	    if params && params[:email]
	      user = User.find_by(email: params[:email])

	      unless user
	      	user = User.new(first_name: params[:name].split(" ").first,
	      	 last_name: params[:name].split(" ").last, email: params[:email], profile_pic: params[:image])
	      end

	      if !user.authtoken || (user.authtoken && user.authtoken_expiry < Time.now)
	        auth_token = rand_string(20)
	        auth_expiry = Time.now + (24*60*60)
	        user.update_attributes(:authtoken => auth_token, :authtoken_expiry => auth_expiry)
	      end

	      render :json => user.to_json(:only => [:authtoken, :authtoken_expiry]), :status => 200
	    else
	      e = Error.new(:status => 400, :message => "No user record found for this email ID - signin.")
	      render :json => e.to_json, :status => 400
	    end
	  end
	end

	def get_token
	  if params && params[:email]
	    user = User.find_by(email: params[:email])
	    if user
	      if user.authtoken.nil? || (user.authtoken && user.authtoken_expiry < Time.now)
	        auth_token = rand_string(20)
	        auth_expiry = Time.now + (24*60*60)

	        user.update_attributes(:authtoken => auth_token, :authtoken_expiry => auth_expiry)
	      end

	      render :json => user.to_json(:only => [:authtoken, :authtoken_expiry]), :status => 200
	    else
	      e = Error.new(:status => 400, :message => "No user record found for this email ID - get_token.")
	      render :json => e.to_json, :status => 400
	    end

	  else
	    e = Error.new(:status => 400, :message => "required parameters are missing")
	    render :json => e.to_json, :status => 400
	  end
	end

	def clear_token
	  if @user.authtoken && @user.authtoken_expiry > Time.now
	    @user.update_attributes(:authtoken => nil, :authtoken_expiry => nil)

	    m = Message.new(:status => 200, :message => "Token cleared")
	    render :json => m.to_json, :status => 200
	  else
	    e = Error.new(:status => 401, :message => "You don't have permission to do this task - clear_token.")
	    render :json => e.to_json, :status => 401
	  end
	end


	def check_for_valid_authtoken
	  authenticate_or_request_with_http_token do |token, options|
	    @user = User.find_by(authtoken: token)
	  end
	end

	def rand_string(len)
	  o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
	  string  =  (0..len).map{ o[rand(o.length)]  }.join

	  return string
	end

	def user_params
	  params.require(:user).permit(:first_name, :last_name, :email, :authtoken, :authtoken_expiry)
	end

	def post_location
		if params && params[:latitude] && params[:longitude] && params[:auth_token]
			lat = params[:latitude]
			long = params[:longitude]
			token = params[:auth_token]

			if lat.abs > 90 || long.abs > 180
				render json: {status:401, message: "Error: Longitude or Latitude are incorrect values"}
			else
				user = User.find_by(authtoken: token)
				unless user == nil
					user.update_attributes(:location_longitude => long, :location_latitude => lat)
					render json: {status:200, message: "long:#{long} - lat:#{lat} - token:#{token} added to db"}
				else
					render json: {status:400, message: "Error: User not found"}
				end
		else
			render json: {status:401, message: "Error: Correct paramters are not given"}
		end
	end

end
