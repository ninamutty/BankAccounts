#################################################
### WELCOME TO MY BANK - I HOPE YOU ENJOY IT  ###
#################################################

require 'csv'
require 'awesome_print'

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
        attr_reader :account_id, :time_opened, :initial_balance, :account_balance, :account_hash
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
            return "\nDeposited $#{amount} - Your new balance is: $#{('%.2f' % @account_balance)}"
            r#eturn @account_balance
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
            return @@account_hash
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
    # Create a MoneyMarketAccount class which should inherit behavior from the Account class.
    #
    # A maximum of 6 transactions (deposits or withdrawals) are allowed per month on this account type
    # The initial balance cannot be less than $10,000 - this will raise an ArgumentError
    # Updated withdrawal logic:
        # If a withdrawal causes the balance to go below $10,000, a fee of $100 is imposed and no more transactions are allowed until the balance is increased using a deposit transaction.
        # Each transaction will be counted against the maximum number of transactions
    # Updated deposit logic:
        # Each transaction will be counted against the maximum number of transactions
        # Exception to the above: A deposit performed to reach or exceed the minimum balance of $10,000 is not counted as part of the 6 transactions.
    # #add_interest(rate): Calculate the interest on the balance and add the interest to the balance. Return the interest that was calculated and added to the balance (not the updated balance).
        # Note** This is the same as the SavingsAccount interest.
        # #reset_transactions: Resets the number of transactions to zero


    class MoneyMarketsAccount < Account
        attr_reader :transactions, :account_balance
        MAX_TRANSACTIONS = 6
        MINIMUM_MONEY = 10000
        FINE = 100

        def initialize(hash_of_one_account)
            super
            raise ArgumentError, ": cannot create an account with an initial balance less than $10,000" if hash_of_one_account[:balance] < MINIMUM_MONEY
            @transactions = 0
        end

        def withdraw(amount)
            if @transactions >= MAX_TRANSACTIONS
                return "\nWARNING: You have reached the limit of #{MAX_TRANSACTIONS} transactions. Cannot complete this transaction."
            elsif @account_balance < MINIMUM_MONEY
                return "\nWARNING: Your account balance is below the minimum requirement of $#{MINIMUM_MONEY}. Cannot complete the transaction - you must desposit money into your account. \nYour balance is: $#{('%.2f' % @account_balance)}"

            elsif (@account_balance - amount) < MINIMUM_MONEY
                @account_balance -= amount
                @account_balance -= FINE
                return "\nWARNING: Account balance is now below minimum requirement of $#{MINIMUM_MONEY}. You will be fined a fee of $#{FINE}. Must deposit money into account before completing any other transactions. \nYour new balance is: $#{('%.2f' % @account_balance)}"
            else
                @transactions += 1
                @account_balance -= amount
                puts "Withdrew $#{amount} - Your new balance is: $#{('%.2f' % @account_balance)}"
            end
        end

        def deposit(amount)
            if @account_balance < MINIMUM_MONEY
                if (@account_balance + amount) >= MINIMUM_MONEY
                    super
                else
                    return "\nYou are below the minimum allowed balance of #{MINIMUM_MONEY}. You must deposit enough money to reach the minimum - cannot complete the transaction."
                end
            elsif @transactions >= MAX_TRANSACTIONS
                return "\nWARNING: You have reached the limit of #{MAX_TRANSACTIONS} transactions. Cannot complete this transaction."
            else
                @transactions += 1
                super
            end
        end

        def add_interest(rate)
            #balance * rate/100
            @account_balance += @account_balance * rate/100
            return "Your new balance is $#{('%.2f' % @account_balance)}"
        end

        def reset_transactions
            @transactions = 0
        end
    end


    #########################
    ###  Creates Ownners  ###
    #########################

    class Owner
        attr_accessor :name, :address, :account_id, :owners_by_account_id, :account_hash, :owner_id_number
        attr_reader :owner_id_number, :fullname, :fulladdress, :array_of_accounts, :accounts
        @@owner_hash = {}
        #@@account_hash = Bank::Account.all

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
        def add_account(account)
            @accounts.push(account)
        end

        def self.gets_csv_info
            CSV.open("support/owners.csv", 'r').each do |owner|
                owner_id = owner[0]
                name = {first: owner[2], last: owner[1]}
                address = {street: owner[3], city: owner[4], state: owner[5]}
                new_owner = {owner_id: owner_id, name: name, address: address}
                @@owner_hash[owner_id] = self.new(new_owner)
            end

            account_hash = Bank::Account.gets_csv_info
            # Bank::Account.pretty_print
            @owners_by_account_id = {}
            #puts @owners_by_account_id

            CSV.open("support/account_owners.csv", "r").each do |line|
                owner_id = line[1] #Owner id numbers
                @account_id = line[0] #Account id numbers
                @owners_by_account_id[@account_id] = owner_id
            end

            account_hash.each do |key, value|
                @@owner_hash[@owners_by_account_id[key]].add_account(value)
            end
            return @@owner_hash
        end


        ###CLASS METHOD PRETTY PRINT
        def self.pretty_print ##Prints with strings - doesn't return a value - I wanted this because it was prettier..
            @@owner_hash.each_value do |value|
                return """***********************************************************
ID NUMBER: #{value.owner_id_number}
NAME: #{value.fullname}
ADDRESS: #{value.fulladdress}
ACCOUNTS:
    ACCOUNT NUMBER: #{value.accounts[0].account_id}
    ACCOUNT BALANCE: #{value.accounts[0].account_balance}
    DATE OPENED: #{value.accounts[0].time_opened}
***********************************************************"""
            end
        end

        def self.all
            @@owner_hash
        end

        ### FINDS BALANCE AND DATA/TIME ACCOUNT CREATED BASED ON ACCOUNT ID
        def self.find(id_number)
            @@owner_hash.fetch(id_number.to_s)
        end

        def self.find_and_pretty_print(id_number)
            owner = @@owner_hash.fetch(id_number.to_s)
            return """*************************************************
ID NUMBER: #{owner.owner_id_number}
NAME: #{owner.fullname}
ADDRESS: #{owner.fulladdress}
ACCOUNTS:
    ACCOUNT NUMBER: #{owner.accounts[0].account_id}
    ACCOUNT BALANCE: #{owner.accounts[0].account_balance}
    DATE OPENED: #{owner.accounts[0].time_opened}
***********************************************"""
        end

    end
