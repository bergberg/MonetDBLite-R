if (Sys.getenv("NOT_CRAN", unset="no") != "no") {
if (Sys.getenv("MONETDBLITE_INMEMORY", unset="no") == "yes") {
	dbfolder <- ":memory:"
} else {
	dbfolder <- file.path(tempdir(), "dbidir")
}
message("test_03: using ", dbfolder)

DBItest::make_context(MonetDBLite::MonetDBLite(), dbfolder, tweaks=DBItest::tweaks(
	date_cast=function(x) paste0("CAST('", x, "' AS DATE)"),
	time_cast=function(x) paste0("CAST('", x, "' AS TIME)"),
	timestamp_cast=function(x) paste0("CAST('", x, "' AS TIMESTAMP)"),
	omit_blob_tests=TRUE,
	strict_identifier=TRUE
))

# TODO: get data_64_bit_numeric_warning / data_64_bit_lossless right
# TODO fix NULL IS NULL in SQL parser
# TODO fix roundtrip_time/roundtrip_timestamp/roundtrip_field_types

skip <- c("package_name", "send_query_only_one_result_set", "send_statement_only_one_result_set", "data_64_bit_numeric_warning", "data_64_bit_lossless", "quote_string_na_is_null", "roundtrip_64_bit_numeric", "roundtrip_64_bit_character", "roundtrip_time", "roundtrip_timestamp", "roundtrip_field_types", "get_info_result", "overwrite_table_missing", "compliance", "get_query_n_bad", "get_query_good_after_bad_n", "data_timestamp", "read_table_row_names_false", "read_table_row_names_default", "roundtrip_numeric_special", "cannot_forget_disconnect")

DBItest::test_all(skip=skip)

MonetDBLite::monetdblite_shutdown()
warnings()
}
