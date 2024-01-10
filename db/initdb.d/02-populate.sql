INSERT INTO `product` (`name`, `price`, `width`, `height`, `depth`, `weight`)
VALUES
	('Oral-B iO 9N', 230.00, 181, 259, 99, 980),
	('Gillette Fusion Lamette Da Barba', 36.99, 110, 252, 24, 140),
	('Aerosol Portatile Silenzioso', 33.84, 146, 66, 151, 250),
	('Giubotto di pelle per moto', 189.00, 400, 600, 200, 3000),
	('Casco AGV K6-S', 479.95, 150, 300, 300, 1500),
	('Marvel\'s Spider-Man Miles Morales', 44.95, 130, 170, 15, 10),
	('LG 27GP950 UltraGear Gaming Monitor 27" UltraHD', 753.82, 609, 291, 574, 7900),
	('Giubbotto Riscaldato 10000mAh', 63.17, 425, 660, 300, 800),
	('Bomboletta Graffiti', 7.00, 65, 200, 65, 410),
	('Design Patterns: Elements of Reusable Object-Oriented Software', 18.92, 194, 237, 264, 885);

INSERT INTO `user` (`first_name`, `last_name`, `mail`, `birthdate`, `password`)
VALUES
	('Gianluca', 'Recchia', 'g.recchia@desolabs.com', '1997-09-16', SHA2('grecchia', 0)),
	('Cristian', 'Gramegna', 'c.gramegna@desolabs.com', '2005-05-02', SHA2('cgramegna', 0)),
	('Francesco', 'Grimaldi', 'f.grimaldi@desolabs.com', '1997-05-09', SHA2('fgrimaldi', 0));