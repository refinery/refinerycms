new Test.Unit.Runner({
	setup: function() {
		I18n.defaultLocale = "en";
		I18n.locale = null;

		I18n.translations = {
			en: {
				hello: "Hello World!",
				greetings: {
					stranger: "Hello stranger!",
					name: "Hello {{name}}!"
				},
				profile: {
					details: "{{name}} is {{age}}-years old"
				},
				inbox: {
					one: "You have {{count}} message",
					other: "You have {{count}} messages",
					zero: "You have no messages"
				},
				unread: {
					one: "You have 1 new message ({{unread}} unread)",
					other: "You have {{count}} new messages ({{unread}} unread)",
					zero: "You have no new messages ({{unread}} unread)"
				},
				number: null
			},

			pt: {
				hello: "Olá Mundo!",
				date: {
					formats: {
						"default": "%d/%m/%Y",
						"short": "%d de %B",
						"long": "%d de %B de %Y"
					},
				    day_names: ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"],
				    abbr_day_names: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
				    month_names: [null, "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"],
				    abbr_month_names: [null, "Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"]
				},
				number: {
					percentage: {
						format: {
							delimiter: "",
							separator: ",",
							precision: 2
						}
					}
				},
				time: {
					formats: {
						"default": "%A, %d de %B de %Y, %H:%M h",
						"short": "%d/%m, %H:%M h",
						"long": "%A, %d de %B de %Y, %H:%M h"
					},
					am: "AM",
					pm: "PM"
				}
			}
		}
	},

	teardown: function() {
	},

	// Defaults
	testDefaults: function() { with(this) {
		assertEqual("en", I18n.defaultLocale);
		assertEqual(null, I18n.locale);
		assertEqual("en", I18n.currentLocale());
	}},

	// Custom locale
	testCustomLocale: function() { with(this) {
		I18n.locale = "pt";
		assertEqual("pt", I18n.currentLocale());
	}},

	// Aliases methods
	testAliasesMethods: function() { with(this) {
		assertEqual(I18n.translate, I18n.t);
		assertEqual(I18n.localize, I18n.l);
		assertEqual(I18n.pluralize, I18n.p);
	}},

	// Translation for single scope
	testTranslationForSingleScope: function() { with(this) {
		assertEqual("Hello World!", I18n.translate("hello"));
	}},

	// Translation as object
	testTranslationAsObject: function() { with(this) {
		assertEqual("object", typeof I18n.translate("greetings"));
	}},

	// Translation with invalid scope shall not block
	testTranslationWithInvalidScope: function() { with(this) {
		assertEqual('[missing "en.invalid.scope.shall.not.block" translation]', I18n.translate("invalid.scope.shall.not.block"));
	}},

	// Translation for single scope on a custom locale
	testTranslationForSingleScopeOnACustomLocale: function() { with(this) {
		I18n.locale = "pt";
		assertEqual("Olá Mundo!", I18n.translate("hello"));
	}},

	// Translation for multiple scopes
	testTranslationForMultipleScopes: function() { with(this) {
		assertEqual("Hello stranger!", I18n.translate("greetings.stranger"));
	}},

	// Single interpolation
	testSingleInterpolation: function() { with(this) {
		actual = I18n.translate("greetings.name", {name: "John Doe"});
		assertEqual("Hello John Doe!", actual);
	}},

	// Multiple interpolations
	testMultipleInterpolations: function() { with(this) {
		actual = I18n.translate("profile.details", {name: "John Doe", age: 27});
		assertEqual("John Doe is 27-years old", actual);
	}},

	// Translation with count option
	testTranslationWithCountOption: function() { with(this) {
		assertEqual("You have 1 message", I18n.translate("inbox", {count: 1}));
		assertEqual("You have 5 messages", I18n.translate("inbox", {count: 5}));
		assertEqual("You have no messages", I18n.translate("inbox", {count: 0}));
	}},

	// Translation with count option and multiple placeholders
	testTranslationWithCountOptionAndMultiplePlaceholders: function() { with(this) {
		actual = I18n.translate("unread", {unread: 5, count: 1});
		assertEqual("You have 1 new message (5 unread)", actual);

		actual = I18n.translate("unread", {unread: 2, count: 10});
		assertEqual("You have 10 new messages (2 unread)", actual);

		actual = I18n.translate("unread", {unread: 5, count: 0});
		assertEqual("You have no new messages (5 unread)", actual);
	}},

	// Missing translation with count option
	testMissingTranslationWithCountOption: function() { with(this) {
		actual = I18n.translate("invalid", {count: 1});
		assertEqual('[missing "en.invalid" translation]', actual);

		I18n.translations.en.inbox.one = null;
		actual = I18n.translate("inbox", {count: 1});
		assertEqual('[missing "en.inbox.one" translation]', actual);
	}},

	// Pluralization
	testPluralization: function() { with(this) {
		assertEqual("You have 1 message", I18n.pluralize(1, "inbox"));
		assertEqual("You have 5 messages", I18n.pluralize(5, "inbox"));
		assertEqual("You have no messages", I18n.pluralize(0, "inbox"));
	}},

	// Pluralize should return "other" scope
	testPlurationShouldReturnOtherScope: function() { with(this) {
		I18n.translations["en"]["inbox"]["zero"] = null;
		assertEqual("You have 0 messages", I18n.pluralize(0, "inbox"));
	}},

	// Pluralize should return "zero" scope
	testPlurationShouldReturnZeroScope: function() { with(this) {
		I18n.translations["en"]["inbox"]["zero"] = "No messages (zero)";
		I18n.translations["en"]["inbox"]["none"] = "No messages (none)";

		assertEqual("No messages (zero)", I18n.pluralize(0, "inbox"));
	}},

	// Pluralize should return "none" scope
	testPlurationShouldReturnNoneScope: function() { with(this) {
		I18n.translations["en"]["inbox"]["zero"] = null;
		I18n.translations["en"]["inbox"]["none"] = "No messages (none)";

		assertEqual("No messages (none)", I18n.pluralize(0, "inbox"));
	}},

	// Pluralize with negative values
	testPluralizeWithNegativeValues: function() { with(this) {
		assertEqual("You have -1 message", I18n.pluralize(-1, "inbox"));
		assertEqual("You have -5 messages", I18n.pluralize(-5, "inbox"));
	}},

	// Pluralize with multiple placeholders
	testPluralizeWithMultiplePlaceholders: function() { with(this) {
		actual = I18n.pluralize(1, "unread", {unread: 5});
		assertEqual("You have 1 new message (5 unread)", actual);

		actual = I18n.pluralize(10, "unread", {unread: 2});
		assertEqual("You have 10 new messages (2 unread)", actual);

		actual = I18n.pluralize(0, "unread", {unread: 5});
		assertEqual("You have no new messages (5 unread)", actual);
	}},

	// Numbers with default settings
	testNumbersWithDefaultSettings: function() { with(this) {
		assertEqual("1.000", I18n.toNumber(1));
		assertEqual("12.000", I18n.toNumber(12));
		assertEqual("123.000", I18n.toNumber(123));
		assertEqual("1,234.000", I18n.toNumber(1234));
		assertEqual("123,456.000", I18n.toNumber(123456));
		assertEqual("1,234,567.000", I18n.toNumber(1234567));
		assertEqual("12,345,678.000", I18n.toNumber(12345678));
	}},

	// Numbers with partial translation and default options
	testNumbersWithPartialTranslationAndDefaultOptions: function() { with(this) {
		I18n.translations.en.number = {
			format: {
				precision: 2
			}
		}

		assertEqual("1,234.00", I18n.toNumber(1234));
	}},

	// Numbers with full translation and default options
	testNumbersWithFullTranslationAndDefaultOptions: function() { with(this) {
		I18n.translations.en.number = {
			format: {
				delimiter: ".",
				separator: ",",
				precision: 2
			}
		}

		assertEqual("1.234,00", I18n.toNumber(1234));
	}},

	// Numbers with some custom options that should be merged with default options
	testNumbersWithSomeCustomOptionsThatShouldBeMergedWithDefaultOptions: function() { with(this) {
		assertEqual("1,234", I18n.toNumber(1234, {precision: 0}));
		assertEqual("1,234-000", I18n.toNumber(1234, {separator: "-"}));
		assertEqual("1-234.000", I18n.toNumber(1234, {delimiter: "-"}));
	}},

	// Numbers considering options
	testNumbersConsideringOptions: function() { with(this) {
		options = {
			precision: 2,
			separator: ",",
			delimiter: "."
		};

		assertEqual("1,00", I18n.toNumber(1, options));
		assertEqual("12,00", I18n.toNumber(12, options));
		assertEqual("123,00", I18n.toNumber(123, options));
		assertEqual("1.234,00", I18n.toNumber(1234, options));
		assertEqual("123.456,00", I18n.toNumber(123456, options));
		assertEqual("1.234.567,00", I18n.toNumber(1234567, options));
		assertEqual("12.345.678,00", I18n.toNumber(12345678, options));
	}},

	// Numbers with different precisions
	testNumbersWithDifferentPrecisions: function() { with(this) {
		options = {separator: ".", delimiter: ","};

		options["precision"] = 2;
		assertEqual("1.98", I18n.toNumber(1.98, options));

		options["precision"] = 3;
		assertEqual("1.980", I18n.toNumber(1.98, options));

		options["precision"] = 2;
		assertEqual("1.99", I18n.toNumber(1.987, options));

		options["precision"] = 1;
		assertEqual("2.0", I18n.toNumber(1.98, options));

		options["precision"] = 0;
		assertEqual("2", I18n.toNumber(1.98, options));
	}},

	// Currency with default settings
	testCurrencyWithDefaultSettings: function() { with(this) {
		assertEqual("$100.99", I18n.toCurrency(100.99));
		assertEqual("$1,000.99", I18n.toCurrency(1000.99));
	}},

	// Current with custom settings
	testCurrencyWithCustomSettings: function() { with(this) {
		I18n.translations.en.number = {
			currency: {
				format: {
					format: "%n %u",
					unit: "USD",
					delimiter: ".",
					separator: ",",
					precision: 2
				}
			}
		};

		assertEqual("12,00 USD", I18n.toCurrency(12));
		assertEqual("123,00 USD", I18n.toCurrency(123));
		assertEqual("1.234,56 USD", I18n.toCurrency(1234.56));
	}},

	// Currency with custom settings and partial overriding
	testCurrencyWithCustomSettingsAndPartialOverriding: function() { with(this) {
		I18n.translations.en.number = {
			currency: {
				format: {
					format: "%n %u",
					unit: "USD",
					delimiter: ".",
					separator: ",",
					precision: 2
				}
			}
		};

		assertEqual("12 USD", I18n.toCurrency(12, {precision: 0}));
		assertEqual("123,00 bucks", I18n.toCurrency(123, {unit: "bucks"}));
	}},

	// Currency with some custom options that should be merged with default options
	testCurrencyWithSomeCustomOptionsThatShouldBeMergedWithDefaultOptions: function() { with(this) {
		assertEqual("$1,234", I18n.toCurrency(1234, {precision: 0}));
		assertEqual("º1,234.00", I18n.toCurrency(1234, {unit: "º"}));
		assertEqual("$1,234-00", I18n.toCurrency(1234, {separator: "-"}));
		assertEqual("$1-234.00", I18n.toCurrency(1234, {delimiter: "-"}));
		assertEqual("$ 1,234.00", I18n.toCurrency(1234, {format: "%u %n"}));
	}},

	// Localize numbers
	testLocalizeNumbers: function() { with(this) {
		assertEqual("1,234,567.000", I18n.localize("number", 1234567));
	}},

	// Localize currency
	testLocalizeCurrency: function() { with(this) {
		assertEqual("$1,234,567.00", I18n.localize("currency", 1234567));
	}},

	// Parse date
	testParseDate: function() { with(this) {
		expected = new Date(2009, 0, 24, 0, 0, 0);
		assertEqual(expected.toString(), I18n.parseDate("2009-01-24").toString());

		expected = new Date(2009, 0, 24, 0, 15, 0);
		assertEqual(expected.toString(), I18n.parseDate("2009-01-24 00:15:00").toString());

		expected = new Date(2009, 0, 24, 0, 0, 15);
		assertEqual(expected.toString(), I18n.parseDate("2009-01-24 00:00:15").toString());

		expected = new Date(2009, 0, 24, 15, 33, 44);
		assertEqual(expected.toString(), I18n.parseDate("2009-01-24 15:33:44").toString());

		expected = new Date(2009, 0, 24, 0, 0, 0);
		assertEqual(expected.toString(), I18n.parseDate(expected.getTime()).toString());

		expected = new Date(2009, 0, 24, 0, 0, 0);
		assertEqual(expected.toString(), I18n.parseDate("01/24/2009").toString());

		expected = new Date(2009, 0, 24, 14, 33, 55);
		assertEqual(expected.toString(), I18n.parseDate(expected).toString());

		expected = new Date(2009, 0, 24, 15, 33, 44);
		assertEqual(expected.toString(), I18n.parseDate("2009-01-24T15:33:44").toString());

		expected = new Date(Date.UTC(2009, 0, 24, 15, 33, 44));
		assertEqual(expected.toString(), I18n.parseDate("2009-01-24T15:33:44Z").toString());
	}},

	// Date formatting
	testDateFormatting: function() { with(this) {
		I18n.locale = "pt";

		// 2009-04-26 19:35:44 (Sunday)
		var date = new Date(2009, 3, 26, 19, 35, 44);

		// short week day
		assertEqual("Dom", I18n.strftime(date, "%a"));

		// full week day
		assertEqual("Domingo", I18n.strftime(date, "%A"));

		// short month
		assertEqual("Abr", I18n.strftime(date, "%b"));

		// full month
		assertEqual("Abril", I18n.strftime(date, "%B"));

		// day
		assertEqual("26", I18n.strftime(date, "%d"));

		// 24-hour
		assertEqual("19", I18n.strftime(date, "%H"));

		// 12-hour
		assertEqual("07", I18n.strftime(date, "%I"));

		// month
		assertEqual("04", I18n.strftime(date, "%m"));

		// minutes
		assertEqual("35", I18n.strftime(date, "%M"));

		// meridian
		assertEqual("PM", I18n.strftime(date, "%p"));

		// seconds
		assertEqual("44", I18n.strftime(date, "%S"));

		// week day
		assertEqual("0", I18n.strftime(date, "%w"));

		// short year
		assertEqual("09", I18n.strftime(date, "%y"));

		// full year
		assertEqual("2009", I18n.strftime(date, "%Y"));
	}},

	// Date formatting without padding
	testDateFormattingWithoutPadding: function() { with(this) {
		I18n.locale = "pt";

		// 2009-04-26 19:35:44 (Sunday)
		var date = new Date(2009, 3, 9, 7, 8, 9);

		// 24-hour without padding
		assertEqual("7", I18n.strftime(date, "%-H"));

		// 12-hour without padding
		assertEqual("7", I18n.strftime(date, "%-I"));

		// minutes without padding
		assertEqual("8", I18n.strftime(date, "%-M"));

		// seconds without padding
		assertEqual("9", I18n.strftime(date, "%-S"));

		// short year without padding
		assertEqual("9", I18n.strftime(date, "%-y"));

		// month without padding
		assertEqual("4", I18n.strftime(date, "%-m"));

		// day without padding
		assertEqual("9", I18n.strftime(date, "%-d"));
	}},

	// Date formatting with padding
	testDateFormattingWithPadding: function() { with(this) {
		I18n.locale = "pt";

		// 2009-04-26 19:35:44 (Sunday)
		var date = new Date(2009, 3, 9, 7, 8, 9);

		// 24-hour
		assertEqual("07", I18n.strftime(date, "%H"));

		// 12-hour
		assertEqual("07", I18n.strftime(date, "%I"));

		// minutes
		assertEqual("08", I18n.strftime(date, "%M"));

		// seconds
		assertEqual("09", I18n.strftime(date, "%S"));

		// short year
		assertEqual("09", I18n.strftime(date, "%y"));

		// month
		assertEqual("04", I18n.strftime(date, "%m"));

		// day
		assertEqual("09", I18n.strftime(date, "%d"));
	}},

	// Date formatting with negative Timezone
	testDateFormattingWithNegativeTimezone: function() { with(this) {
		I18n.locale = "pt";

		var date = new Date(2009, 3, 26, 19, 35, 44);

		date.getTimezoneOffset = function() {
			return 345;
		};

		assertMatch(/^(\+|-)[\d]{4}$/, I18n.strftime(date, "%z"));
		assertEqual("-0545", I18n.strftime(date, "%z"));
	}},

	// Date formatting with positive Timezone
	testDateFormattingWithPositiveTimezone: function() { with(this) {
		I18n.locale = "pt";

		var date = new Date(2009, 3, 26, 19, 35, 44);

		date.getTimezoneOffset = function() {
			return -345;
		};

		assertMatch(/^(\+|-)[\d]{4}$/, I18n.strftime(date, "%z"));
		assertEqual("+0545", I18n.strftime(date, "%z"));
	}},

	// Localize date strings
	testLocalizeDateStrings: function() { with(this) {
		I18n.locale = "pt";

		assertEqual("29/11/2009", I18n.localize("date.formats.default", "2009-11-29"));
		assertEqual("07 de Janeiro", I18n.localize("date.formats.short", "2009-01-07"));
		assertEqual("07 de Janeiro de 2009", I18n.localize("date.formats.long", "2009-01-07"));
	}},

	// Localize time strings
	testLocalizeTimeStrings: function() { with(this) {
		I18n.locale = "pt";
		assertEqual("Domingo, 29 de Novembro de 2009, 15:07 h", I18n.localize("time.formats.default", "2009-11-29 15:07:59"));
		assertEqual("07/01, 09:12 h", I18n.localize("time.formats.short", "2009-01-07 09:12:35"));
		assertEqual("Domingo, 29 de Novembro de 2009, 15:07 h", I18n.localize("time.formats.long", "2009-11-29 15:07:59"));
	}},

	// Localize percentage
	testLocalizePercentage: function() { with(this) {
		I18n.locale = "pt";
		assertEqual("123,45%", I18n.localize("percentage", 123.45));
	}},



	// Default value for simple translation
	testDefaultValueForSimpleTranslation: function() { with(this) {
		actual = I18n.translate("warning", {defaultValue: "Warning!"});
		assertEqual("Warning!", actual);
	}},

	// Default value with interpolation
	testDefaultValueWithInterpolation: function() { with(this) {
		actual = I18n.translate("alert", {defaultValue: "Attention! {{message}}", message: "You're out of quota!"});
		assertEqual("Attention! You're out of quota!", actual);
	}},

	// Default value should not be used when scope exist
	testDefaultValueShouldNotBeUsedWhenScopeExist: function() { with(this) {
		actual = I18n.translate("hello", {defaultValue: "What's up?"});
		assertEqual("Hello World!", actual);
	}},

	// Default value for pluralize
	testDefaultValueForPluralize: function() { with(this) {
		options = {defaultValue: {
			none: "No things here!",
			one: "There is {{count}} thing here!",
			other: "There are {{count}} things here!"
		}};

		assertEqual("No things here!", I18n.pluralize(0, "things", options));
		assertEqual("There is 1 thing here!", I18n.pluralize(1, "things", options));
		assertEqual("There are 5 things here!", I18n.pluralize(5, "things", options));
	}},

	// Default value for pluralize should not be used when scope exist
	testDefaultValueForPluralizeShouldNotBeUsedWhenScopeExist: function() { with(this) {
		options = {defaultValue: {
			none: "No things here!",
			one: "There is {{count}} thing here!",
			other: "There are {{count}} things here!"
		}};

		assertEqual("You have no messages", I18n.pluralize(0, "inbox", options));
		assertEqual("You have 1 message", I18n.pluralize(1, "inbox", options));
		assertEqual("You have 5 messages", I18n.pluralize(5, "inbox", options));
	}},

	// Prepare options
	testPrepareOptions: function() { with(this) {
		options = I18n.prepareOptions(
			{name: "Mary Doe"},
			{name: "John Doe", role: "user"}
		);

		assertEqual("Mary Doe", options["name"]);
		assertEqual("user", options["role"]);
	}},

	// Prepare options with multiple options
	testPrepareOptionsWithMultipleOptions: function() { with(this) {
		options = I18n.prepareOptions(
			{name: "Mary Doe"},
			{name: "John Doe", role: "user"},
			{age: 33},
			{email: "mary@doe.com", url: "http://marydoe.com"},
			{role: "admin", email: "john@doe.com"}
		);

		assertEqual("Mary Doe", options["name"]);
		assertEqual("user", options["role"]);
		assertEqual(33, options["age"]);
		assertEqual("mary@doe.com", options["email"]);
		assertEqual("http://marydoe.com", options["url"]);
	}},

	// Prepare options should return an empty hash when values are null
	testPrepareOptionsShouldReturnAnEmptyHashWhenValuesAreNull: function() { with(this) {
		assertNotNullOrUndefined(I18n.prepareOptions(null, null));
	}},

	// Percentage with defaults
	testPercentageWithDefaults: function() { with(this) {
		assertEqual("1234.000%", I18n.toPercentage(1234));
	}},

	// Percentage with custom options
	testPercentageWithCustomOptions: function() { with(this) {
		assertEqual("1_234%", I18n.toPercentage(1234, {delimiter: "_", precision: 0}));
	}},

	// Percentage with translation
	testPercentageWithTranslation: function() { with(this) {
		I18n.translations.en.number = {
			percentage: {
				format: {
					precision: 2,
					delimiter: ".",
					separator: ","
				}
			}
		}

		assertEqual("1.234,00%", I18n.toPercentage(1234));
	}},

	// Percentage with translation and custom options
	testPercentageWithTranslationAndCustomOptions: function() { with(this) {
		I18n.translations.en.number = {
			percentage: {
				format: {
					precision: 2,
					delimiter: ".",
					separator: ","
				}
			}
		}

		assertEqual("1-234+0000%", I18n.toPercentage(1234, {precision: 4, delimiter: "-", separator: "+"}));
	}},

	// Scope option as string
	testScopeOptionAsString: function() { with(this) {
		actual = I18n.translate("stranger", {scope: "greetings"});
		assertEqual("Hello stranger!", actual);
	}},

	// Scope as array
	testScopeAsArray: function() { with(this) {
		actual = I18n.translate(["greetings", "stranger"]);
		assertEqual("Hello stranger!", actual);
	}}
});
