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


# CSV Data File
#
# Bank::Account
#
# The data, in order in the CSV, consists of:
# ID - (Fixnum) a unique identifier for that Account
# Balance - (Fixnum) the account balance amount, in cents (i.e., 150 would be $1.50)
# OpenDate - (Datetime) when the account was opened



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
        attr_accessor :name, :address, :array_of_accounts
        attr_reader :owner_id_number

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
    end


    ##CREATES A BANK ACCOUNT CLASS - stores id number, balance, and time it was opened
    class Account
        attr_reader :account_id, :time_opened, :account_hash
        attr_accessor :initial_balance, :account_balance
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
                balance = account[1].to_f/100
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
#Bank::Account.pretty_print
ap Bank::Account.all
ap Bank::Account.find(1214)
















# puts ###Syntax to make Terminal Output more clear (for me..)####
# puts
# puts "LET'S CREATE A NEW USER AND TWO ACCOUNTS FOR THAT USER"
# nina_owner = Bank::Owner.new(43, "Nina Mutty", "1234 West 1st St, Seattle, WA, 98102") #Creates a new user/owner with name, address, and id
# nina_owner.add_account(1432, 5000, "time now")           #Creates two new accounts that are stored in the Bank::Owner.array_of_accounts (each new account is a new array value)
# nina_owner.add_account(14312, 400, "new time")
#
#
#
# puts
# puts
# puts "LETS PRINT OUT OUR USER'S BANKING INFORMATION"
# nina_owner.print_banking_info #prints nina_owner banking information
# # sam_owner.print_banking_info #prints sam_owner banking information
#
#
# puts
# puts "LETS TRY WITHDRAWALS FROM USER 1 FIRST ACCOUNT"
# nina_owner.array_of_accounts[0].withdraw(6000) #withdraws from nina_owner account 1 - test overdrawn warning
# nina_owner.array_of_accounts[0].withdraw(300) #withdraws from nina_owner account 1 (do one that passes)
#
# puts
# puts "LETS TRY DEPOSITS TO USER 1 SECOND ACCOUNT"
# nina_owner.array_of_accounts[1].deposit(200) #deposits to nina_ownder account 2
#
#
# puts
# puts "LETS REPRINT USER 1 BANKING INFORMATION"
# nina_owner.print_banking_info #reprints nina_owner banking information

# Bank::Account.new #(1212, 1235667, "3/27/99 11:30")




# account_hash = {}
# CSV.open("support/accounts.csv", 'r').each do |line|
#     #@account_hash[:line[0]] = {balance: line[1], date_time: line[2]}
#     account_hash[:line[0]] = Bank::Account.new(line[0], line[1].to_f, line[2])
#     puts "Added a loop account"
# end
#
# ap account_hash










# ### TESTS FOR OWNER BEFORE ACCOUNT
# nina = Bank::Owner.new("Nina", "Fake address")
# nina.add_account
# nina.add_account
# nina.print_banking_info
#
#
# puts "\nHello! Are you a new user? "
# new_yes_no = strip_puncuation(gets.chomp.downcase)
# until new_yes_no == "yes" || new_yes_no == "no"
#     puts "\nPlease enter 'yes' or 'no'."
#     new_yes_no = strip_puncuation(gets.chomp.downcase)
# end
# if new_yes_no == "yes"
#     puts "What's your name? "
#     new_account_name = gets.chomp.downcase
#     puts "What's your address? "
#     new_account_address = gets.chomp.downcase #### TAKE THE USER INPUT USING ADDRESS GEM ###
#     user1 = Bank::Owner.new(new_account_name, new_account_address)
# end


###ASK IF THEY WANT TO CREATE NEW ACCOUNT _ RUN THROUGH THW OTHER STUFF (ALTHOUGH MAYBE CSV FILES)




##########################
###INTERACTIONS BELOW ####
##########################

#Creating a new account
# puts "\nDo you want to open a new account? "
# yes_no = strip_puncuation(gets.chomp.downcase)
# until yes_no == "yes" || yes_no == "no"
#     puts "\nPlease enter 'yes' or 'no'."
#     yes_no = strip_puncuation(gets.chomp.downcase)
# end
# if yes_no == 'yes'
#     puts "\nWhat's your name? "
#     new_account_user_name = gets.chomp.downcase
#     puts "\nHow much money do you have for your initial balance? "
#     initial_moneys = gets.chomp.to_f
#     new_account = Bank::Account.new(initial_moneys)
# end
#
#
#
# ### BELOW IS ALL THE USER INTERACTIONS AND ACTIONS ###
# again_yes_no = "yes"
# while again_yes_no == "yes"
#     puts """\nWhat can I help you with?
#         1. Withdrawal
#         2. Deposit
#         3. Check Balance
#         4. Exit"""
#     command = gets.chomp.downcase
#     case command
#     when "1", "1.", "withdrawal"
#         new_account.withdraw
#     when "2", "2.", "deposit"
#         new_account.deposit
#     when "3", "3.", "check balance", "balance"
#         new_account.check_balance
#     when "exit", "4", "4."
#         puts "\nHave a nice day #{new_account_user_name}! I hope I fulfilled all your banking needs!"
#         exit
#     else
#         puts "I'm sorry, I can't do that for you"
#     end
#
#     #Asks if user wants to do another thing
#     puts "\nWould you like to complete another activity? "
#     again_yes_no = strip_puncuation(gets.chomp.downcase)
#     until again_yes_no == "yes" || again_yes_no == "no"
#         puts "\nPlease enter 'yes' or 'no'."
#         again_yes_no = strip_puncuation(gets.chomp.downcase)
#     end
# end
#
# puts "\nHave a nice day #{new_account_user_name}! I hope I fulfilled all your banking needs!"





######## INTERACTIVE ACCOUNT ADD FOR OWNER ###########
# def add_account
#     puts "\nLet's create a new account for #{@name}! \nHow much money do you have for your initial balance? "
#     initial_moneys = Float(strip_puncuation(gets.chomp)) rescue nil
#     until initial_moneys != nil
#         puts "\nThat's not a number! I need numbers to start a bank account - try again: "
#         initial_moneys = Float(strip_puncuation(gets.chomp)) rescue nil
#     end
#     @array_of_accounts.push(Account.new(account_id, initial_moneys, time_opened))
# end


#### INTERACTIVE ACCOUNT METHODS #####
# def withdraw
#     print "\nHow much would you like to withdraw? "
#     amount = Float(strip_puncuation(gets.chomp)) rescue nil
#     if (@account_balance - amount) < 0
#         puts "Warning: you cannot overdraw your account. Your balance is  still $#{"%.10g" % ("%.2f" % @account_balance)}."
#     else
#         @account_balance -= amount
#         puts "Your new balance is: $#{("%.2f" % @account_balance)}"
#     end
#     return @account_balance
# end
#
# def deposit
#     print "\nHow much would you like to deposit? "
#     amount = Float(strip_puncuation(gets.chomp)) rescue nil
#     @account_balance += amount
#     puts "Your new balance is: $#{("%.2f" % @account_balance)}"
#     return @account_balance
# end