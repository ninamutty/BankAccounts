#LEARNING GOALS:
# 1. Create a class inside a module
# 2. Create methods inside the *class to perform actions
# 3. Learn how Ruby does error handling

#Strips puncuation from a string
def strip_puncuation(words)
    words.delete!("!" + "." + "," + "#")
    return words
end

module Bank
    class Account
        attr_reader :id
        attr_accessor :initial_balance, :account_balance

        def initialize(id=rand(100000..999999), initial_balance)
            @id = id #FIND A WAY TO MAKE SURE THE ID CAN'T BE REPEATED LATER ON
            raise ArgumentError, ":cannot create an account with an initial balance less than $0.00" if initial_balance < 0
            @initial_balance = initial_balance
            @account_balance = @initial_balance
            puts "\nYou've created a new account!"
        end

        def withdraw
            print "How much would you like to withdraw? "
            amount = gets.chomp.to_f
            if (@account_balance - amount) < 0
                puts "Warning: you cannot overdraw your account. Your balance is  still $#{@account_balance}."
            else
                @account_balance -= amount
                puts "Your new balance is: $#{@account_balance}"
            end
            return @account_balance
        end

        def deposit
            print "How much would you like to deposit? "
            amount = gets.chomp.to_f
            @account_balance += amount
            puts "Your new balance is: $#{@account_balance}"
            return @account_balance
        end

        def check_balance
            puts "Your current balance is: $#{@account_balance}"
        end
    end
end


#Creating a new account
puts "\nDo you want to open a new account? "
yes_no = strip_puncuation(gets.chomp.downcase)
until yes_no == "yes" || yes_no == "no"
    puts "\nPlease enter 'yes' or 'no'."
    yes_no = strip_puncuation(gets.chomp.downcase)
end
if yes_no == 'yes'
    puts "\nWhat's your name? "
    new_account_user_name = gets.chomp.downcase
    puts "\nHow much money do you have for your initial balance? "
    initial_moneys = gets.chomp.to_f
    new_account = Bank::Account.new(initial_moneys)
end



### BELOW IS ALL THE USER INTERACTIONS AND ACTIONS ###
again_yes_no = "yes"
while again_yes_no == "yes"
    puts """\nWhat can I help you with?
        1. Withdrawal
        2. Deposit
        3. Check Balance
        4. Exit"""
    command = gets.chomp.downcase
    case command
    when "1", "1.", "withdrawal"
        new_account.withdraw
    when "2", "2.", "deposit"
        new_account.deposit
    when "3", "3.", "check balance", "balance"
        new_account.check_balance
    when "exit", "4", "4."
        puts "\nHave a nice day #{new_account_user_name}! I hope I fulfilled all your banking needs!"
        exit
    else
        puts "I'm sorry, I can't do that for you"
    end

    #Asks if user wants to do another thing
    puts "\nWould you like to complete another activity? "
    again_yes_no = strip_puncuation(gets.chomp.downcase)
    until again_yes_no == "yes" || again_yes_no == "no"
        puts "\nPlease enter 'yes' or 'no'."
        again_yes_no = strip_puncuation(gets.chomp.downcase)
    end
end

puts "\nHave a nice day #{new_account_user_name}! I hope I fulfilled all your banking needs!"
