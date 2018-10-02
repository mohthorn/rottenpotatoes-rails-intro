class Movie < ActiveRecord::Base
    def self.get_ratings
       return ['G','PG','PG-13', 'NC-17', 'R']
    end
end
