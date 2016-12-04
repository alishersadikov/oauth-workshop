class SessionsController < ApplicationController
  def create
    @response = Faraday.post("https://github.com/login/oauth/access_token?client_id=36e6e59ac1b77d4aaec4&client_secret=0bddfbbe332931cd2603fcbb5a1e5a4d9612e589&code=#{params["code"]}")

    token = @response.body.split(/\W+/)[1]

    oauth_response = Faraday.get("https://api.github.com/user?access_token=#{token}")

    auth = JSON.parse(oauth_response.body)

    user          = User.find_or_create_by(uid: auth["id"])
    user.username = auth["login"]
    user.uid      = auth["id"]
    user.token    = token
    user.save

    session[:user_id] = user.id
binding.pry
    redirect_to dashboard_index_path
  end
end
