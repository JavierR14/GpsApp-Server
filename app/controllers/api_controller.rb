class ApiController < ApplicationController
def signup
  if request.post?
    if params && params[:first_name] && params[:last_name] && params[:email]
      params[:user] = Hash.new    
      params[:user][:first_name] = params[:first_name]
      params[:user][:last_name] = params[:last_name]
      params[:user][:email] = params[:email]

      user = User.new(user_params)

      if user.save
        render :json => user.to_json, :status => 200
      else
        error_str = ""

        user.errors.each{|attr, msg|           
          error_str += "#{attr} - #{msg},"
        }
                  
        e = Error.new(:status => 400, :message => error_str)
        render :json => e.to_json, :status => 400
      end
    else
      e = Error.new(:status => 400, :message => "required parameters are missing")
      render :json => e.to_json, :status => 400
    end
  end
end

def signin
  if request.post?
    if params && params[:email] && params[:password]        
      user = User.where(:email => params[:email]).first
                    
      if user 
        if User.authenticate(params[:email], params[:password]) 
                  
          if !user.api_authtoken || (user.api_authtoken && user.authtoken_expiry < Time.now)
            auth_token = rand_string(20)
            auth_expiry = Time.now + (24*60*60)
        
            user.update_attributes(:api_authtoken => auth_token, :authtoken_expiry => auth_expiry)    
          end 
                                 
          render :json => user.to_json, :status => 200
        else
          e = Error.new(:status => 401, :message => "Wrong Password")
          render :json => e.to_json, :status => 401
        end      
      else
        e = Error.new(:status => 400, :message => "No USER found by this email ID")
        render :json => e.to_json, :status => 400
      end
    else
      e = Error.new(:status => 400, :message => "required parameters are missing")
      render :json => e.to_json, :status => 400
    end
  end
end

def get_token
  if params && params[:email]    
    user = User.where(:email => params[:email]).first
  
    if user 
      if !user.api_authtoken || (user.api_authtoken && user.authtoken_expiry < Time.now)          
        auth_token = rand_string(20)
        auth_expiry = Time.now + (24*60*60)
        
        user.update_attributes(:api_authtoken => auth_token, :authtoken_expiry => auth_expiry)                              
      end        
      
      render :json => user.to_json(:only => [:api_authtoken, :authtoken_expiry])                
    else
      e = Error.new(:status => 400, :message => "No user record found for this email ID")
      render :json => e.to_json, :status => 400
    end
    
  else
    e = Error.new(:status => 400, :message => "required parameters are missing")
    render :json => e.to_json, :status => 400
  end
end

def clear_token
  if @user.api_authtoken && @user.authtoken_expiry > Time.now
    @user.update_attributes(:api_authtoken => nil, :authtoken_expiry => nil)
        
    m = Message.new(:status => 200, :message => "Token cleared")          
    render :json => m.to_json, :status => 200  
  else
    e = Error.new(:status => 401, :message => "You don't have permission to do this task")
    render :json => e.to_json, :status => 401
  end 
end


def check_for_valid_authtoken
  authenticate_or_request_with_http_token do |token, options|     
    @user = User.where(:api_authtoken => token).first      
  end
end

def rand_string(len)
  o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  string  =  (0..len).map{ o[rand(o.length)]  }.join

  return string
end

def user_params
  params.require(:user).permit(:first_name, :last_name, :email, :password, :password_hash, :password_salt, :verification_code, 
  :email_verification, :api_authtoken, :authtoken_expiry)
end
end
