require 'httparty'

module Md3ApiHttp
  def self.contracts
    res = HTTParty.get('https://local.bullioncapital.com/md3api/contracts')
    res['data']
  end
end