end






##################
###  MY TESTS  ###
##################


Bank::Owner.gets_csv_info        ###### NEED THIS TO RUN THRHOUGH THE CSV FILES
# puts Bank::Owner.pretty_print
#ap Bank::Owner.all
ap Bank::Owner.find(22)
puts
puts Bank::Owner.find_and_pretty_print(22)





# account = Bank::Account.new(account_id: 1234, balance: 3000, date_time: "today")
# puts account.account_id
# puts account.account_balance
# puts account.time_opened


# puts "STARTS TOO LOW"
# money_market = Bank::MoneyMarketsAccount.new(account_id: 1234, balance: 3000, date_time: "today")
#

# puts "OVERDRAWN"
# money_market = Bank::MoneyMarketsAccount.new(account_id: 1234, balance: 10000, date_time: "today")
# puts money_market.deposit(30)
# puts money_market.withdraw(100)
# puts money_market.withdraw(10)
# puts money_market.deposit(5)
# puts money_market.transactions
# puts money_market.deposit(250)
# puts money_market.transactions

# puts "TOO MANY TRANSACTIONS"
# money_market2 = Bank::MoneyMarketsAccount.new(account_id: 1234, balance: 40000, date_time: "today")
# puts money_market2.withdraw(10)
# puts money_market2.withdraw(10)
# puts money_market2.withdraw(10)
# puts money_market2.withdraw(10)
# puts money_market2.deposit(50)
# puts money_market2.deposit(50)
# puts money_market2.deposit(50)
# puts money_market2.deposit(50)
# puts money_market2.transactions

# puts "INTEREST"
# money_market = Bank::MoneyMarketsAccount.new(account_id: 1234, balance: 10000, date_time: "today")
# puts money_market.add_interest(0.25)




# Bank::Owner.gets_csv_info
# puts "\nSAVINGS"
#test_savings = Bank::SavingsAccount.new({account_id: 4444, balance: 9, date_time: 02/04/2000})
# ap test_savings.withdraw(600000)
# ap test_savings.withdraw(500)
# ap test_savings.add_interest(0.25)


# puts "\nCHECKING"
# test_savings = Bank::CheckingAccount.new({account_id: 4444, balance: 1000, date_time: 02/04/2000})
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
