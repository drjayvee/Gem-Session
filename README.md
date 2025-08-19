# Welcome to Gem Session 🤘

> ⚡ Where code meets heavy metal. ⚡

This app is a side gig for me to learn Ruby & Rails.

The idea is simple:

* The app randomly selects two Ruby gems (more details below)
* An LLM proposes a project prompt for the user to build using those gems
* Users can follow, like, etc. each other's work
* Add lots of tropes, puns and inside jokes about music and coding

# Design considerations

## Randomized Gem selection

Not all gems are useful and/or appropriate for a coding challenge.

The app will only select Gems which (according to RubyGems.org) have:

* at least ten versions since 2020
* between 10,000 and 1,000,000 total downloads
* a description and a homepage link

At first, I thought I'd add a minimum length for the Gems' description. Then I noticed that even very common ones
usually have very short descriptions on RubyGems.org. Hence the requirement for a homepage link, which this app
will crawl with a job so that it can feed that to the LLM when generating the project prompt. Then again, maybe I can
ask the LLM to do that while generating the prompt? Or I could `gem install` them "locally" and read the `README`.
