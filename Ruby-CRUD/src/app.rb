require 'sinatra'
require 'json'

set :port, 8080

products = [
  { id: 1, name: 'Product 1', price: 10.0 },
  { id: 2, name: 'Product 2', price: 20.0 },
  { id: 2, name: 'Product 3', price: 15.0 }
]

get '/' do
  content_type :json
  products.to_json
end

get '/products/:id' do
  id = params[:id].to_i
  product = products.find { |p| p[:id] == id }

  if product
    content_type :json
    product.to_json
  else
    status 404
  end
end

post '/products' do
  data = JSON.parse(request.body.read)
  product = {
    id: products.size + 1,
    name: data['name'],
    price: data['price']
  }
  products << product

  status 201
end

put '/products/:id' do
  id = params[:id].to_i
  data = JSON.parse(request.body.read)
  product = products.find { |p| p[:id] == id }

  if product
    product[:name] = data['name']
    product[:price] = data['price']
    status 200
  else
    status 404
  end
end

delete '/products/:id' do
  id = params[:id].to_i
  index = products.find_index { |p| p[:id] == id }

  if index
    products.delete_at(index)
    status 200
  else
    status 404
  end
end