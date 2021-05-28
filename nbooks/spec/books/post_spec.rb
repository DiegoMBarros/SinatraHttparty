#ecoding: utf-8

# require "httparty"

describe "POST /books" do

    context "quando o payload é ok" do
        before do
            payload = { title: "O Livro dos Bugs", author: "João Junior", isbn: Faker::Code.isbn }

            # @resp = HTTParty.post(
            #     "http://localhost:4567/books",
            @resp = BaseApi.post(
                "/books",
                body: payload.to_json,
            )
        end

        it "deve retornar 201" do
            expect(@resp.code).to eql 201
        end
    end

    context "quando o payload é nulo" do
        before do
            payload = nil

            # @resp = HTTParty.post(
            #     "http://localhost:4567/books",
            @resp = BaseApi.post(
                "/books",
                body: nil,
            )
        end

        it "deve retornar 400" do
            expect(@resp.code).to eql 400
        end
    end

    context "quando o isbn já existe" do
        before do
            payload = { title: "Dom Casmurro", author: "Machado de Assis", isbn: Faker::Code.isbn }

            BaseApi.post("/books", body: payload.to_json)
            @resp = BaseApi.post("/books", body: payload.to_json)
        end

        #Conflito
        it "deve retornar 409" do
            expect(@resp.code).to eql 409
        end
    end

    context "quando o titulo nao existe no payload" do
        before do
            payload = { author: "Machado de Assis", isbn: Faker::Code.isbn }

            BaseApi.post("/books", body: payload.to_json)
            @resp = BaseApi.post("/books", body: payload.to_json)
        end

        #Conflito
        it "deve retornar 409" do
            expect(@resp.code).to eql 409
        end

        it "deve retornar mensagem de erro" do
            expect(@resp.parsed_response["error"]).to eql "Title is Required."
        end
    end

    context "quando o autor nao existe no payload" do
        before do
            payload = { title: "Biografia do Slash", isbn: Faker::Code.isbn }

            BaseApi.post("/books", body: payload.to_json)
            @resp = BaseApi.post("/books", body: payload.to_json)
        end

        #Conflito
        it "deve retornar 409" do
            expect(@resp.code).to eql 409
        end

        it "deve retornar mensagem de erro" do
            expect(@resp.parsed_response["error"]).to eql "Author is Required."
        end
    end

    context "quando o isbn nao existe no payload" do
        before do
            payload = { title: "Biografia do Slash", author: "Saul Hudson" }

            BaseApi.post("/books", body: payload.to_json)
            @resp = BaseApi.post("/books", body: payload.to_json)
        end

        #Conflito
        it "deve retornar 409" do
            expect(@resp.code).to eql 409
        end

        it "deve retornar mensagem de erro" do
            expect(@resp.parsed_response["error"]).to eql "ISBN is Required."
        end
    end
end