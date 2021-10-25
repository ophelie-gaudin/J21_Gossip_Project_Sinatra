require 'gossip'
require 'bundler'
Bundler.require

class ApplicationController < Sinatra::Base

  # ACCUEIL
  get '/' do
    erb :index, locals: {
      gossips: Gossip.all
    }
    # stocke dans gossips ce que la méthode all retourne quand elle est appliquée sur la classe Gossip
  end

  # PAGE : ECRIRE NOUVEAU GOSSIP

  get '/gossips/new/' do
    erb :new_gossip
  end

  post '/gossips/new/' do
    puts "le hash complet : #{params}"
    puts "l'auteur du gossip : #{params["gossip_author"]} "
    puts "le contenu du gossip : #{params["gossip_content"]} "

    Gossip.new(params["gossip_author"], params["gossip_content"], -1)
    .save
    # à la création d'une instance Gossip, la sauvegarder selon la méthode définie dans le fichier gossip.rb
  
    redirect '/'
    #redirige vers la page d'accueil
  end

  # PAGE : CONSULTER UN GOSSIP
  get '/gossips/:id/' do
    gossips = Gossip.all
    return erb :show, locals: {
      id: params['id'],
      author: gossips[params['id'].to_i].author,
      content: gossips[params['id'].to_i].content
    }
  end

  # PAGE : EDITER UN GOSSIP
  get '/gossips/:id/edit/' do
    erb :edit,  locals: {
      gossips: Gossip.all, 
      id: params['id']
    }
  end

  post '/gossips/:id/edit/' do
    gossips = Gossip.all
    gossips[params["id"].to_i]
    .set_author(params["gossip_author"])
    .set_content(params["gossip_content"])
    .save
    #save() fait aussi office de fct update
    redirect '/'

  end

end