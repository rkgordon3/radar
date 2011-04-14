CREATE TABLE "annotations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime, "updated_at" datetime, "text" varchar(255));
CREATE TABLE "areas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime, "abbreviation" varchar(255));
CREATE TABLE "buildings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime, "area_id" integer, "abbreviation" varchar(255));
CREATE TABLE "notification_preferences" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "staff_id" integer, "report_type" varchar(255), "frequency" integer, "time_offset" integer, "scope" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "participants" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "last_name" varchar(255), "cell_phone" varchar(255), "home_phone" varchar(255), "affiliation" varchar(255), "created_at" datetime, "updated_at" datetime, "type" varchar(255), "room_number" varchar(255), "building_id" integer, "student_id" varchar(255), "full_name" varchar(255), "birthday" datetime, "extension" varchar(255), "emContact" varchar(255), "email" varchar(255));
CREATE TABLE "relationship_to_reports" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "description" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "report_participant_relationships" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "relationship_to_report_id" integer, "created_at" datetime, "updated_at" datetime, "participant_id" integer, "report_id" varchar(255));
CREATE TABLE "report_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "reports" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime, "updated_at" datetime, "building_id" integer, "approach_time" datetime, "room_number" varchar(255), "type" varchar(255), "staff_id" integer, "submitted" boolean, "annotation_id" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "sessions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "session_id" varchar(255) NOT NULL, "data" text, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "staffs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(128) DEFAULT '' NOT NULL, "password_salt" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "remember_token" varchar(255), "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "created_at" datetime, "updated_at" datetime, "first_name" varchar(255), "last_name" varchar(255), "access_level" integer, "active" boolean);
CREATE INDEX "index_sessions_on_session_id" ON "sessions" ("session_id");
CREATE INDEX "index_sessions_on_updated_at" ON "sessions" ("updated_at");
CREATE UNIQUE INDEX "index_staffs_on_email" ON "staffs" ("email");
CREATE UNIQUE INDEX "index_staffs_on_reset_password_token" ON "staffs" ("reset_password_token");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110404190052');

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

INSERT INTO schema_migrations (version) VALUES ('20110221214028');

INSERT INTO schema_migrations (version) VALUES ('20110222053343');

INSERT INTO schema_migrations (version) VALUES ('20110222154610');

INSERT INTO schema_migrations (version) VALUES ('20110224070636');

INSERT INTO schema_migrations (version) VALUES ('20110224071402');

INSERT INTO schema_migrations (version) VALUES ('20110224072459');

INSERT INTO schema_migrations (version) VALUES ('20110224074318');

INSERT INTO schema_migrations (version) VALUES ('20110225005807');

INSERT INTO schema_migrations (version) VALUES ('20110227230510');

INSERT INTO schema_migrations (version) VALUES ('20110227231203');

INSERT INTO schema_migrations (version) VALUES ('20110228033038');

INSERT INTO schema_migrations (version) VALUES ('20110228034052');

INSERT INTO schema_migrations (version) VALUES ('20110320205415');

INSERT INTO schema_migrations (version) VALUES ('20110322053011');

INSERT INTO schema_migrations (version) VALUES ('20110322055324');

INSERT INTO schema_migrations (version) VALUES ('20110322060114');

INSERT INTO schema_migrations (version) VALUES ('20110324020241');

INSERT INTO schema_migrations (version) VALUES ('20110324021704');

INSERT INTO schema_migrations (version) VALUES ('20110324022325');

INSERT INTO schema_migrations (version) VALUES ('20110324031752');

INSERT INTO schema_migrations (version) VALUES ('20110324053156');

INSERT INTO schema_migrations (version) VALUES ('20110329003458');

INSERT INTO schema_migrations (version) VALUES ('20110330002836');

INSERT INTO schema_migrations (version) VALUES ('20110401024232');

INSERT INTO schema_migrations (version) VALUES ('20110401031842');

INSERT INTO schema_migrations (version) VALUES ('20110401042314');

INSERT INTO schema_migrations (version) VALUES ('20110403221557');