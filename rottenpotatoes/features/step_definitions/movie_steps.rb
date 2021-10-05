# Add a declarative step here for populating the DB with movies.
#Movie.add("The Matrix",
#"R",
#"Neo (Keanu Reeves) believes that Morpheus (Laurence Fishburne), an elusive figure considered to be the most dangerous man alive, can answer his question -- What is the Matrix? Neo is contacted by Trinity (Carrie-Anne Moss), a beautiful stranger who leads him into an underworld where he meets Morpheus. They fight a brutal battle for their lives against a cadre of viciously intelligent secret agents. It is a truth that could cost Neo something more precious than his life.",
#)

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
   @movie = Movie.create!(movie)
  end
  #fail "Unimplemented"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  rows = rows = page.find("table#movies tbody").all(:css,"tr")
  e1_row = Float::INFINITY
  e2_row = Float::INFINITY
  it = 0
  rows.each do |row|
    if row.all(:css,"td")[0].text == e1
      e1_row = it
    elsif row.all(:css,"td")[0].text == e2
      e2_row = it
    end
    it += 1
  end
  # Make sure movies were actually found
  expect(e1_row).should_not be Float::INFINITY
  expect(e2_row).should_not be Float::INFINITY
  # make sure e1 found first
  expect(e1_row).to be < e2_row
  
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if uncheck == true
    rating_list.each do |rating|
      steps %Q{When I uncheck #{rating}}
    end
  elsif uncheck == false
    rating_list.each do |rating|
      steps %Q{When I check #{rating}}
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  rows = page.find("table#movies tbody").all(:css,"tr").size
  expect(rows).to eq Movie.count
end
