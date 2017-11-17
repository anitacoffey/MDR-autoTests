require_relative '../spec_helper.rb'

describe 'Products' do
  it 'The number of products returned by the api matches products in the database' do
    api_products = Md3ApiHttp.products
    db_products = Db::AbxModules::Product.all
    expect(api_products.length).to eq(db_products.length)
  end
end
