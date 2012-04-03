# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! movie
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  e1_index = page.body.index(e1)
  assert e1_index != nil, "Expected #{e1} to be found in #{page.body}"

  e2_index = page.body.index(e2)
  assert e2_index != nil, "Expected #{e2} to be found in #{page.body}"

  assert e1_index < e2_index, "Expected #{e1_index} to be less than #{e2_index}"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  action = uncheck ? 'uncheck' : 'check'
  ratings = rating_list.split(',')
  ratings.each do |rating|
    step 'I ' + action  + ' "ratings_' + rating.strip + '"'
  end
end

Then /I should see all of the movies/ do
  rows = all("table#movies tr").count - 1
  assert rows.should == Movie.all.count
end

Then /I should see none of the movies/ do
  rows = all("table#movies tr").count - 1
  assert rows.should == 0
end

