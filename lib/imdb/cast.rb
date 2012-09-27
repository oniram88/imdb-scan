module IMDB
  class Cast < IMDB::Skeleton
    attr_accessor :movie, :person, :char

    def initialize(movie, person, char)
      super("Cast", { :person => Person, :movie => Movie }, [:person, :char])
      @movie = movie
      @person = person
      @char = char
    end

    def name
      @person.name
    end

    def char
      @char
    end

    def imdb_id
      movie.imdb_id
    end

    def profile
      @person.profile_path
    end

    def picture
      @person.photo
    end

    def to_s
      "Name: #{name} \n Char: #{char} \n"
    end


  end
end
