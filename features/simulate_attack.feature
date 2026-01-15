Feature: Simulate an attack on the walls.
As a user, I want to be able to simulate an attack on the walls, so that I can estimate potential chances of survival.

  Scenario: Attack ending in defeat
    Given the following titans are in the database
      | name     | power | is_special |
      | Armored  | 60    | true       |
      | Pure     | 13    | false      |
      | Colossus | 90    | true       |
      | Abnormal | 24    | false      |
    And the following student squads are in the database
      | name   | num_members | group    | state    |
      | Hange  | 6           | scout    | active   |
      | Hannes | 4           | garrison | active   |
      | Erwin  | 6           | scout    | inactive |
      | Levi   | 6           | scout    | active   |
      | Armin  | 4           | scout    | inactive |
      | Annie  | 4           | police   | active   |
      | Connie | 5           | scout    | active   |
    When I navigate to the "simulate attack" page
    And I click on the "simulate" button
    Then I can see on the page the result is "Defeat! The Titans have won."
