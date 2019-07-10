require 'rest-client'
require 'json'


latitude = (35..50).to_a
longitude = (-120..-75).to_a
arr_cities = []

30.times do
    response = RestClient.get(
        "https://api.geodatasource.com/cities?key=AS3APRYH8RQSYDSQLSIVZDTJEZ1EYPY9&format=json&lat=#{latitude.sample}&lng=#{longitude.sample}"
    )
    city_hash = JSON.parse(response)
    if city_hash != []
        arr_cities << city_hash.sample["city"]
    end
end

arr_cities.each do |city|
    City.create(name: city)
end