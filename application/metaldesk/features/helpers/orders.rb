module Helper
  class Order
    def self.find_order(account_uuid, contract_id, direction, quantity)
      Db::AbxModules::Order
        .where(
          accountId: account_uuid,
          direction: direction,
          contractId: contract_id.to_i,
          quantity: quantity
        )
        .order(createdAt: 'DESC')
        .limit(1)[0]
    end

    def self.find_orders_by_id(order_ids)
      Db::AbxModules::Order.where(id: order_ids)
    end

    def self.find_order_matches(order_id, direction)
      if direction == 'buy'
        Db::AbxModules::OrderMatch.where(buyOrderId: order_id)
      else
        Db::AbxModules::OrderMatch.where(sellOrderId: order_id)
      end
    end
  end
end
