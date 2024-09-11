require 'net/http'

class UsersController < ApplicationController

    def CallRestAPI(base_url)
        uri = URI(base_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
      
        request = Net::HTTP::Get.new(uri.path, {'Content-Type' => 'application/json'})
            
        response = http.request(request)

        return JSON.parse(response.body) 
    end

    def index
        @dbUsers = User.count
        puts(@dbUsers)
        @users = CallRestAPI('https://fakestoreapi.com/users')
        render json: @users
    end

    def create
        @user = User.new(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :email)
    end
end
