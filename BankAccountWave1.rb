require 'awesome_print'

#LEARNING GOALS:
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
        attr_reader :id_number

        def initialize(name, address)
            @name = name
            @address = address
            @id_number = rand(100000..999999) #This isn't unique - multiple users could have same id number...
            @array_of_accounts = []
            puts "\nYou've created a new owner: #{@name}"
        end

        def add_account
            puts "\nLet's create a new account for #{@name}! \nHow much money do you have for your initial balance? "
            initial_moneys = Float(strip_puncuation(gets.chomp)) rescue nil
                until initial_moneys != nil
                    puts "\nThat's not a number! I need numbers to start a bank account - try again: "
                    initial_moneys = Float(strip_puncuation(gets.chomp)) rescue nil
                end
            @array_of_accounts.push(Account.new(@id_number, initial_moneys))
        end

        def print_accounts
            count = 1
            @array_of_accounts.each do |i|
                puts "      Account #{count} balance - $#{("%.2f" % i.account_balance)}"
                count += 1
            end
        end

        def print_banking_info
            puts "----------------------------------"
            puts "\nYour banking information is:
    Name: #{@name}
    Address: #{@address}
    ID Number: #{@id_number}
    Accounts: "
    print_accounts
            puts "----------------------------------"
        end
    end

    class Account
        attr_reader :id
        attr_accessor :initial_balance, :account_balance

        def initialize(id, initial_balance)
            @id = id #FIND A WAY TO MAKE SURE THE ID CAN'T BE REPEATED LATER ON
            raise ArgumentError, ":cannot create an account with an initial balance less than $0.00" if initial_balance < 0
            @initial_balance = initial_balance
            @account_balance = @initial_balance
            puts "You've created a new account!"
        end

        def withdraw
            print "\nHow much would you like to withdraw? "
            amount = Float(strip_puncuation(gets.chomp)) rescue nil
            if (@account_balance - amount) < 0
                puts "Warning: you cannot overdraw your account. Your balance is  still $#{"%.10g" % ("%.2f" % @account_balance)}."
            else
                @account_balance -= amount
                puts "Your new balance is: $#{("%.2f" % @account_balance)}"
            end
            return @account_balance
        end

        def deposit
            print "\nHow much would you like to deposit? "
            amount = Float(strip_puncuation(gets.chomp)) rescue nil
            @account_balance += amount
            puts "Your new balance is: $#{("%.2f" % @account_balance)}"
            return @account_balance
        end

        def check_balance
            puts "Your current balance is: $#{("%.2f" % @account_balance)}"
        end
    end

end

puts ###Syntax to make Terminal Output more clear (for me..)####
puts
puts "LET'S CREATE A NEW USER AND TWO ACCOUNTS FOR THAT USER"
nina_owner = Bank::Owner.new("Nina Mutty", "1234 West 1st St, Seattle, WA, 98102") #Creates a new user/owner with name, address, and id
nina_owner.add_account #Creates two new accounts that are stored in the Bank::Owner.array_of_accounts (each new account is a new array value)
nina_owner.add_account

puts
puts
puts "LET'S CREATE ANOTHER NEW USER AND THREE ACCOUNTS FOR THAT USER"
sam_owner = Bank::Owner.new("Sam Mutty", "4567 East 2nd Ave, Seattle, WA, 98102") #creates another new user
sam_owner.add_account #Creates three accounts for sam user
sam_owner.add_account
sam_owner.add_account


puts
puts
puts "LETS PRINT OUT OUR USER'S BANKING INFORMATION"
nina_owner.print_banking_info #prints nina_owner banking information
sam_owner.print_banking_info #prints sam_owner banking information


puts
puts "LETS TRY WITHDRAWALS FROM USER 1 FIRST ACCOUNT"
nina_owner.array_of_accounts[0].withdraw #withdraws from nina_owner account 1 - test overdrawn warning
nina_owner.array_of_accounts[0].withdraw #withdraws from nina_owner account 1 (do one that passes)

puts
puts "LETS TRY DEPOSITS TO USER 1 SECOND ACCOUNT"
nina_owner.array_of_accounts[1].deposit #deposits to nina_ownder account 2


puts
puts "LETS REPRINT USER 1 BANKING INFORMATION"
nina_owner.print_banking_info #reprints nina_owner banking information

















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
