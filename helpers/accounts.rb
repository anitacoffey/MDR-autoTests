module Helper
  class Account
    def self.find_account_uuid(username)
      Db::Bclconnect::AccountUser.where(username: username)[0].account.uuid
    end
  end
end
