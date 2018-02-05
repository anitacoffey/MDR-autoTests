require 'httparty'
require 'jwt'
require 'base64'
require 'json'

class AuthHelper
  def self.post(account_id, url, body)
    res = HTTParty.post(url, body: JSON.generate(data: body),
                             headers: provide_headers(account_id))

    { code: res.code, data: JSON.parse(res.body) }
  end

  def self.provide_headers(account_id)
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{generate_jwt(account_id)}"
    }
  end

  def self.generate_jwt(account_id)
    account = Db::Bclconnect::Account.where(uuid: account_id)[0]
    user = Db::Bclconnect::AccountUser.where(accountid: account.id)[0]
    payload = {
      user_id: user['uuid'],
      app_metadata: {
        metaldesk_system: account['default_system'],
        metaldesk_mfa: user['mfa_secret'] ? true : false,
        metaldesk_account_id: account['id'],
        metaldesk_user_id: user['id']
      },
      iat: Time.now.to_i,
      exp: Time.new(2030, 0o1, 0o1).to_i
    }

    secret = Base64.urlsafe_decode64('04jNVQ84_5pmLZbxyyNo_6M1aBLjva1vsmKHxvEmJ-Ady3-H0G4n4pttsZYV3_zs')
    JWT.encode(payload, secret, 'HS256')
  end
end
