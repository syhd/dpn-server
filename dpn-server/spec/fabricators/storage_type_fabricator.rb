Fabricator(:storage_type) do
  name do
    sequence(:name, 50) do |i|
      "storage_type_#{i}"
    end
  end
end