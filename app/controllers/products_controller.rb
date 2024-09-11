require 'net/http'

class ProductsController < ApplicationController

    def CallRestAPI(base_url)
        uri = URI(base_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
      
        request = Net::HTTP::Get.new(uri.path, {'Content-Type' => 'application/json'})
            
        response = http.request(request)

        return JSON.parse(response.body) 
    end

    def LoadProducts() 
        @products = CallRestAPI('https://fakestoreapi.com/products')

        @products.each { |product| 
            product.delete("rating")
            product.delete("id")
            @product = Product.new(product)
            if @product.save
                puts ('[LoadProducts] saving @product')
                puts (@product)
            else
                puts ('[LoadProducts] error saving @product')
                puts (@product.errors)
            end
        }
        
        @allProducts = Product.all
        return @allProducts
    end

    def index
        @productsCount = Product.count
        @products = @productsCount == 0 ? LoadProducts() : Product.all
        render json: @products
    end

    def create
        @product = Product.new(product_params)
        if @product.save
            render json: @product, status: :created
        else
            render json: @product.errors, status: :unprocessable_entity
        end
    end

    private

    def product_params
        params.require(:product).permit(
            :category,
            :description,
            :image,
            :price,
            :title
        )
    end
end
