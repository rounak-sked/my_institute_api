module AuthHelper
  def auth_headers(user)
    post "/login", params: {
      user: {
        email: user.email,
        password: "password"
      }
    }

    token = response.headers["Authorization"]
    { "Authorization" => token }
  end
end