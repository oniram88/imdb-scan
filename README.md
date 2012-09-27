Welcome to Ruby IMDB-SCAN
--------------------

- ruby-imdb is IMDB parsing library for Ruby.
- It's an upgrade from this gem: http://github.com/yalcin/ruby-imdb
- It's retrocompatible with ruby-imdb from http://github.com/yalcin/ruby-imdb

Features
--------

- Object Oriented design
- Fast access to data

Download
--------

- [sudo] gem i imdb-scan
- https://github.com/oniram88/imdb-scan.git
- git clone git://github.com/oniram88/imdb-scan.git



Usage
-----
    require 'rubygems'
    require 'imdb'

    s = IMDB::Search.new
    s.movie("fear and loathing in las vegas").each do
      |result|
      movie = IMDB::Movie.new(result.id)
      p movie.title
      movie.cast.each do
        |cast|
        p "#{cast.name} as #{cast.char}"
      end
      p movie.poster
    end

    movie = IMDB::Movie.new(416320)
    p movie.title => "Match Point"
    p movie.cast.length => 37
    p movie.cast.first.name => "Jonathan Rhys Meyers"
    p movie.cast.first.char => "Chris Wilton"
    p movie.cast.first.person.filmography.length => 82
    p movie.director  => "Woody Allen"
    p movie.director_person.filmography.length   =>  399   (this are all Movies)


Authors
-------
- Marino Bonetti (mailto:marinobonetti@gmail.com)


This library is released under the terms of the GNU/GPL.

