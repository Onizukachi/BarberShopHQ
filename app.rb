require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"

set :database, {adapter: "sqlite3", database: "barbershop.db"}

#Код ниже отвечает за настройку activerecord для нашей сущности
class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base	
end

before do
	@barbers = Barber.all
end

get '/' do
	erb :index	
end

get '/visit' do
    #Присваиваем таблицу Barbers для вывода, сортируя по id
    erb :visit
end

post '/visit'do
    @username = params[:username]
    @phone = params[:phone]
    @date_name = params[:date_name]
    @barba = params[:barber]
    @color = params[:color]

    erb "<h2>Спасибо, вы записались</h2>"
end