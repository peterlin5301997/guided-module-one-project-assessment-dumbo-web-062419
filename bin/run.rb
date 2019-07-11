require_relative '../config/environment'
require "tty-prompt"
require "colorize"
require "geocoder"
require "pry"

class CommandLineInterface
    attr_reader :user
    def initialize
        @prompt = TTY::Prompt.new
        @user = nil
        pid = fork{ exec 'afplay', "audio/The_Next_Episode_Instrumental.mp3"}
        marijuana
        welcome
    end

    def marijuana
    puts "                                                  
                                                        :-                        
                                                        o+                        
                                                       :oo:                       
                                                      :oooo:                      
                                                     `oooooo`                     
                                                    `oooooooo                     
                                                    /oooooooo:                    
                                                   `+oooooooo+`                   
                                  :+:.`            `+oooooooo+`            `.:+:  
                                   .ooo++--`       .oooooooooo.       `:-++ooo.   
                                    -oooooooo:-    `oooooooooo`    -:oooooooo-    
                                     .ooooooooo/:  `ooooooooo+`  //ooooooooo.     
                                      .+oooooooooo-`/oooooooo/`-oooooooooo+.      
                                       `/ooooooooooo:oooooooo:ooooooooooo/`       
                                         `+oooooooooooooooooooooooooooo+`         
                                           `:+oooooooooooooooooooooo+:`           
                                             `-/oooooooooooooooooo/-`             
                                       `-:/+oooooooooooooooooooooooooo+/:-`       
                                    .:/oooooooooooooooooooooooooooooooooooo/:`    
                                        .-:/+++++++ooooo/-ooooo+++++++/:-.        
                                                 /oooo/`:.`/oooo/                 
                                               `+ooo/.  ./  ./ooo+`               
                                              `//-.     `+     .-:/`              
    ".green
    end

    def welcome
        puts "
        $$\\      $$\\         $$\\                                                 $$\\              
        $$ | $\\  $$ |        $$ |                                                $$ |             
        $$ |$$$\\ $$ |$$$$$$\\ $$ |$$$$$$$\\ $$$$$$\\ $$$$$$\\$$$$\\  $$$$$$\\        $$$$$$\\   $$$$$$\\  
        $$ $$ $$\\$$ $$  __$$\\$$ $$  _____$$  __$$\\$$  _$$  _$$\\$$  __$$\\       \\_$$  _| $$  __$$\\ 
        $$$$  _$$$$ $$$$$$$$ $$ $$ /     $$ /  $$ $$ / $$ / $$ $$$$$$$$ |        $$ |   $$ /  $$ |
        $$$  / \\$$$ $$   ____$$ $$ |     $$ |  $$ $$ | $$ | $$ $$   ____|        $$ |$$\\$$ |  $$ |
        $$  /   \\$$ \\$$$$$$$\\$$ \\$$$$$$$\\\\$$$$$$  $$ | $$ | $$ \\$$$$$$$\\         \\$$$$  \\$$$$$$  |
        \\__/     \\__|\\_______\\__|\\_______|\\______/\\__| \\__| \\__|\\_______|         \\____/ \\______/ 

        $$$$$$$$\\      $$\\                                  $$$$$$$\\ $$\\                                              
        \\__$$  __|     \\__|                                 $$  __$$\\$$ |                                             
           $$ |$$$$$$\\ $$\\ $$$$$$\\  $$$$$$\\ $$\\   $$\\       $$ |  $$ $$ |$$$$$$\\ $$$$$$$\\ $$$$$$$\\  $$$$$$\\  $$$$$$\\  
           $$ $$  __$$\\$$ $$  __$$\\$$  __$$\\$$ |  $$ |      $$$$$$$  $$ |\\____$$\\$$  __$$\\$$  __$$\\$$  __$$\\$$  __$$\\ 
           $$ $$ |  \\__$$ $$ /  $$ $$ /  $$ $$ |  $$ |      $$  ____/$$ |$$$$$$$ $$ |  $$ $$ |  $$ $$$$$$$$ $$ |  \\__|
           $$ $$ |     $$ $$ |  $$ $$ |  $$ $$ |  $$ |      $$ |     $$ $$  __$$ $$ |  $$ $$ |  $$ $$   ____$$ |      
           $$ $$ |     $$ $$$$$$$  $$$$$$$  \\$$$$$$$ |      $$ |     $$ \\$$$$$$$ $$ |  $$ $$ |  $$ \\$$$$$$$\\$$ |      
           \\__\\__|     \\__$$  ____/$$  ____/ \\____$$ |      \\__|     \\__|\\_______\\__|  \\__\\__|  \\__|\\_______\\__|      
                          $$ |     $$ |     $$\\   $$ |                                                                
                          $$ |     $$ |     \\$$$$$$  |                                                                
                          \\__|     \\__|      \\______/                                                                 
        
        ".yellow
        puts "                                                P L A N N I N G    T R I P S    L I K E    Y O U ' R E    H I G H !\n\n".green
    end

    def account_menu
        @prompt.select("Please select an option: ") do |option|
            option.choice "Login", -> { login }
            option.choice "Register", -> { register }
        end
    end

    def login
        puts "===== WELCOME TO LOGIN =====\n\n".yellow
        user_name = @prompt.ask("What is your name?", default: "User")
        user = User.find_by(name: user_name)
        if user == nil # if user does not exist in DB
            puts "\nWe don't know no #{user_name}. (We do not have a user with that name.)\n".red
            @prompt.select("You want to be part of the club?") do |option|
                option.choice "Yes", -> { register }
                option.choice "No", -> { 
                    puts "\nGet outta here!\n".red
                    exit
                }
            end
        else
            @user = user
            puts "\nAyy #{@user.name}! How's you been?\n".green
        end
    end

    def register
        puts "===== WELCOME TO REGISTER =====\n\n".yellow
        registered = false
        while registered == false
            user_name = @prompt.ask("What is your name?", default: "User")
            user = User.find_by(name: user_name)
            if user != nil # if user exists in DB
                puts "\nYou ain't no #{user_name}. (Name is taken. Please enter another name.)\n".red
            else
                @user = User.create(name: user_name)
                puts "\nTime to get TRIPPY! (Account created!)\n".green
                registered = true
            end
        end
    end

    def get_user_menu_selection
        done = false
        while done != true do 
            @prompt.select("What's the hookup you lookin' for?") do |menu|
                menu.choice "Book Trip", -> { book_trip }
                menu.choice "Edit Trip", -> { edit_trip }
                menu.choice "Display Trip List", -> { display_trip_list }
                menu.choice "Cancel Trip", -> { cancel_trip }
                menu.choice "EXIT", -> { 
                    system "clear"
                    marijuana
                    puts "\n\t\t\t\t\t\tStay safe. Don't trip.\n".yellow
                    pid = fork{ exec 'killall', "afplay" }
                    done = true
                }
            end
        end
    end

    def book_trip
        system "clear"
        puts "===== BOOK TRIP =====\n\n".yellow
        booked = false
        while booked != true do 
            user_city_from = @prompt.select("What city you located at?") do |menu|
                City.all.each do |city|
                    menu.choice name: city.name, value: city
                end
            end
            user_city_to = @prompt.select("What city you traveling to?") do |menu|
                City.all.each do |city|
                    menu.choice name: city.name, value: city
                end
            end

            if user_city_from == user_city_to
                puts "\nYou're too high, #{@user.name}. You already there!\n".red
            else
                @user.trips.create(city_from: user_city_from, city_to: user_city_to)
                puts "\nBooked that trip for you. I gotchu!\n".green
                booked = true
            end
        end
    end

    def trip_distance_miles(trip)
        Geocoder::Calculations.distance_between([trip.city_from.lat, trip.city_from.lon], [trip.city_to.lat, trip.city_to.lon]).to_i
    end

    def total_user_distance
        @user.trips.sum{|trip| trip_distance_miles(trip)}
    end

    def edit_trip
        system "clear"
        puts "===== EDIT TRIP =====\n\n".yellow
        edited = false
        while edited != true do 
            if @user.trips.length == 0
                puts "You Trippin' Dawg. You Don't Got Any Trips Booked!\n\n".red
                edited = true
            else
                chosen_trip = @prompt.select("Pick a Trip to Modify: ") do |option|
                    @user.trips.each_with_index do |trip, i|
                        option.choice name: "Trip #{i + 1} - FROM: #{trip.city_from.name} TO: #{trip.city_to.name}", value: trip
                    end 
                end
                to_edit = @prompt.select("What you wanna change?") do |option|
                    option.choice name: "FROM: #{chosen_trip.city_from.name}", value: "FROM"
                    option.choice name: "TO: #{chosen_trip.city_to.name}", value: "TO"
                end
                new_city = @prompt.select("Choose your new city") do |option|
                    City.all.each do |city|
                        option.choice name: city.name, value: city
                    end
                end
                if to_edit == "FROM"
                    chosen_trip.city_from = new_city
                    edited = true
                else
                    chosen_trip.city_to = new_city
                    edited = true
                end
                puts "\nYou got it, #{@user.name}.\n".green
            end
        end
    end

    def display_trip_list
        system "clear"
        puts "===== DISPLAY TRIPS =====\n\n".yellow
        if @user.trips.length == 0
            puts "You Trippin' Dawg. You Don't Got Any Trips Booked!".red
        else
            puts "#{@user.name}".yellow + ", Here's Yo List of Trips:\n\n"
            @user.trips.each_with_index do |trip, i|
                puts "Trip #{i + 1} - FROM: #{trip.city_from.name} TO: #{trip.city_to.name} - #{trip_distance_miles(trip)} miles".yellow
            end
            puts "\nYou gonna travel #{total_user_distance} miles".green
        end
        puts "\n\n"
    end
    
    def cancel_trip
        system "clear"
        puts "===== CANCEL TRIP =====\n\n".yellow
        destroyed = false
        while destroyed != true do
            if @user.trips.length == 0
                puts "You Trippin' Dawg. You Don't Got Any Trips Booked!\n\n".red
                destroyed = true
            else
                pick_delete = @prompt.select("Pick a Trip to Cancel: ") do |option|
                    @user.trips.each_with_index do |trip, i|
                        option.choice name: "Trip #{i + 1} - FROM: #{trip.city_from.name} TO: #{trip.city_to.name}", value: trip
                    end
                end
                @prompt.select("You sure you wanna cancel this trip?") do |option|
                    option.choice "Yes", -> { 
                        pick_delete.destroy # destroy from database
                        @user.trips.destroy(pick_delete) # destroy from trips
                        puts "\nIght #{@user.name}. Whatever you say.\n".green
                        destroyed = true
                    }
                    option.choice "No", -> { puts "\nThen what you wanna cancel?\n".yellow }
                    option.choice "I don't want to cancel any trips", -> { 
                        puts "\nMake up your mind!\n".yellow
                        destroyed = true
                    }
                end
            end
        end
    end

end

cli = CommandLineInterface.new
cli.account_menu
cli.get_user_menu_selection