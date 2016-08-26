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
            @min_balance = 0
            @transaction_fee = 0
            #puts "You've initialized"
        end

        def withdraw(amount)
            if (@account_balance - amount) < @min_balance
                puts "\nWarning: This withdrawal will result in your account having a balance less than $#{@min_balance - @transaction_fee}. We cannot allow you to make this tansaction. Your balance is still $#{'%.10g' % ('%.2f' % @account_balance)}."
            else
                @account_balance -= amount
                @account_balance -= @transaction_fee
                puts "Withdrew $#{amount} - Your new balance is: $#{('%.2f' % @account_balance)}"
            end
            return @account_balance
        end

        def deposit(amount)
            @account_balance += amount
            puts "Deposited $#{amount} - Your new balance is: $#{('%.2f' % @account_balance)}"
            return @account_balance
        end

        def check_balance
            puts "Your current balance is: $#{('%.2f' % @account_balance)}"
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

    ######################################
    ###  REQUIREMENTS: SavingsAccount  ###
    ######################################
    # Create a SavingsAccount class which should inherit behavior from the Account class. It should include the following updated functionality:

    # The initial balance cannot be less than $10. If it is, this will raise an ArgumentError
    # Updated withdrawal functionality:
        # Each withdrawal 'transaction' incurs a fee of $2 that is taken out of the balance.
        # Does not allow the account to go below the $10 minimum balance - Will output a warning message and return the original un-modified balance

    # It should include the following new method:
        # #add_interest(rate): Calculate the interest on the balance and add the interest to the balance. Return the interest that was calculated and added to the balance (not the updated balance).
        # Input rate is assumed to be a percentage (i.e. 0.25).
        # The formula for calculating interest is balance * rate/100
            # Example: If the interest rate is 0.25% and the balance is $10,000, then the interest that is returned is $25 and the new balance becomes $10,025.


    class SavingsAccount < Account

        def initialize(hash_of_one_account) #(id, initial_balance, time_opened)
            super
            raise ArgumentError, ": cannot create an account with an initial balance less than $10.00" if hash_of_one_account[:balance] < 10
        end


        def withdraw(amount)
            store_min_balance = @min_balance
            @transaction_fee = 2
            @min_balance += (10 + @transaction_fee)
            puts "\nThere is a $#{@transaction_fee} charge for withdrawing money from a Savings Account."
            super
            @transaction_fee = 0
            @min_balance = store_min_balance
            return @account_balance
        end


        def add_interest(rate)
            #balance * rate/100
            @account_balance += @account_balance * rate/100
            return "Your new balance is $#{('%.2f' % @account_balance)}"
        end
    end


    #######################################
    ###  REQUIREMENTS: CheckingAccount  ###
    #######################################
    # Create a CheckingAccount class which should inherit behavior from the Account class. It should include the following updated functionality:

    # Updated withdrawal functionality:
        # Each withdrawal 'transaction' incurs a fee of $1 that is taken out of the balance. Returns the updated account balance.
            # Does not allow the account to go negative. Will output a warning message and return the original un-modified balance.
        # #withdraw_using_check(amount): The input amount gets taken out of the account as a result of a checks withdrawal. Returns the updated account balance.
            # Allows the account to go into overdraft up to -$10 but not any lower
            # The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
        # #reset_checks: Resets the number of checks used to zero

    class CheckingAccount < Account

        def initialize(hash_of_one_account)
            super
            @checks = 0
        end

        def withdraw(amount)
            store_min_balance = @min_balance
            @transaction_fee = 1
            @min_balance = (0 + @transaction_fee)
            puts "\nThere is a $#{@transaction_fee} charge for withdrawing money from a Checking Account."
            super
            @transaction_fee = 0
            @min_balance = store_min_balance
            return @account_balance
        end


        def withdraw_using_check (amount)
            store_min_balance = @min_balance
            @checks += 1
            if @checks <= 3
                @transaction_fee = 1
            else
                puts "There is a $2.00 fee for using a check."
                @transaction_fee = 3
            end
            @min_balance = (-10 + @transaction_fee)
            if (@account_balance - amount) < @min_balance
                puts "\nWarning: This withdrawal will result in your account having a balance less than $#{@min_balance - @transaction_fee}. We cannot allow you to make this tansaction. Your balance is still $#{'%.10g' % ('%.2f' % @account_balance)}."
                @checks -= 1
            else
                @account_balance -= amount
                @account_balance -= @transaction_fee
                puts "Withdrew $#{amount} - Your new balance is: $#{('%.2f' % @account_balance)}"
            end
            puts "\nYou have used #{@checks} checks this month."
            return @account_balance
        end

        def reset_checks
            @checks = 0
        end

    end

    ########################################
    ###  OPTIONALS: MoneyMarketsAccount  ###
    ########################################







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


        #############################
        ### EDIT BELOW 3 METHODS ####
        #############################

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

            # Bank::Account.gets_csv_info
            # # Bank::Account.pretty_print
            # @owners_by_account_id = {}

            # CSV.open("support/account_owners.csv", "r").each do |line|
            #     owner_id = line[1] #Owner id numbers
            #     @account_id = line[0].to_i #Account id numbers
            #     @owners_by_account_id[@account_id] = @@owner_hash[owner_id]
            #     ####THIS IS A HASH WHERE THE KEY IS THE ACCOUNT ID NUMBER AND THE VALUE IS THE OWNER ID OWNER INFORMATION
            # end
            #
            # #Prints owner number 1213
            # ap @owners_by_account_id[1212]
            # ap
            # #ap Bank::Account.find(1212)
            # #ap @@account_hash  #### PRINT THE ACCOUNT HASH GENERATED IN THE ACCOUNT CLASS
            #
            #
            #
            # ##################
            # ### STUCK HERE ###
            # ##################
            # @owners_by_account_id.each do |id|   ####### HOW DO I SHOVEL THIS INFORMATION IN??? ######
            #     ### PSUEDOCODE
            #     # in the owners_by_account_id hash - for each account_id number key, the value is a hash of the owner's information. I want to put their account information in that hash soooooo, we need to add an @account to each person's account with the correct account id - WITHOUT RESETING THE HASH VALUE
            #
            #     if id.@owner_id_number  #### WUUUUTTTT  ########
            #         id.@accounts.push(@@account_hash[id])          #### UGH... ### THIS IS HARD...
            #     end
            # end

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


# Bank::Owner.gets_csv_info
# puts "\nSAVINGS"
# test_savings = Bank::SavingsAccount.new({account_id: 4444, balance: 10000, date_time: 02/04/2000})
# ap test_savings.withdraw(600000)
# ap test_savings.withdraw(500)
# ap test_savings.add_interest(0.25)


puts "\nCHECKING"
test_savings = Bank::CheckingAccount.new({account_id: 4444, balance: 1000, date_time: 02/04/2000})
#ap test_savings.withdraw(600000)
#ap test_savings.withdraw(500)
# puts "1"
# ap test_savings.withdraw_using_check(1000)
# ap test_savings.deposit(1000)

# puts "2"
# ap test_savings.withdraw_using_check(1010)
# ap test_savings.deposit(1000)
#
# puts "3"
# ap test_savings.withdraw_using_check(1009)
# ap test_savings.deposit(1000)
#
# puts "4"
# ap test_savings.withdraw_using_check(1)
# ap test_savings.withdraw_using_check(1)
# ap test_savings.withdraw_using_check(1)
# ap test_savings.withdraw_using_check(1001)
# #ap test_savings.deposit(1000)



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
