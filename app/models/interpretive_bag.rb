class InterpretiveBag < Bag
  has_and_belongs_to_many :data_bags, :uniq => true, :join_table => "data_interpretive"
end