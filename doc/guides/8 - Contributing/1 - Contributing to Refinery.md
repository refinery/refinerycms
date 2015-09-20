# Contributing to Refinery

One of Refinery's key principles is encouraging people to contribute.
This guide will show you how to:

* Contribute to the documentation (such as this guide)
* Contribute bug fixes or new features
* Contribute financially

## Contributing documentation or guides

We'd love it if you have a how-to guide on adding or setting up a feature on Refinery.

Read the [Writing a guide for this website](/guides/writing-a-guide-for-this-website) guide for more
information.

## Contributing bug fixes or new features

__WARNING__: This guide is only for advanced users of Refinery

### Setup

#### In your browser

* Login to <https://github.com>
* Go to <https://github.com/refinery/refinerycms>
* If you have a fork of refinerycms already, delete it (*if you're not going to lose work. This makes it much easier for us to integrate your changes back in*)
* Click on "fork" to make a fresh new fork on your own account.

#### In terminal

```shell
$ git clone git@github.com:USERNAME/refinerycms.git
$ cd refinerycms
$ bundle install
$ bin/rake refinery:testing:dummy_app
$ rails server
```

#### In your browser again

* go to <http://localhost:3000>

### I found an issue. Where do I file it?

* add it to <https://github.com/refinery/refinerycms/issues> - with as much detail as possible :-)

### Contributing a fix

Make your changes to fix a bug. Next regenerate the dummy app and run the Refinery tests

```shell
$ bin/rake refinery:testing:clean_dummy_app
$ bin/rake refinery:testing:dummy_app
$ bin/rspec ./*/spec
```

If this doesn't work. Follow the [How to test Refinery guide](/guides/testing)

Commit your changes:

```shell
$ git add path/to/files/changed
$ git commit -m "your fix"
```

__TIP__: if you've filed an issue on Github add "Closes GH-999" (replace 999 with your issue number) to your commit message and it will automatically link the issue to your commit and close it.

```shell
git push origin master
```

Now go to <https://github.com/refinery/refinerycms> and click "Pull Request". Type a nice message explaining what you've done and send the request.

We'll merge it in if it's all good.

### Confused on where to find everything?

Take a look at this [page](https://github.com/refinery/refinerycms/wiki/Begin-Developing) which briefly explains the source.

## Contributing financially

Some of the effort that goes into Refinery CMS is covered by client work where requirements aren't met by the current implementation and so extensions are required. Most of the effort, however, is done on a free basis by the core team and many contributors worldwide.

If you would like to contribute to Refinery CMS development by helping us to justify spending more time on it then you can [donate to the project at pledgie.](http://pledgie.com/campaigns/8431)

All donations are very much appreciated and 100% of proceeds go toward making Refinery CMS even better.
