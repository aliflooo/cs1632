require 'sinatra'
require 'sinatra/reloader'

# ****************************************
# GET REQUESTS START HERE
# ****************************************

get '/' do
	erb :index
end

get '/display' do
	if params.length != 3 or params[:true] == nil or params[:false] == nil or params[:size] == nil
		status 404
		return erb :error
	end
	
	if params[:true] == ''
		params[:true] = 'T'
	end
	if params[:false] == ''
		params[:false] = 'F'
	end
	if params[:size] == ''
		params[:size] = '3'
	end

	if params[:true].length > 1 or params[:false].length > 1 or params[:size].to_i < 2 or params[:true] == params[:false]
		return erb :check_param
	end

	table = Array.new
	x = params[:size].to_i

	(2**x).times do |i|
		expr = Array.new
		and_column = true
		or_column = false
		nand_column = !(and_column)
		nor_column = !(or_column)

		x.times do |j|
			if((i/(2**(x-j-1)))%2 == 1)
				or_column = true
				nor_column = false
				expr << true
			else
				and_column = false
				nand_column = true
				expr << false
			end 
		end
		expr << and_column
		expr << or_column
		expr << nand_column
		expr << nor_column
		table << expr
	end
		
	erb :display, :locals => { trueSym: params[:true], falseSym: params[:false], size: params[:size], table: table}
end

not_found do
	status 404
	erb :error
end
