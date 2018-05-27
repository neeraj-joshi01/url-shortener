class BalancedParenthesis
	def initialize
		@input_string = gets.chomp
		@stack_array = []
	end
	
	def check_if_balanced
		hash_mapping = {
			')' => '(',
			']' => '[',
			'}' => '{'
		}
		balanced_parenthesis = false
		@input_string.split('').each do |val|
			if %w(\( [ {).include?(val)
				push_to_stack(val)
			else
				popped_value = pop_from_stack
				balanced_parenthesis = (hash_mapping[val] == popped_value)
				if !balanced_parenthesis
					break
				end
			end
		end
		
		if @stack_array.empty?
			puts balanced_parenthesis.to_s.capitalize
		else
			puts 'False'
		end
	end
	
	def push_to_stack(val)
		@stack_array.push(val)
	end
	
	def pop_from_stack
		@stack_array.pop
	end
end

BalancedParenthesis.new.check_if_balanced