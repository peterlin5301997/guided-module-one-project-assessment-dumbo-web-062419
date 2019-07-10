require 'rest-client'
require 'json'

City.delete_all
Trip.delete_all
User.delete_all
latitude = (35..50).to_a
longitude = (-120..-75).to_a
arr_cities = []

30.times do
    response = RestClient.get(
        "https://api.geodatasource.com/cities?key=AS3APRYH8RQSYDSQLSIVZDTJEZ1EYPY9&format=json&lat=#{latitude.sample}&lng=#{longitude.sample}"
    )
    city_hash = JSON.parse(response)
    if city_hash != []
    		city_to_add = city_hash.sample
        arr_cities << {name: city_to_add["city"], lat: city_to_add["latitude"], lon: city_to_add["longitude"]}
    end
end

arr_cities.each do |city|
    City.create(name: city[:name], lat: city[:lat], lon: city[:lon])
end