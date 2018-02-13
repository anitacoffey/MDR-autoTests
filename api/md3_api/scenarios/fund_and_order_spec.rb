require_relative '../spec_helper.rb'

# contract 276 is 100g silver in Dubai. This has empty depth by default in dev setup so is a good starting point
# In the future we could programatically find an empty contract from the depth, but that seems a bit excessive
contract_id = '276'
pb_uuid = 'b440a5ca-10c4-4ed0-9a17-6580468a76fe'
pc_uuid = 'a82206a0-2191-4bf7-a373-bb643e78a50c'
other_pb_for_trade = '1f1837e9-3d05-451c-9c6e-6bb921a72e47'

# We lookup the user in all of these specs so that we can authorise the requests to the secure API
describe 'Fund And Order' do
  it 'throws an error for a contract with no depth' do
    res = Md3ApiHttp.fund_and_order(pb_uuid, pc_uuid, contract_id, 'buy', 1)
    expect(res[:code]).to eq(500)
    expect(res[:data]['errors'][0]['detail']).to eq('There is no depth for this order to match against')
  end

  it 'can correctly Md3ApiHttphit multiple levels of depth' do
    r1 = Md3ApiHttp.place_order(pb_uuid, pb_uuid, contract_id, 'limit', 'sell', 5, 100, 'GTC')
    expect(r1[:code]).to eq(201)

    r2 = Md3ApiHttp.place_order(pb_uuid, pb_uuid, contract_id, 'limit', 'sell', 5, 90, 'GTC')
    expect(r2[:code]).to eq(201)

    # The depth getter on the exchange only refreshes every 3s, which is why this sleep is required
    sleep 3

    res = Md3ApiHttp.fund_and_order(pb_uuid, pc_uuid, contract_id, 'buy', 30)

    expect(res[:code]).to eq(200)
    expect(res[:data]['data'][0]['attributes']['accountId']).to eq(pc_uuid)
    expect(res[:data]['data'][0]['attributes']['quantity']).to eq(5)
    expect(res[:data]['data'][1]['attributes']['accountId']).to eq(pc_uuid)
    expect(res[:data]['data'][1]['attributes']['quantity']).to eq(5)

    # Allow for settlement
    sleep 1
  end

  # In this scenario we expect that the clients trade balance will be the same at the
  # start and the end of the test. The clients holdings should increase, and the FMs
  # trade balance should decrease
  it 'Client and member balances are correct for a client purchases' do
    pb_account_before_trade = Helper::Balance.find_account_balance(pb_uuid, 1)
    pc_account_before_trade = Helper::Balance.find_account_balance(pc_uuid, 1)
    pc_holdings_before_trade = Helper::Balance.find_holdings_balance(pc_uuid, contract_id.to_i)

    r1 = Md3ApiHttp.place_order(other_pb_for_trade, other_pb_for_trade, contract_id, 'limit', 'sell', 5, 90, 'GTC')
    expect(r1[:code]).to eq(201)

    # The depth getter on the exchange only refreshes every 3s, which is why this sleep is required
    sleep 3

    r2 = Md3ApiHttp.fund_and_order(pb_uuid, pc_uuid, contract_id, 'buy', 30)
    expect(r2[:code]).to eq(200)
    order_id = r2[:data]['data'][0]['attributes']['orderId']
    order_placed_at = r2[:data]['data'][0]['attributes']['createdAt']
    # Allow for settlement
    Helper::Order.wait_for_order_settlement(order_id, 'buy')
    Helper::Transaction.wait_on_cash_movement(pc_uuid, 'Cash Withdrawal', order_placed_at)

    pb_account_after_trade = Helper::Balance.find_account_balance(pb_uuid, 1)
    pc_account_after_trade = Helper::Balance.find_account_balance(pc_uuid, 1)
    pc_holdings_after_trade = Helper::Balance.find_holdings_balance(pc_uuid, contract_id.to_i)

    expect(pc_account_before_trade.to_f).to eq(pc_account_after_trade.to_f)
    expect(pc_holdings_before_trade + 5).to eq(pc_holdings_after_trade)
    expect(pb_account_before_trade > pb_account_after_trade).to eq(true)
  end

  # In this scenario we expect that the clients trade balance will be the same at the
  # start and the end of the test. The clients holdings should decrease, and the FMs
  # trade balance should increase
  it 'Client and member balances are correct for a client sales' do
    pb_account_before_trade = Helper::Balance.find_account_balance(pb_uuid, 1)
    pc_account_before_trade = Helper::Balance.find_account_balance(pc_uuid, 1)
    pc_holdings_before_trade = Helper::Balance.find_holdings_balance(pc_uuid, contract_id.to_i)

    r1 = Md3ApiHttp.place_order(other_pb_for_trade, other_pb_for_trade, contract_id, 'limit', 'buy', 5, 90, 'GTC')
    expect(r1[:code]).to eq(201)

    # The depth getter on the exchange only refreshes every 3s, which is why this sleep is required
    sleep 3

    r2 = Md3ApiHttp.fund_and_order(pb_uuid, pc_uuid, contract_id, 'sell', 5)
    expect(r2[:code]).to eq(200)
    order_id = r2[:data]['data'][0]['attributes']['orderId']
    order_placed_at = r2[:data]['data'][0]['attributes']['createdAt']

    # Allow for settlement. Not sure why this settlement is so slow
    Helper::Order.wait_for_order_settlement(order_id, 'sell')
    Helper::Transaction.wait_on_cash_movement(pc_uuid, 'Cash Withdrawal', order_placed_at)

    pb_account_after_trade = Helper::Balance.find_account_balance(pb_uuid, 1)
    pc_account_after_trade = Helper::Balance.find_account_balance(pc_uuid, 1)
    pc_holdings_after_trade = Helper::Balance.find_holdings_balance(pc_uuid, contract_id.to_i)

    expect(pc_holdings_before_trade - 5).to eq(pc_holdings_after_trade)
    expect(pc_account_before_trade.to_f).to eq(pc_account_after_trade.to_f)
    expect(pb_account_before_trade < pb_account_after_trade).to eq(true)
  end
end
