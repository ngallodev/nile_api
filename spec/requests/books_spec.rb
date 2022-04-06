require 'rails_helper'

describe 'Books API', type: :request do
    let(:first_author) {FactoryBot.create(:author, first_name: 'George', last_name:'Jefferson', age: 125)}
    let(:second_author) {FactoryBot.create(:author, first_name: 'H.G.', last_name:'Wells', age: 50)}
    describe 'GET /books' do
        before do 
            # author = FactoryBot.create(:author, first_name: 'George', last_name:'Jefferson', age: '125')
            FactoryBot.create(:book, title: 'Movin\' On Up', author: first_author)
            FactoryBot.create(:book, title: 'War Of The Worlds', author: second_author)
        end

        it 'returns all books' do
            
            get '/api/v1/books'

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
            expect(response_body).to eq(
                [
                    {
                        'id'=> 1,
                        'title'=> 'Movin\' On Up',
                        'author_name'=> 'George Jefferson',
                        'author_age'=> 125
                    },
                    {
                        'id'=> 2,
                        'title'=> 'War Of The Worlds',
                        'author_name'=> 'H.G. Wells',
                        'author_age'=> 50
                    }
                ]
            )
        end

        it 'returns a subset of books based on limit' do
            get '/api/v1/books', params: {limit: 1}
            
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        'id'=> 1,
                        'title'=> 'Movin\' On Up',
                        'author_name'=> 'George Jefferson',
                        'author_age'=> 125
                    }
                ]
            )
        end

        it 'returns a subset of books based on limit and offset' do
            get '/api/v1/books', params: {limit: 1, offset: 1}
            
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        'id'=> 2,
                        'title'=> 'War Of The Worlds',
                        'author_name'=> 'H.G. Wells',
                        'author_age'=> 50
                    }
                ]
            )
        end



    end

    describe 'POST /books' do 
        it 'create a new book' do
            # author = FactoryBot.create(:author, first_name: 'George', last_name:'Jefferson', age: '125')
            expect {
                post '/api/v1/books', params: { 
                    book: {title: 'The Martian'}, 
                    author: {first_name: 'Andy', last_name: 'Weir', age: 25} 
                    }
                    
            }.to change {Book.count}.from(0).to(1)
            
            expect(response).to have_http_status(:created)
            expect(Author.count).to eq(1)
            expect(response_body).to eq(
                'id'=> 1,
                'title'=> 'The Martian',
                'author_name'=> 'Andy Weir',
                'author_age'=> 25
            )
        end
    end

    describe 'DELETE /books/:id' do
        # let!(:author) {FactoryBot.create(:author, first_name: 'George', last_name:'Jefferson', age: 125)}
        let!(:book) {FactoryBot.create(:book, title: 'abc', author: first_author)}

        it 'deletes a book' do
            expect {
                delete "/api/v1/books/#{book.id}"
            }.to change {Book.count}.from(1).to(0)
                      
            expect(response).to have_http_status(:no_content)
        end
    end


end
