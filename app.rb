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

class Contact < ActiveRecord::Base
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

	#Проводим валидацию
    hh = { :username => ' Введите имя', 
		:phone => "Введите телефон", 
		:date_name => 'Введите дату и время' }

	@error = hh.select { |key,_| params[key] == '' }.values.join(". ")

	return erb :visit if @error != ''

	client = Client.create(name:  @username, phone: @phone, datestamp: @date_name, barber: @barba, color: @color)

    erb "<h2>Спасибо #{@username}, вы записались к #{@barba} на #{@date_name}</h2>"
end

get '/contacts' do
    erb :contacts
end

post '/contacts' do
    @name = params[:name]
    @email = params[:email]
    @text = params[:text]

    hh = { email: 'Введите адрес электронной почты', text: 'Вы не ввели сообещение', name: 'Не введено имя'  }
    
    @error = hh.select { |key,_| params[key] == '' }.values.join('. ')
    
    return erb :contacts if @error != ''

    #Записываем данные в бд с помощью activerecord
    Contact.create(name: @name, email: @email, text: @text)

    erb "<h2>Спасибо #{@name} за сообщение</h2>"
end