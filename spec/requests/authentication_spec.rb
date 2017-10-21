require "rails_helper"

# https://stackoverflow.com/a/32518970/3837223
describe "Authentication", type: :request do
  it "logs a user out" do
    user = User.create!(
      name: "Example User",
      email: "user@example.com",
      password: "password",
      confirmed_at: Date.current
    )

    # initial sign in to generate a token and response
    post user_session_path, params: {
      email: user.email,
      password: user.password
    }

    expect(user.reload.tokens.count).to eq 1

    # sign out request using header values from sign in response
    delete destroy_user_session_path, params: {
      "access-token" => response.header["access-token"],
      client: response.header["client"],
      uid: response.header["uid"]
    }

    response_body = JSON.parse(response.body)
    expect(response_body["errors"]).to be_blank
    expect(response).to have_http_status 200

    # user token should be deleted following sign out
    expect(user.reload.tokens.count).to eq 0
  end
end
