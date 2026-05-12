# Welcome to Gem Session 🤘

> ⚡ Where code meets heavy metal. ⚡

This app is a side gig for me to learn Ruby & Rails.

The idea is simple:

* The app randomly selects three Ruby gems (see below)
* An LLM proposes a project prompt for the user to build using two matching gems
* Users can follow, like, etc. each other's work
* Add lots of tropes, puns and inside jokes about music and coding

# Design considerations

## Randomized Gem selection

Not all gems are useful and/or appropriate for a coding challenge.

The app will only select Gems which (according to RubyGems.org) have:

* at least ten versions since 2020
* between 10,000 and 1,000,000 total downloads
* a description and a (working) homepage link

At first, I thought I'd add a minimum length for the Gems' description. Then I noticed that even very common ones
usually have very short descriptions on RubyGems.org. Hence the requirement for a homepage link, which the LLM visits
when generating the project prompt.

### Gem seeding pipeline
To seed the `Rubygem` model, you'll need to:
1. Check out the `rubygems/rubygems.org` [repo](https://github.com/rubygems/rubygems.org)
2. Download and [import](https://github.com/rubygems/rubygems.org/blob/master/script/load-pg-dump) a [database dump](https://rubygems.org/pages/data)
3. Run `script/dump_gemmables.rb > all-gemmables.yml`
4. Run `script/filter_broken_urls all-gemmables.yml db/gemmables.yml`
5. Run `rails db:seed`
