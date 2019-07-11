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
        fork{ exec 'afplay', "audio/The_Next_Episode_Instrumental.mp3"}
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
            option.choice "EXIT", -> { 
                exit_program
                exit
            }
        end
    end

    def login
        puts "===== WELCOME TO LOGIN =====\n\n".yellow
        logged_in = false
        while logged_in == false
            user_name = @prompt.ask("What is your name?", default: "User")
            user = User.find_by(name: user_name)
            if user == nil # if user does not exist in DB
                puts "\nWe don't know no #{user_name}. (We do not have a user with that name.)\n".red
                @prompt.select("You want to be part of the club?") do |option|
                    option.choice "Yes", -> { 
                        register
                        logged_in = true
                    }
                    option.choice "No", -> { 
                        puts "\nG E T   O U T T A    H E R E !\n".red.bold
                        fork{ exec 'killall', "afplay"}
                        exit
                    }
                    option.choice "I'm actually someone else"
                end
            else
                @user = user
                puts "\nAyy #{@user.name}! How's you been?\n".green
                logged_in = true
            end
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
                    exit_program
                    done = true
                }
            end
        end
    end

    def show_top_trips
    	top_dest = Trip.group(:city_to).count
      if top_dest.length >= 5
        top_dest = top_dest.sort{|t1, t2| t2[1] <=> t1[1]}[0..4]
        puts "Top 5 Destinations:"
      else
      	puts "Top Destinations:"
      end
      top_dest.each_with_index do |trip, i|
      	puts "#{i + 1}. #{trip[0].name}"
      end
      puts "\n"
    end

    def book_trip
        system "clear"
        puts "===== BOOK TRIP =====\n\n".yellow
        if Trip.all.length > 0
        	show_top_trips
        end
        booked = false
        while booked != true do 
            user_city_from = @prompt.select("What city you located at?") do |option|
                City.all.each do |city|
                    option.choice name: city.name, value: city
                end
                option.choice "Return to Main Menu", -> { booked = true }
            end
            if booked == false
                user_city_to = @prompt.select("What city you traveling to?") do |option|
                    City.all.each do |city|
                        option.choice name: city.name, value: city
                    end
                    option.choice "Return to Main Menu", -> { booked = true }
                end
                if booked == false
                    if user_city_from == user_city_to
                        puts "\nYou're too high, #{@user.name}. You already there!\n".red
                    else
                        @user.trips.create(city_from: user_city_from, city_to: user_city_to)
                        puts "\nBooked that trip for you. I gotchu!\n".green
                        booked = true
                    end
                end
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
                    option.choice "Return to Main Menu", -> { edited = true }
                end

                if edited == false
                    edited = edit_chosen_trip(chosen_trip)
                end
            end
        end
    end

    def edit_chosen_trip(chosen_trip)
        did_edit = false
        @prompt.select("What you wanna change?") do |option|
            option.choice "FROM: #{chosen_trip.city_from.name}", -> { 
                choosing_city_to_edit("FROM", chosen_trip) 
                did_edit = true
            }
            option.choice "TO: #{chosen_trip.city_to.name}", -> { 
                choosing_city_to_edit("TO", chosen_trip) 
                did_edit = true
            }
            option.choice "Go Back", -> {}
        end
        did_edit
    end

    def choosing_city_to_edit(to_edit, chosen_trip)
        new_city = @prompt.select("Choose your new city") do |option|
            City.all.each do |city|
                option.choice name: city.name, value: city
            end
        end
        if to_edit == "FROM"
            chosen_trip.city_from = new_city # updates city_from
            chosen_trip.save # updates DB
        else
            chosen_trip.city_to = new_city # updates city_to
            chosen_trip.save # updates DB
        end
        chosen_trip.save
        puts "\nYou got it, #{@user.name}.\n".green
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
                    option.choice "Return to Main Menu", -> { destroyed = true }
                end
                if destroyed == false
                    @prompt.select("You sure you wanna cancel this trip?") do |option|
                        option.choice "Yes", -> { 
                            pick_delete.destroy # destroy from database
                            @user.trips.destroy(pick_delete) # destroy from trips
                            puts "\nIght #{@user.name}. Whatever you say.\n".green
                            destroyed = true
                        }
                        option.choice "No", -> { puts "\nMake up your mind!\n\nThen what you wanna cancel?\n".yellow }
                    end
                end
            end
        end
    end

    def exit_program
        system "clear"
        marijuana
        puts "\n\t\t\t\t\t\tStay safe. Don't trip.\n".yellow
        fork{ exec 'killall', "afplay" }
        sleep(0.1.seconds)
        fork{ exec 'afplay', "audio/Smoke_Weed_Everyday.mp3"}
        sleep(2.seconds)
    end

end

cli = CommandLineInterface.new
cli.account_menu
cli.get_user_menu_selection