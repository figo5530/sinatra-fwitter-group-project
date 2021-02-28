class TweetsController < ApplicationController
    get '/tweets' do
        if logged_in?
            erb :"/tweets/index"
        else
            redirect '/login'            
        end
    end

    post '/tweets' do
        if logged_in?
            if params[:content]!= ""
                @tweet = current_user.tweets.build(content: params[:content])
                @tweet.save
                redirect "/tweets/#{@tweet.id}"
            else
                redirect '/tweets/new'
            end
        else
            redirect '/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            erb :"/tweets/new"
        else
            redirect '/login'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by(id: params[:id])
            # binding.pry
            erb :"/tweets/show"
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        # binding.pry
        if logged_in?
            @tweet = Tweet.find_by(id: params[:id])
            erb :"/tweets/edit"
        else
            redirect '/login'
        end
    end

    patch '/tweets/:id' do
        # binding.pry
        if logged_in?
            if params[:content] == ""
                redirect "/tweets/#{params[:id]}/edit"
            else
                @tweet = Tweet.find_by(id: params[:id])
                if @tweet && @tweet.user == current_user
                    @tweet.update(content: params[:content])
                    redirect "/tweets/#{params[:id]}"
                else
                    redirect '/tweets'
                end
            end
        else
            redirect '/login'
        end
    end

    delete '/tweets/:id/delete' do
        @tweet = Tweet.find_by(id: params[:id])
        if @tweet && @tweet.user == current_user
            @tweet.delete
            redirect '/tweets'
        end
    end
end
