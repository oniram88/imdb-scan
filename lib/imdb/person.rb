module IMDB
  # Get Person information with IMDB person id.
  # @example Get Christian Bale information [http://www.imdb.com/name/nm0000288/]
  #   m = IMDB::Person.new('0000288')
  #   puts m.name
  #   puts m.real_name
  class Person < IMDB::Skeleton
    attr_accessor :id

    def initialize(imdb_id)
      super("Person", { :id => String,
                        :name => String,
                        :real_name => String,
                        :birthdate => Date,
                        :deathdate => Date,
                        :nationality => String,
                        :height => String,
                        :biography => String,
                        :photo => String,
                        :profile_path => String,
                        :filmography => Hash,
                        :main_document => Nokogiri,
                        :bio_document => Nokogiri,
                        :photo_document => Nokogiri,
                        :photo_document_url => String }, [:id])
      @id = imdb_id
    end

    #Get the profile path
    #@return [String]
    def profile_path
      "/name/nm#{@id}"
    end

    #Get the name of the person
    #@return [String]
    def name
      bio_document.css("h3[itemprop='name'] a").first.inner_text rescue nil
    end

    #Get The Real Born name of the Person
    #@return [String]
    def real_name
      bio_document.at("h5[text()*='Birth Name']").next.inner_text.strip rescue nil
    end

    #Get The Birth Date
    #@return [Date]
    def birthdate
      date_month = bio_document.at("h5[text()*='Date of Birth']").next_element.inner_text.strip rescue ""
      year = bio_document.at("a[@href*='birth_year']").inner_text.strip rescue ""
      Date.parse("#{date_month} #{year}") rescue nil
    end

    #Get The death date else nil
    #@return [Date]
    def deathdate
      date_month = bio_document.at("h5[text()*='Date of Death']").next_element.inner_text.strip rescue ""
      year = bio_document.at("a[@href*='death_date']").inner_text.strip rescue ""
      Date.parse("#{date_month} #{year}") rescue nil
    end

    #Get the Nationality
    #@return [String]
    def nationality
      bio_document.at("a[@href*='birth_place']").inner_text.strip rescue nil
    end

    #Get the height
    #@return [String]
    def height
      bio_document.css("#bio_content td.label:contains('Height')").first.next_element.inner_text.match(/\(([0-9\.]+).*\)/)[1].to_f rescue nil
    end

    #Get The Biography
    #@return [String]
    def biography
      bio_document.at("h5[text()*='Biography']").next_element.inner_text rescue nil
    end

    #Return the principal Photo
    #@return [String]
    def photo
      photo_document.at("img#primary-img").get_attribute('src') if photo_document rescue nil
    end

    #Return the Filmography
    #for the moment I can't make subdivision of this, then i take all in an array
    #@return [Movie]
    def filmography
      #@return [Hash]
      #     writer: [Movie]
      #     actor: [Movie]
      #     director: [Movie]
      #     composer: [Movie]
      #as_writer = main_document.at("#filmo-head-Writer").next_element.search('b a').map { |e| e.get_attribute('href')[/tt(\d+)/, 1] } rescue []
      #as_actor = main_document.at("#filmo-head-Actor").next_element.search('b a').map { |e| e.get_attribute('href')[/tt(\d+)/, 1] } rescue []
      #as_director = main_document.at("#filmo-head-Director").next_element.search('b a').map { |e| e.get_attribute('href')[/tt(\d+)/, 1] } rescue []
      #as_composer = main_document.at("#filmo-head-Composer").next_element.search('b a').map { |e| e.get_attribute('href')[/tt(\d+)/, 1] } rescue []
      #{ writer: as_writer.map { |m| Movie.new(m) }, actor: as_actor.map { |m| Movie.new(m) }, director: as_director.map { |m| Movie.new(m) }, composer: as_composer.map { |m| Movie.new(m) } }
      films=main_document.css(".filmo-row b a").map { |e| e.get_attribute('href')[/tt(\d+)/, 1] } rescue []
      films.map { |f| Movie.new(f.to_i) }
    end


    def main_document
      #@main_document ||= Nokogiri open("http://www.imdb.com#{profile_path}")
      @main_document ||= Nokogiri::HTML(open("http://www.imdb.com#{profile_path}"))
    end

    def bio_document
      @bio_document ||= Nokogiri open("http://www.imdb.com#{profile_path}/bio")
    end

    def photo_document
      @photo_document ||= if photo_document_url then
                            Nokogiri open("http://www.imdb.com" + photo_document_url)
                          else
                            nil
                          end
    end

    def photo_document_url
      bio_document.at(".photo a[@name=headshot]").get_attribute('href') rescue nil
    end

  end
end
