module Helper
  class Balance
    def self.find_account_balance(account_id, marketplace_id)
      Db::AbxModules::Balance.where(
        marketplaceId: marketplace_id,
        balanceTypeId: 'Account',
        accountId: account_id
      )[0]['value']
    end

    def self.find_holdings_balance(account_id, contract_id)
      Db::AbxModules::Balance.where(
        contractId: contract_id,
        balanceTypeId: 'Holdings',
        accountId: account_id
      )[0]['value']
    end
  end
end
