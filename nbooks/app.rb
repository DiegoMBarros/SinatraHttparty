require "sinatra"
require "sinatra/namespace"
require "mongoid"

#DB Connect
Mongoid.load! "mongoid.yml"

#Model
class Book
    include Mongoid::Document

    field :title, type: String
    field :author, type: String
    field :isbn, type: String
end

get "/" do
    content_type "application/json"
    return { message: "Welcome to Book API from QA Ninja!" }.to_json
end

namespace "/books" do
    before do
        content_type "application/json"
    end

    get do
        return Book.all.to_json
    end

    get "/:book_id" do |book_id|
        book = Book.where(_id: book_id).first

        unless book
            halt 404, {}.to_json
        end

        return book.to_json
    end

    delete "/:book_id" do |book_id|
        book = Book.where(_id: book_id).first
        book.destroy if book
        status 204
    end

    post do
        begin
            # puts request.body.read
            payload = JSON.parse(request.body.read)
            # puts payload
            # puts payload.class

            unless payload["title"]
                halt 409, { error: "Title is Required." }.to_json
            end

            unless payload["author"]
                halt 409, { error: "Author is Required." }.to_json
            end

            unless payload["isbn"]
                halt 409, { error: "ISBN is Required." }.to_json
            end

            found = Book.where(isbn: payload["isbn"]).first

            if found
                halt 409, { error: "Duplicated ISBN" }.to_json
            end

            book = Book.new(payload)
            book.save
            status 201
            return book.to_json
        rescue => exception
            puts exception
            halt 400, { error: exception }.to_json
        end
    end
end

# get "/books" do
#     content_type "application/json"
#     # books = [
#     #     { title: "Dom Casmurro", author: "Machado de Assis", isbn: "abc2001"},
#     #     { title: "Marca de uma lágrima", author: "Pedro Bandeira", isbn: "abc2002"},
#     #     { title: "Moby Dick", author: "Herman Melville", isbn: "abc2003"}
#     # ]
#     # return books.to_json
#     return Book.all.to_json
# end