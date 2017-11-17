require_relative '../spec_helper.rb'

describe 'Contracts' do
  it 'The number of contracts returned by the api matches contracts in the database' do
    api_contracts = Md3ApiHttp.contracts
    db_contracts = Db::AbxModules::Contract.all
    expect(api_contracts.length).to eq(db_contracts.length)
  end
end
