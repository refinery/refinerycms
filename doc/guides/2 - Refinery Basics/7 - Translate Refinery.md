# Translate Refinery

Refinery supports internationalization (I18n for short), which includes translation. This guide will show you how to:

* Improve upon or add a new translation to Refinery

## Setup

Before you start translating, you should clone a fresh copy of Refinery from GitHub. See [the contributing guide](https://www.refinerycms.com/guides/contributing-to-refinery) for information regarding how to do that.

It's not required, but we strongly advise you to create a separate branch when adding a translation or a new feature. You can do so by typing the following shell command.

__TIP__: Throughout this guide, we refer to the Dutch locale (`nl`). In most circumstances, you will not want to refer to this locale; be sure to substitute `nl` for the locale you're working with.

```shell
$ git checkout -b i18n_nl
```

## Finding missing keys

First, you must create a 'dummy' application to enable additional useful `rake` tasks. Do so with the following command:

```shell
$ bin/rake refinery:testing:dummy_app
```

Then execute the following to get a list of missing translations for all locales:

```shell
$ bin/rake app:translate:lost_in_translation_all
```

Or execute the following rake task to get a list of missing translations for a given locale:

```shell
$ bin/rake app:translate:lost_in_translation LOCALE=nl
```

The output of this will look like this:

```shell
Searching for missing translations for the locale: nl
refinery.admin.pages.form_advanced_options.page_options in pages/app/views/refinery/admin/pages/_form_advanced_options.html.erb      is not in any nl locale file
refinery.admin.pages_dialogs.link_to.insert in pages/app/views/refinery/admin/pages_dialogs/link_to.html.erb     is not in any nl locale file
Number of missing translations for nl: 2
```

As you can see, there are two missing keys: `refinery.admin.pages.form_advanced_options.page_options` and `refinery.admin.pages_dialogs.link_to.insert`.

## Adding the keys

Each plugin has its own locale YAML files. The one we'll have to fix is `pages/config/locales/nl.yml`. Note that it is important to put the right key in the right file.

The key `refinery.admin.pages_dialogs.link_to.insert` is represented in YAML like so:

```yaml
nl:
  refinery:
    admin:
      pages_dialogs:
        link_to:
          insert: Voeg in
```

Order the keys exactly like the en.yml version. This way, you can use a diff-enabled-editor to open both the `en.yml` and `nl.yml` file to quickly update the locale. If you are making changes to the `en.yml` file, alphabetically list keys you add.

__TIP__: If you're starting a translation for a new language, copy `en.yml` to `"your_locale".yml`

__WARNING__: Make sure you change `en:` to your locale's key at the top of `"your_locale".yml` to avoid overriding the English translation (e.g.`nl:`)

## Run the Refinery tests

Run the Refinery tests to be sure you didn't break something, and that your YAML is valid.

```shell
$ bin/rake spec
```

## Commit & Push

Add the modified files to the git repository

```shell
$ git add pages/config/locales/nl.yml
```

Commit your changes

```shell
$ git commit
```

and push them back to GitHub

```shell
$ git push origin i18n_nl
```

## Pull request

* Go to GitHub, and select your i18n_nl branch;
* Click on the button "Pull request";
* Add a message about I18n, like "Hi, I've translated the missing Dutch keys";
* Press "Send pull request".

## Done

And now you're done! If your changes are accepted, you will end up on the [contributor list](https://github.com/refinery/refinerycms/contributors).
