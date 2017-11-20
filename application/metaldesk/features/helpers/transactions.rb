module Helper
  class Transaction
    def self.find_trade_transaction(order_match_id, account_id)
      Db::AbxModules::TradeTransaction.where(
        orderMatchId: order_match_id,
        accountId: account_id
      )[0]
    end

    def self.account_balance_change_with_trade_transaction(trade_transaction_id, account_id, _direction, marketplace_id)
      account_balance = Db::AbxModules::Balance.where(
        marketplaceId: marketplace_id,
        balanceTypeId: 'Account',
        accountId: account_id
      )[0]

      balance_adjustment = Db::AbxModules::BalanceAdjustment.where(
        transactionId: trade_transaction_id,
        balanceId: account_balance.id
      )[0]

      account_balance_history_after = Db::AbxModules::BalanceHistory.where(
        balanceAdjustmentId: balance_adjustment.id
      )[0]

      account_balance_history_all = Db::AbxModules::BalanceHistory
                                    .where(
                                      balanceId: account_balance.id
                                    )
                                    .order(id: 'DESC')

      account_balance_history_before = nil
      account_balance_history_all.each do |bh|
        if bh.id < account_balance_history_after.id
          account_balance_history_before = bh
          break
        end
      end

      account_balance_history_after.total - account_balance_history_before.total
    end

    def self.holdings_balance_change_with_trade_transaction(trade_transaction_id, account_id, _direction, contract_id)
      holdings_balance = Db::AbxModules::Balance.where(
        contractId: contract_id,
        balanceTypeId: 'Holdings',
        accountId: account_id
      )[0]

      balance_adjustment = Db::AbxModules::BalanceAdjustment.where(
        transactionId: trade_transaction_id,
        balanceId: holdings_balance.id
      )[0]

      holdings_balance_history_after = Db::AbxModules::BalanceHistory.where(
        balanceAdjustmentId: balance_adjustment.id
      )[0]

      holdings_balance_history_all = Db::AbxModules::BalanceHistory
                                     .where(
                                       balanceId: holdings_balance.id
                                     )
                                     .order(id: 'DESC')

      holdings_balance_history_before = nil
      holdings_balance_history_all.each do |bh|
        if bh.id < holdings_balance_history_after.id
          holdings_balance_history_before = bh
          break
        end
      end

      holdings_balance_history_after.total - holdings_balance_history_before.total
    end
  end
end