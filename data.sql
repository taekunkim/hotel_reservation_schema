INSERT INTO guest VALUES
(DEFAULT, 'Jonathan Ferrari', '500 Broadway', STR_TO_DATE('10-08-1970', '%m-%d-%Y')), -- guest_id 1
(DEFAULT, 'Andrew Yang', '100 Main St', STR_TO_DATE('08-01-2015', '%m-%d-%Y')),       --          2
(DEFAULT, 'Chanyi Kim', '123 Douglas St', STR_TO_DATE('05-23-1999', '%m-%d-%Y'));     --          3

INSERT INTO hostess VALUES
(DEFAULT, 'lewiskim@gmail.com'),
(DEFAULT, 'lewiskim@gmail.com'),
(DEFAULT, 'lewiskim@gmail.com');

INSERT INTO property VALUES
(DEFAULT, 1, 1, 1, 2, '300 A St');

INSERT INTO rental VALUES
(DEFAULT, 1, 1, STR_TO_DATE('10-01-2020', '%m-%d-%Y'), 1, 0000000000000000);

INSERT INTO additional_guest VALUES
(1, 2); -- validadditional_guesthostess
-- (1, 3); -- max num_guest exceeded

INSERT INTO rating VALUES
(DEFAULT, 'hostess', 1, 1, 5), -- valid
(DEFAULT, 'property', 2, 1, 5); -- valid
-- (DEFAULT, 'hostess', 2, 1, 5); -- is not renter
-- (DEFAULT, 'property', 3, 1, 5); -- is not guest