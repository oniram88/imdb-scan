Feature: Search IMDB
  Scenario: Search a movie in imdb
    Given I have keyword "District 9" for the search
    Then the result should be equal or greater than 1
  Scenario: For some unique results, imdb redirects directly to movie page, in that cases, there is no search-results page
    Given I have keyword "Wo ist Fred" for the search
    Then the result should be equal to 1
    And the first title should be "Wo ist Fred? (2006)"
  Scenario: Search a film that have many results
    Given I have keyword "Match Point" for the search
    Then The result 0416320 should be unique in the list

