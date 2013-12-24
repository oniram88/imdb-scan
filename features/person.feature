Feature: Get Person information

  Scenario: Get person information and filmography list from IMDB
    Given I have person with id "0000288"
    When the name should be "Christian Bale"
    When the films where he was actor should be "146"
    When the height of the actor should be "1.83"
    When the photo should be a link to an image
    When the birth date should be "1974-01-30"
    When the real name shoud be "Christian Charles Philip Bale"
    When the profile path shuld be "/name/nm0000288"
