CREATE TABLE `active_admin_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `author_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `namespace` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_active_admin_comments_on_resource_type_and_resource_id` (`resource_type`,`resource_id`),
  KEY `index_active_admin_comments_on_author_type_and_author_id` (`author_type`,`author_id`),
  KEY `index_active_admin_comments_on_namespace` (`namespace`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_admin_users_on_email` (`email`),
  UNIQUE KEY `index_admin_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `advertisements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `youtube_videoid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `gmaps` tinyint(1) DEFAULT '1',
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `api_talks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_user_id` int(11) DEFAULT NULL,
  `sender_car_id` int(11) DEFAULT NULL,
  `receiver_user_id` int(11) DEFAULT NULL,
  `receiver_car_id` int(11) DEFAULT NULL,
  `contents` blob,
  `received` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `cars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `base_fare` int(11) DEFAULT NULL,
  `meter_fare` int(11) DEFAULT NULL,
  `initial_meter` int(11) DEFAULT NULL,
  `meter_fare_segment` int(11) DEFAULT NULL,
  `access_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `device_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cars_on_user_id` (`user_id`),
  KEY `index_cars_on_device_token` (`device_token`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `check_point_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `check_point_id` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_check_point_statuses_on_report_id` (`report_id`),
  KEY `index_check_point_statuses_on_check_point_id` (`check_point_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `check_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_check_points_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `drivers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_digest` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `device_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_drivers_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `car_id` int(11) DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `gmaps` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_locations_on_car_id` (`car_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `meters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `meter` int(11) DEFAULT '0',
  `mileage` int(11) DEFAULT '0',
  `riding_mileage` int(11) DEFAULT '0',
  `riding_count` int(11) DEFAULT '0',
  `meter_fare_count` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_meters_on_report_id` (`report_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5757 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `minimum_wages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `car_id` int(11) DEFAULT NULL,
  `text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accepted_at` datetime DEFAULT NULL,
  `canceled_at` datetime DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notifications_on_car_id` (`car_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pickup_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `gmaps` tinyint(1) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pickup_locations_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `driver_id` int(11) DEFAULT NULL,
  `car_id` int(11) DEFAULT NULL,
  `mileage` int(11) DEFAULT '0',
  `riding_mileage` int(11) DEFAULT '0',
  `riding_count` int(11) DEFAULT '0',
  `meter_fare_count` int(11) DEFAULT '0',
  `passengers` int(11) DEFAULT '0',
  `sales` int(11) DEFAULT '0',
  `extra_sales` int(11) DEFAULT '0',
  `fuel_cost` int(11) DEFAULT '0',
  `ticket` int(11) DEFAULT '0',
  `edy` int(11) DEFAULT '0',
  `account_receivable` int(11) DEFAULT '0',
  `cash` int(11) DEFAULT '0',
  `surplus_funds` int(11) DEFAULT '0',
  `deficiency_account` int(11) DEFAULT '0',
  `advance` int(11) DEFAULT '0',
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reports_on_driver_id` (`driver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5850 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `rests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `ended_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rests_on_report_id` (`report_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8587 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `rides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `ride_latitude` float DEFAULT NULL,
  `ride_longitude` float DEFAULT NULL,
  `ride_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `leave_latitude` float DEFAULT NULL,
  `leave_longitude` float DEFAULT NULL,
  `leave_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `passengers` int(11) DEFAULT '0',
  `fare` int(11) DEFAULT '0',
  `segment` int(11) DEFAULT '0',
  `started_at` datetime DEFAULT NULL,
  `ended_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rides_on_report_id` (`report_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30760 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `talks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_user_id` int(11) DEFAULT NULL,
  `sender_car_id` int(11) DEFAULT NULL,
  `receiver_user_id` int(11) DEFAULT NULL,
  `receiver_car_id` int(11) DEFAULT NULL,
  `received` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `audio_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `audio_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `audio_file_size` int(11) DEFAULT NULL,
  `audio_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_talks_on_sender_user_id` (`sender_user_id`),
  KEY `index_talks_on_sender_car_id` (`sender_car_id`),
  KEY `index_talks_on_receiver_user_id` (`receiver_user_id`),
  KEY `index_talks_on_receiver_car_id` (`receiver_car_id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `transfer_slips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `report_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `debit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `debit_amount` int(11) DEFAULT NULL,
  `credit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `credit_amount` int(11) DEFAULT NULL,
  `note` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `whole_day` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_transfer_slips_on_report_id` (`report_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `person_in_charge` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authentication_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_username` (`username`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20110930085542');

INSERT INTO schema_migrations (version) VALUES ('20120211223654');

INSERT INTO schema_migrations (version) VALUES ('20120212073713');

INSERT INTO schema_migrations (version) VALUES ('20120312053102');

INSERT INTO schema_migrations (version) VALUES ('20120404114543');

INSERT INTO schema_migrations (version) VALUES ('20121101104057');

INSERT INTO schema_migrations (version) VALUES ('20121101104506');

INSERT INTO schema_migrations (version) VALUES ('20121101111446');

INSERT INTO schema_migrations (version) VALUES ('20121101113501');

INSERT INTO schema_migrations (version) VALUES ('20121101113523');

INSERT INTO schema_migrations (version) VALUES ('20121101113726');

INSERT INTO schema_migrations (version) VALUES ('20121103083038');

INSERT INTO schema_migrations (version) VALUES ('20121104054941');

INSERT INTO schema_migrations (version) VALUES ('20121106043748');

INSERT INTO schema_migrations (version) VALUES ('20121122080934');

INSERT INTO schema_migrations (version) VALUES ('20121123083648');

INSERT INTO schema_migrations (version) VALUES ('20121124063856');

INSERT INTO schema_migrations (version) VALUES ('20121201041626');

INSERT INTO schema_migrations (version) VALUES ('20121202042302');

INSERT INTO schema_migrations (version) VALUES ('20121202042530');

INSERT INTO schema_migrations (version) VALUES ('20121205085018');

INSERT INTO schema_migrations (version) VALUES ('20130131095759');

INSERT INTO schema_migrations (version) VALUES ('20130201033117');

INSERT INTO schema_migrations (version) VALUES ('20130201061721');

INSERT INTO schema_migrations (version) VALUES ('20130207025936');

INSERT INTO schema_migrations (version) VALUES ('20130208074529');

INSERT INTO schema_migrations (version) VALUES ('20130227002803');

INSERT INTO schema_migrations (version) VALUES ('20130317045646');

INSERT INTO schema_migrations (version) VALUES ('20130318084948');

INSERT INTO schema_migrations (version) VALUES ('20130322052759');

INSERT INTO schema_migrations (version) VALUES ('20130326080306');

INSERT INTO schema_migrations (version) VALUES ('20130405230312');

INSERT INTO schema_migrations (version) VALUES ('20130512032841');

INSERT INTO schema_migrations (version) VALUES ('20130516065316');

INSERT INTO schema_migrations (version) VALUES ('20130523033314');

INSERT INTO schema_migrations (version) VALUES ('20130607081801');

INSERT INTO schema_migrations (version) VALUES ('20130624012304');

INSERT INTO schema_migrations (version) VALUES ('20130624080019');

INSERT INTO schema_migrations (version) VALUES ('20130625040610');

INSERT INTO schema_migrations (version) VALUES ('20130702103046');

INSERT INTO schema_migrations (version) VALUES ('20130728123003');

INSERT INTO schema_migrations (version) VALUES ('20130813080442');

INSERT INTO schema_migrations (version) VALUES ('20130823072416');

INSERT INTO schema_migrations (version) VALUES ('20131004031141');

INSERT INTO schema_migrations (version) VALUES ('20131029050549');

INSERT INTO schema_migrations (version) VALUES ('20131115095028');

INSERT INTO schema_migrations (version) VALUES ('20131224085720');

INSERT INTO schema_migrations (version) VALUES ('20131227013610');

INSERT INTO schema_migrations (version) VALUES ('20131227013956');

INSERT INTO schema_migrations (version) VALUES ('20131228214519');

INSERT INTO schema_migrations (version) VALUES ('20131229002905');

INSERT INTO schema_migrations (version) VALUES ('20140222014208');

INSERT INTO schema_migrations (version) VALUES ('20140302005303');

INSERT INTO schema_migrations (version) VALUES ('20140421095955');

INSERT INTO schema_migrations (version) VALUES ('20140423013930');

INSERT INTO schema_migrations (version) VALUES ('20140427145952');

INSERT INTO schema_migrations (version) VALUES ('20140429072149');

INSERT INTO schema_migrations (version) VALUES ('20141104102134');