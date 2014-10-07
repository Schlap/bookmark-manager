#This class corresponds to a table in a database
#You can use it manipulate the data
class Link

#this makes the instance of this class DataMapper resources
include DataMapper::Resource

#this block describes what we resources are model will have
property :id,    Serial #serial means that it will be auto incremented for every record
property :title, String
property :url,   String

end