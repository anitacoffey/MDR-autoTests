require 'httparty'

module Md3ApiHttp
  def self.contracts
    res = HTTParty.get('https://local.bullioncapital.com/md3api/contracts')
    res['data']
  end

  def self.products
    res = HTTParty.get('https://local.bullioncapital.com/md3api/products')
    res['data']
  end
end
