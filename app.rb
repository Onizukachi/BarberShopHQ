require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"

set :database, {adapter: "sqlite3", database: "barbershop.db"}

#Код ниже отвечает за настройку activerecord для нашей сущности
class Client < ActiveRecord::Base
    #Включаем валидацию на присутствие текста, :name это символ(1-ый параметр), а дальше идет хеш(2-ой параметр)
    validates :name, presence: true, length: { minimum: 3 }
    validates :phone, presence: true
    validates :datestamp, presence: true
    validates :color, presence: true

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
    #Установим глобальную переменную чтобы она была доступна после отправки POS, так какмы вернемся сюда
    @c = Client.new
    erb :visit
end

post '/visit'do
    #:client просто название, любое можно написать
    @c = Client.new params[:client]
    @c.save

    if @c.save
        erb "<h2>Спасибо, вы записались</h2>"
    else
        @error = @c.errors.full_messages.first
        erb :visit
    end
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

get "/barber/:id" do
    #find ищет элемент по primary key(id) и достает нужного нам барбера
    @barber = Barber.find(params[:id])
    erb :barber
end

get '/bookings' do
    #Список записавшихся осортированный по дате добалвения, сначала новые
    @client = Client.order('created_at DESC')
    erb :bookings
end

get '/client/:id' do
    @client = Client.find(params[:id])
    erb :client
end