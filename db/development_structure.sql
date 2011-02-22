CREATE TABLE "areas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime, "abbreviation" varchar(255));
CREATE TABLE "buildings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime, "area_id" integer, "abbreviation" varchar(255));
CREATE TABLE "infractions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "description" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "participants" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "last_name" varchar(255), "cell_phone" varchar(255), "home_phone" varchar(255), "affiliation" varchar(255), "age" integer, "created_at" datetime, "updated_at" datetime, "type" varchar(255), "photo_id" integer, "room_number" varchar(255), "building_id" integer);
CREATE TABLE "photos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "url" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "reported_infractions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "infraction_id" integer, "created_at" datetime, "updated_at" datetime, "participant_id" integer, "incident_report_id" varchar(255));
CREATE TABLE "reports" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime, "updated_at" datetime, "building_id" integer, "approach_time" datetime, "annotation" varchar(255), "room_number" varchar(255), "type" varchar(255), "staff_id" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "staffs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(128) DEFAULT '' NOT NULL, "password_salt" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "remember_token" varchar(255), "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "created_at" datetime, "updated_at" datetime, "first_name" varchar(255), "last_name" varchar(255), "role" varchar(255));
CREATE UNIQUE INDEX "index_staffs_on_email" ON "staffs" ("email");
CREATE UNIQUE INDEX "index_staffs_on_reset_password_token" ON "staffs" ("reset_password_token");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110221214028');

INSERT INTO schema_migrations (version) VALUES ('20110203033619');

INSERT INTO schema_migrations (version) VALUES ('20110203034553');

INSERT INTO schema_migrations (version) VALUES ('20110203034729');

INSERT INTO schema_migrations (version) VALUES ('20110203040931');

INSERT INTO schema_migrations (version) VALUES ('20110203041011');

INSERT INTO schema_migrations (version) VALUES ('20110203154858');

INSERT INTO schema_migrations (version) VALUES ('20110203160338');

INSERT INTO schema_migrations (version) VALUES ('20110203160940');

INSERT INTO schema_migrations (version) VALUES ('20110203162055');

INSERT INTO schema_migrations (version) VALUES ('20110203192145');

INSERT INTO schema_migrations (version) VALUES ('20110209204339');

INSERT INTO schema_migrations (version) VALUES ('20110209210601');

INSERT INTO schema_migrations (version) VALUES ('20110210021208');

INSERT INTO schema_migrations (version) VALUES ('20110210044703');

INSERT INTO schema_migrations (version) VALUES ('20110210044854');

INSERT INTO schema_migrations (version) VALUES ('20110210052355');

INSERT INTO schema_migrations (version) VALUES ('20110210052713');

INSERT INTO schema_migrations (version) VALUES ('20110210053839');

INSERT INTO schema_migrations (version) VALUES ('20110210054705');

INSERT INTO schema_migrations (version) VALUES ('20110210055425');

INSERT INTO schema_migrations (version) VALUES ('20110210060941');

INSERT INTO schema_migrations (version) VALUES ('20110210143811');

INSERT INTO schema_migrations (version) VALUES ('20110210145553');

INSERT INTO schema_migrations (version) VALUES ('20110210154221');

INSERT INTO schema_migrations (version) VALUES ('20110210160201');

INSERT INTO schema_migrations (version) VALUES ('20110210160305');

INSERT INTO schema_migrations (version) VALUES ('20110210161345');

INSERT INTO schema_migrations (version) VALUES ('20110214081313');

INSERT INTO schema_migrations (version) VALUES ('20110214082036');

INSERT INTO schema_migrations (version) VALUES ('20110214085055');

INSERT INTO schema_migrations (version) VALUES ('20110216064728');

INSERT INTO schema_migrations (version) VALUES ('20110216065046');

INSERT INTO schema_migrations (version) VALUES ('20110216070446');

INSERT INTO schema_migrations (version) VALUES ('20110216070954');

INSERT INTO schema_migrations (version) VALUES ('20110216071348');

INSERT INTO schema_migrations (version) VALUES ('20110217173444');

INSERT INTO schema_migrations (version) VALUES ('20110217173824');

INSERT INTO schema_migrations (version) VALUES ('20110217174337');

INSERT INTO schema_migrations (version) VALUES ('20110217174612');

INSERT INTO schema_migrations (version) VALUES ('20110217175314');

INSERT INTO schema_migrations (version) VALUES ('20110219052457');

INSERT INTO schema_migrations (version) VALUES ('20110219055357');

INSERT INTO schema_migrations (version) VALUES ('20110219062729');

INSERT INTO schema_migrations (version) VALUES ('20110219063324');

INSERT INTO schema_migrations (version) VALUES ('20110219065353');

INSERT INTO schema_migrations (version) VALUES ('20110219070612');

INSERT INTO schema_migrations (version) VALUES ('20110219074253');

INSERT INTO schema_migrations (version) VALUES ('20110219221415');

INSERT INTO schema_migrations (version) VALUES ('20110219230617');

INSERT INTO schema_migrations (version) VALUES ('20110221200021');

INSERT INTO schema_migrations (version) VALUES ('20110221214027');