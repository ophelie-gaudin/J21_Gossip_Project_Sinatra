require 'csv'
require 'bundler'
Bundler.require

class Gossip 
  attr_accessor :author, :content
  attr_reader :id

  #NEW 
  def initialize(author, content, id)
    @author = author
    @content = content
    @id = id
  end


  #MODIFIER L'AUTEUR ET LE CONTENT
  def set_author(new_author)
    @author = new_author
    return self
  end

  def set_content(new_content)
    @content = new_content
    return self
  end

  #SAVE & UPDATE
  def save()
    if @id >= 0
       # si l'id est sup/égal à 0 = il existe déjà, 
      # car si j'ai un id c'est que le gossip ne doit pas être créé mais mis à jour
     
      puts "Updating an existing gossip in the DB (ID:#{@id})"

      new_gossips_array = []

      CSV.read("./db/gossip.csv").each_with_index do |csv_line, index|
        #on lit toutes le lignes du csv une à une et en fct de l'index
        if index == @id
          # condition = c'est la ligne à modifier
          new_gossips_array.push [@author, @content]
        else
          # pas condition = ce n'est pas la ligne à modifier, on prend celle du csv
          new_gossips_array.push csv_line
        end
      end

     
      CSV.open("./db/gossip.csv", "w+") do |csv|
        #  ouvrons le CSV en mode sur-écriture (w+)
        new_gossips_array.each do |gossip_row|
          csv << gossip_row
        end
      end



    else
      #quand l'id n'existe pas, on ajoute une nouvelle ligne à notre csv = nouveau gossip
      puts "Creating a new gossip in the DB (ID:#{@id})"
      CSV.open("./db/gossip.csv", "ab") do |csv|
        csv << [@author, @content]
      end
    end

    return self
  end


#RECOLTE DANS UN TABLEAU DE TOUS LES GOSSIPS DU CSV
  def self.all()
   # lit chaque ligne du CSV, puis retourner un array contenant des instances de potins du genre : [potin_1, potin_2, …, potin_n].
   all_gossips_array = []
 
    CSV.read("./db/gossip.csv").each_with_index do |csv_line, index|
      all_gossips_array << Gossip.new(csv_line[0], csv_line[1], index)
    end 

   return all_gossips_array
  end 



end
