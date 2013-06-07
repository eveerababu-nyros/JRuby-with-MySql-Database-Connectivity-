require 'java'
require 'jdbc/mysql'

class JRubyWithJdbc
		#Creating connection and statement object
	def initialize
		@connection = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/jruby", "root", "root")
		@statement = @connection.createStatement
		crudOperations
	end
		#calling crudOperations
	def crudOperations
		puts "JRuby CRUD Operations which operation do you want process"
		puts "1. Read"
		puts "2. Create"
		puts "3. Update"
		puts "4. Delete"
		puts "Enter your Option"
		option = gets.chomp.to_i
		case option
			when 1 
				readOperation
			when 2
				insertOperation
			when 3
				updateOperation
			when 4
				deleteOperation
			else
				puts "Wrong Input Please try again"
				crudOperations
		end
	end

		#Gathering data from the database and displaying in the console
	def readOperation
		begin
			resultset = @statement.executeQuery "select * from products"
			puts "========================================================================"
			puts "Product_Number \t Product_Name \t Product_Quantity \t Product_Cost "
			puts "========================================================================"
			while resultset.next do
				puts " \t#{resultset.getInt('proid')} \t\t #{resultset.getString('product_name')} \t\t#{resultset.getInt('product_qty')} \t\t#{resultset.getInt('product_cost')}"
			end
			puts "========================================================================="
				#Closing the connections 
			@connection.close
			@statement.close
			resultset.close
		rescue Exception => e
			puts e.message
		end
			
	end

		#Inserting records into table
	def insertOperation
		puts "Enter Product Id"
		proid = gets.chomp.to_i
		puts "Enter Product Name"
		proname = gets.chomp
		proname = "'"+proname+"'"
		puts "Enter Product Quantity"
		proqty = gets.chomp.to_i
		puts "Enter Product Cost"
		procost = gets.chomp.to_i	
			
		begin
			result = @statement.executeUpdate("insert into products values(#{proid},#{proname},#{proqty},#{procost})")
			if result
				puts "Record Inserted Successfully..........."
			else
				puts "Error Occur while inserting Record"
			end
				#Closing the Connections
			@connection.close
			@statement.close
		rescue Exception => e
			puts e.message
		end
	end

		#Updating the product name only 
	def updateOperation
		puts "Enter which product to update (Product Id)"
		pro_id = gets.chomp.to_i
		puts "Enter new Product name to change"
		proname = gets.chomp
		proname = "'"+proname+"'"
		begin
			result = @statement.executeUpdate("update products set product_name = #{proname} where proid = #{pro_id}")
			if result
				puts "record updated successfully"
			else
				puts "not updated"
			end
		rescue Exception => e
			puts e.message
		end
		@connection.close
		@statement.close
	end

		#Deleting Particular record from the product table
	def deleteOperation
		puts "Enter which record do you want to delete (Product Id)"
		pro_id = gets.chomp.to_i
		begin
			result = @statement.executeUpdate("delete from products where proid = #{pro_id}")
			if result
				puts "Record deleted successfully"
			else
				puts "Record doesnot deleted"
			end
		rescue Exception => e
			puts e.message
		end
		@connection.close
		@statement.close
	end
end

JRubyWithJdbc.new
