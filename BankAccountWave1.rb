##############################
### Learning Goals: Wave 2 ###
##############################
    # Create and use class methods
    # Use a CSV file for loading data

##############################
###  Requirements: Wave 2  ###
##############################
    # Update the Account class to be able to handle all of these fields from the CSV file used as input.
    # For example, manually choose the data from the first line of the CSV file and ensure you can create a new instance of your Account using that data
    # Add the following class methods to your existing Account class
        # self.all - returns a collection of Account instances, representing all of the Accounts described in the CSV. See below for the CSV file specifications
        # self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter


#################################
####   WHAT I'M WORKING ON   ####
#################################
# COMBINE USER ID'S NUMBERS WITH ACCOUNTS - NEED TO SHOVEL INTO AN ARRAY OF ACCOUNTS FOR EACH OWNER (AROUND LINE 200)
# FIX UP OWNER METHODS WITH UPDATED HASH/ARRAY STRUCTURES - BASE OFF OF ACCOUNT CLASS
# ADD WAVE THREE CHILD CLASSES




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
    ##################################
    ###  Creates Various Accounts  ###
    ##################################

    ##CREATES A BANK ACCOUNT CLASS - stores id number, balance, and time it was opened
    class Account
        attr_reader :account_id, :time_opened
        attr_accessor :initial_balance, :account_balance, :account_hash
        @@account_hash = {}

        ##TAKE OUT ALL DEFAULT VALUES BECAUSE IT DOESN'T LIKE THAT..
        def initialize(hash_of_one_account) #(id, initial_balance, time_opened)
            @account_id = hash_of_one_account[:account_id]
             raise ArgumentError, ": cannot create an account with an initial balance less than $0.00" if hash_of_one_account[:balance] < 0
            @initial_balance = hash_of_one_account[:balance]
            @account_balance = @initial_balance
            @time_opened = hash_of_one_account[:date_time]
            #puts "You've initialized"
        end

        def withdraw(amount)
            if (@account_balance - amount) < 0
                puts "Warning: you cannot overdraw your account. Your balance is  still $#{"%.10g" % ("%.2f" % @account_balance)}."
            else
                @account_balance -= amount
                puts "Withdrew $#{amount} - Your new balance is: $#{("%.2f" % @account_balance)}"
            end
            return @account_balance
        end

        def deposit(amount)
            @account_balance += amount
            puts "Deposited $#{amount} - Your new balance is: $#{("%.2f" % @account_balance)}"
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
                account_id = account[0]
                balance = account[1].to_f/100 ##Converts to dollars
                date_time = account[2]
                new_account = {account_id: account_id, balance: balance, date_time: date_time}
                @@account_hash[account_id] = self.new(new_account)
            end

        end


        def self.pretty_print ##Prints with strings - doesn't return a value - I wanted this because it was prettier..
            @@account_hash.each_value do |value|
                puts "ACCOUNT NUMBER: #{value.account_id} --- BALANCE: $#{value.account_balance} --- DATE OPENED: #{value.time_opened}"
            end
        end

        def self.all
            @@account_hash
        end

        ### FINDS BALANCE AND DATA/TIME ACCOUNT CREATED BASED ON ACCOUNT ID
        def self.find_pretty(id)
            search = id.to_s
            return "ACCOUNT NUMBER: #{@@account_hash[search].account_id} --- BALANCE: $#{@@account_hash[search].account_balance} --- DATE OPENED: #{@@account_hash[search].time_opened}"
        end

        def self.find(id)
            search = id.to_s
            return @@account_hash[search]
        end
    end

    # class SavingsAccount < Account
    #
    # end












    #########################
    ###  Creates Ownners  ###
    #########################

    class Owner
        attr_accessor :name, :address, :account_id, :owners_by_account_id, :account_hash, :owner_id_number
        attr_reader :owner_id_number, :fullname, :fulladdress, :array_of_accounts
        @@owner_hash = {}
        @@account_hash = Bank::Account.all

        def initialize(hash_of_one_owner)
            @owner_id_number = hash_of_one_owner[:owner_id]
            @name = hash_of_one_owner[:name]
            @fullname = "#{@name[:first]} #{@name[:last]}"
            @address = hash_of_one_owner[:address]
            @fulladdress = "#{@address[:street]}, #{@address[:city]}, #{@address[:state]}"
            @accounts = []  #### ARRAY OF OWNER'S INDIVIDUAL ACCOUNTS
            #puts "\nYou've created a new owner: #{@fullname}"
        end


        ####THIS ADDS TO A SPECIFIC OWNER - NOT JUST A NEW ACCOUNT
        def add_account
            @array_of_accounts.push(Account.new(account_hash))
        end

        def print_accounts
            count = 1
            array_of_accounts.each do |i|
                puts " Account number #{i.account_id}: balance = $#{("%.2f" % i.account_balance)}"
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
                owner_id = owner[0]
                name = {first: owner[2], last: owner[1]}
                address = {street: owner[3], city: owner[4], state: owner[5]}
                new_owner = {owner_id: owner_id, name: name, address: address}
                @@owner_hash[owner_id] = self.new(new_owner)
            end

            Bank::Account.gets_csv_info
            # Bank::Account.pretty_print
            @owners_by_account_id = {}

            CSV.open("support/account_owners.csv", "r").each do |line|
                owner_id = line[1] #Owner id numbers
                @account_id = line[0].to_i #Account id numbers
                @owners_by_account_id[@account_id] = @@owner_hash[owner_id]
                ####THIS IS A HASH WHERE THE KEY IS THE ACCOUNT ID NUMBER AND THE VALUE IS THE OWNER ID OWNER INFORMATION

            end

            ap @owners_by_account_id[1213]

            #ap Bank::Account.find(1212)
            #ap @@account_hash  #### PRINT THE ACCOUNT HASH GENERATED IN THE ACCOUNT CLASS

            ##################
            ### STUCK HERE ###
            ##################
            @owners_by_account_id.each do |id|   ####### HOW DO I SHOVEL THIS INFORMATION IN??? ######
                ### PSUEDOCODE
                # in the owners_by_account_id hash - for each account_id number key, the value is a hash of the owner's information. I want to put their account information in that hash soooooo, we need to add @@account_hash with the correct account id - WITHOUT RESETING THE HASH VALUE
                if id.owner_id_number == @@owner_hash.key    #### WUUUUTTTT  ########
                    @accounts << Bank::Account.find(id)
                end

            end
        end




        def self.pretty_print ##Prints with strings - doesn't return a value - I wanted this because it was prettier..
            @owners_by_account_id.each_value do |value|
                puts "ID NUMBER: #{value.owner_id_number} --- NAME: #{value.fullname} --- ADDRESS: #{value.fulladdress} --- ACCOUNT NUMBER: #{@account_id}" #--- ACCOUNT BALANCE: #{value[:accounts][:balance]} --- DATE OPENED: #{value[:accounts][:date_time]}"

                ##########################################################
                ### Figured out how to finish printing/combining above ###
                ##########################################################

                puts
            end
        end

        ##########################
        ##  REDO THESE METHODS  ##
        ##########################

        def self.all
            @owners_by_account_id
        end

        ### FINDS BALANCE AND DATA/TIME ACCOUNT CREATED BASED ON ACCOUNT ID
        def self.find(id_number)
            @@owner_hash.fetch(id_number.to_s).pretty_print
        end
    end
end

# Bank::Account.gets_csv_info
# Bank::Account.pretty_print
#ap Bank::Account.all


# account = Bank::Account.new(account_id: 1234, balance: 3000, date_time: "today")
# puts account.account_id
# puts account.account_balance
# puts account.time_opened


Bank::Owner.gets_csv_info
#ap Bank::Owner.all
# puts "pretty print"
# Bank::Owner.pretty_print
# #puts "all"
#ap Bank::Owner.all
# puts "find id 22"
# ap Bank::Owner.find(22)


###############################
##### BANK ACCOUNT TESTS ######
###############################

# ap Bank::Account.find(1212)
# ap Bank::Account.find_pretty(15156)
# Bank::Account.find(15156).withdraw(100)
# ap Bank::Account.find_pretty(15156)
# puts
# ap Bank::Account.find_pretty(15156)
# Bank::Account.find(15156).deposit(100)
# ap Bank::Account.find_pretty(15156)
# puts
#
# Bank::Account.find(15156).check_balance




# Bank::Account.account_hash[:15156].withdraw(50)
