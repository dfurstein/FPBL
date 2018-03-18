class Array
    def cumulative_sum
        sum = 0
        self.map{|x| sum += x}
    end
end