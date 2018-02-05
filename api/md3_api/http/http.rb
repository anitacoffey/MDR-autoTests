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

  def self.depth(marketplace_id)
    res = HTTParty.get("https://local.bullioncapital.com/md3api/depths?marketplaceId=#{marketplace_id}")
    res['data']
  end

  # Limit price and Validitity is only required for limit orders
  # Expiry is only required for GTD validity orders
  def self.place_order(requester_id,
                       account_id,
                       contract_id,
                       order_type,
                       direction,
                       quantity,
                       limit_price = nil,
                       validity = nil,
                       expiry = nil)
    body = {
      type: 'orders',
      attributes: {
        contractId: contract_id,
        accountId: account_id,
        direction: direction,
        quantity: quantity,
        orderType: order_type
      }
    }

    if limit_price
      body[:attributes]['limitPrice'] = limit_price
      body[:attributes]['validity'] = validity
      body[:attributes]['expiry'] = expiry if validity == 'GTD'
    end

    AuthHelper.post(requester_id, 'https://local.bullioncapital.com/md3api/orders', body)
  end

  def self.fund_and_order(requester_id, account_id, contract_id, direction, quantity)
    # We currently only support market orders through this endpoint, hence the hardcoding of orderType
    body = {
      type: 'orders',
      attributes: {
        contractId: contract_id,
        accountId: account_id,
        direction: direction,
        quantity: quantity,
        orderType: 'market'
      }
    }

    AuthHelper.post(requester_id, 'https://local.bullioncapital.com/md3api/orders/fund_and_order', body)
  end
end
