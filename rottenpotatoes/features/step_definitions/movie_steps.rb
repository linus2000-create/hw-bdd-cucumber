# Add a declarative step here for populating the DB with movies.
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /(\d+) seed movies should exist/ do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.body.should =~ /#{Regexp.escape(e1)}.*#{Regexp.escape(e2)}/m
end

# Make it easier to express checking or unchecking several boxes at once
# "When I uncheck the following ratings: PG, G, R"
# "When I check the following ratings: G"
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(', ').each do |rating|
    if uncheck
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end

Then /I should see all the movies/ do
  Movie.all.each do |movie|
    expect(page).to have_content(movie.title)
  end
end

# Additional steps to support filtering and checking movie visibility
Then /I should see the following movies:$/ do |movies_table|
  movies_table.raw.flatten.each do |movie|
    expect(page).to have_content(movie)
  end
end

Then /I should not see the following movies:$/ do |movies_table|
  movies_table.raw.flatten.each do |movie|
    expect(page).not_to have_content(movie)
  end
end
