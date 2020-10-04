DELIMITER $$
CREATE TRIGGER renter_age BEFORE INSERT ON rental
FOR EACH ROW
BEGIN
   IF (
		NOT EXISTS(
			SELECT *
			FROM guest
			WHERE id_guest = NEW.id_renter AND DATE_SUB(NEW.start_week, INTERVAL 18 YEAR) > date_of_birth 
        )
	) THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Renter too young';
   END IF;
END; $$

DELIMITER $$
CREATE TRIGGER num_guest_limit BEFORE INSERT ON additional_guest
FOR EACH ROW
BEGIN
	SET @num_guest = (
		SELECT COUNT(*)
		FROM additional_guest
		WHERE id_rental = NEW.id_rental
	);
			
	SET @id_property = (
		SELECT id_property
		FROM rental
		WHERE id_rental = NEW.id_rental
	);
			
	SET @capacity = (
		SELECT capacity
		FROM property
		WHERE id_property = @id_property
	);
    
   IF ((@num_guest + 1) = @capacity)
   THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Guest number limit exceeded';
   END IF;
END; $$

DELIMITER $$
CREATE TRIGGER rating_validation BEFORE INSERT ON rating
FOR EACH ROW
BEGIN
   IF (
		NEW.rating_type = 'property' 
        AND
        NEW.id_guest NOT IN (
			SELECT id_guest
			FROM additional_guest
            WHERE id_rental = NEW.id_rental
        )
	)THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Must stay at the property';
   
   ELSEIF(
		NEW.rating_type = 'hostess' 
        AND
        NEW.id_guest NOT IN (
			SELECT id_renter
			FROM rental
            WHERE id_rental = NEW.id_rental
		)
   )THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Must be the renter who stayed at the property';
   
   END IF;
END; $$

DELIMITER $$
CREATE TRIGGER email_duplicates BEFORE INSERT ON hostess
FOR EACH ROW
BEGIN
	SET @email_duplicates = (
		SELECT COUNT(*)
		FROM hostess
		WHERE email = NEW.email
	);
    
   IF (@email_duplicates = 2)
   THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Email taken';
   END IF;
END; $$