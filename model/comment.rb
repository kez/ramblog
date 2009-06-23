class Comment < Sequel::Model(CONFIG.database.mappings[:comments].to_sym)
  
end
