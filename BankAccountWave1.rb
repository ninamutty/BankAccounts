##############################
### Learning Goals: Wave 2 ###
##############################
    # Create and use class methods
    # Use a CSV file for loading data

##############################
### Requirements: Wave 2 ###
##############################
    # Update the Account class to be able to handle all of these fields from the CSV file used as input.
    # For example, manually choose the data from the first line of the CSV file and ensure you can create a new instance of your Account using that data
    # Add the following class methods to your existing Account class
        # self.all - returns a collection of Account instances, representing all of the Accounts described in the CSV. See below for the CSV file specifications
        # self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter


#################################
####   WHAT I'M WORKING ON   ####
#################################
#Make comments and clean up below file
#Test methods (withdraw and deposit)
#Combine files csv files????? Would make everything easier...




require 'csv'
require 'awesome_print'
require 'chronic'  ##For time.now in account creation default

#LEARNING GOALS: Wave 1
# 1. Create a class inside a module
# 2. Create methods inside the *class to perform actions
# 3. Learn how Ruby does error handling

#Strips puncuation from a string
def strip_puncuation(words)
    words.delete!("!" + "#" + "$")
    return words
end

module Bank
    class Owner
        attr_accessor :name, :address, :array_of_accounts, :account_id
        attr_reader :owner_id_number
        @@owner_hash = {}

        def initialize(owner_id, name, address)
            @name = name
            @address = address
            @owner_id_number = owner_id
            @array_of_accounts = []
            puts "\nYou've created a new owner: #{@name}"
        end

        def add_account(account_id, initial_moneys, time_opened)
            @array_of_accounts.push(Account.new(account_id, initial_moneys, time_opened))
        end

        def print_accounts
            count = 1
            @array_of_accounts.each do |i|
                puts "      Account number #{i.account_id}: balance = $#{("%.2f" % i.account_balance)}"
                count += 1
            end
        end

        def print_banking_info
            return "----------------------------------"
            return "\nYour banking information is:
    Name: #{@name}
    Address: #{@address}
    ID Number: #{@owner_id_number}
    Accounts: "
    print_accounts
            puts "----------------------------------"
        end


        def self.gets_csv_info
            CSV.open("support/owners.csv", 'r').each do |owner|
                id = owner[0]
                name = {first: owner[2], last: owner[1]}
                address = {street: owner[3], city: owner[4], state: owner[5]}
                @@owner_hash[id] = {name: name, address: address}
            end
            CSV.open("support/account_owners.csv", "r").each do |line|
                key = line[1] #Owner id numbers
                @account_id = line[0] #Account id numbers
                @@owner_hash[key][:accounts] = Bank::Account.find(@account_id.to_s)
            end
        end

        def self.pretty_print ##Prints with strings - doesn't return a value - I wanted this because it was prettier..
            @@owner_hash.each do |key, value|
                puts "ID NUMBER: #{key} --- NAME: #{value[:name][:first]} #{value[:name][:last]} --- ADDRESS: #{value[:address][:street]}, #{value[:address][:city]}, #{value[:address][:state]} --- ACCOUNT NUMBER: #{@account_id} --- ACCOUNT BALANCE: #{value[:accounts][:balance]} --- DATE OPENED: #{value[:accounts][:date_time]}"
                puts
            end
        end

        def self.all
            @@owner_hash
        end

        ### FINDS BALANCE AND DATA/TIME ACCOUNT CREATED BASED ON ACCOUNT ID
        def self.find(id_number)
            @@owner_hash.fetch(id_number.to_s)
        end
    end


    ##CREATES A BANK ACCOUNT CLASS - stores id number, balance, and time it was opened
    class Account
        attr_reader :account_id, :time_opened
        attr_accessor :initial_balance, :account_balance, :account_hash
        @@account_hash = {}

        ##TAKE OUT ALL DEFAULT VALUES BECAUSE IT DOESN'T LIKE THAT..
        def initialize(id, initial_balance, time_opened)
            @account_id = id
            raise ArgumentError, ":cannot create an account with an initial balance less than $0.00" if initial_balance < 0
            @initial_balance = initial_balance
            @account_balance = @initial_balance
            @time_opened = time_opened
        end

        def withdraw(amount)
            if (@account_balance - amount) < 0
                puts "Warning: you cannot overdraw your account. Your balance is  still $#{"%.10g" % ("%.2f" % @account_balance)}."
            else
                @account_balance -= amount
                puts "Your new balance is: $#{("%.2f" % @account_balance)}"
            end
            return @account_balance
        end

        def deposit(amount)
            @account_balance += amount
            puts "Your new balance is: $#{("%.2f" % @account_balance)}"
            return @account_balance
        end

        def check_balance
            puts "Your current balance is: $#{("%.2f" % @account_balance)}"
        end

        ####### CLASS METHODS #########

        ####### CSV ACCOUNT INFORMATION ######
        ## PSEUDOCODE ##
        #Create an empty accounts hash - id numbers will be keys and other info will be values
        #Open csv file of accounts - run each loop for each line
            #id number (line[0]) is a hash key : will store another hash
                #balance is a key with account balance, and time is key with time opened
            # New account(hash[id], Hash[id][balance], hash[id][time])
        #end

        ### REAL CODE ### ------- THIS IS A SELF METHOD !!ACCOUNT
        def self.gets_csv_info
            CSV.open("support/accounts.csv", 'r').each do |account|
                key = account[0]
                balance = account[1].to_f/100 ##Converts to dollars
                date_time = account[2]
                @@account_hash[key] = {balance: balance, date_time: date_time}
            end
        end

        def self.pretty_print ##Prints with strings - doesn't return a value - I wanted this because it was prettier..
            @@account_hash.each do |key, value|
                puts "ACCOUNT NUMBER: #{key} --- BALANCE: #{value[:balance]} --- DATE OPENED: #{value[:date_time]}"
            end
        end

        def self.all
            @@account_hash
        end

        ### FINDS BALANCE AND DATA/TIME ACCOUNT CREATED BASED ON ACCOUNT ID
        def self.find(id_number)
            @@account_hash.fetch(id_number.to_s)
        end

    end
end

Bank::Account.gets_csv_info
# #Bank::Account.pretty_print
# ap Bank::Account.all
# ap Bank::Account.find(1214)

Bank::Owner.gets_csv_info
puts "pretty print"
Bank::Owner.pretty_print
#puts "all"
#ap Bank::Owner.all
# puts "find id 22"
# ap Bank::Owner.find(22)
