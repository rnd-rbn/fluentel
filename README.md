# Fluentel

Hello fellow language learner,

Welcome to the code for the Fluentel mobile app! The purpose of the mobile app is to make it easier for language learners of Spanish and English in the United States and Mexico to discover Fluentel. Prior to the mobile app, Fluentel consisted only of the phone hotline itself and [the website](https://fluen.tel).

## Why Fluentel?
> There's a lot of language learning _fish in the sea_, but not a whole lot of _proficiency_.

Everyone wants to become fluent in another language. Lots of people start the language learning journey. Some of these people continue learning for a long time. Very few of these learners ever become fluent.

The mission of Fluentel is to convert more of these dedicated language _learners_ into proficient language _speakers_. Successful speaking implies an equivalent level of listening comprehension. There are no shortcuts, hacks, or become-fluent-in-7-days tricks to become fluent. The best way to become fluent is to practice speaking, which means 
* building your confidence, 
* learning how to have small talk (chit-chat), 
* becoming interested and curious about other people and things, 
* how to balance asking questions and listening,
* making mistakes and having fun doing it!

Don't just learn a language. Language learning is a barrier to language using! Learn to use a language: reading, writing, listening, and speaking. Fluentel helps you with listening and speaking by connecting you with native speakers for conversation practice.

### A little history

Prior to the internet, if you wanted to practice speaking your target language (TL), you had to use your teacher, study or live abroad, or get creative to seek out native speakers in your city. And at least in the 20th century, you could have made international phone calls to a language partner, but only the privileged class could have afforded that!

Today we have more interconnected and diverse cities, so finding opportunities to practice your TL is easier. It becomes even easier with the internet, mobile phones, and apps. You can find language partners on websites and apps such as HelloTalk, Tandem, and Lingbe. 

### A few problems

#### The tedious process

Most of these tools require you create a profile, then you have to find another user, and then message a bunch of these users. Hopefully someone will be willing to speak with you. But let's say you chat for 20 minutes: 10 minutes you practice Spanish, and then you switch to helping them practice English. If you find a partner you can stick with, great! If not (or if you're new friend isn't available), you have to repeat this process of messaging only to eek out a 50/50 language exchange. And sometimes your searching and messaging won't result in any speaking practice.

#### Just connect me

Lingbe is the one exception because they connect users on demand. But each user needs to have the app either open or recently opened for the mobile app notifications to work. It's also more difficult in Lingbe to connect with a native speaker when compared to HelloTalk and Tandem.

#### Not everyone has a mobile device

Mobile phones are becoming commonplace, but still not everyone has one. These language exchange mobile apps don't have working web apps, so you can't use them even if you have access to a regular computer with internet connection. In some rural locations, a landline (fixed phone) may be the only way to communicate with the outside world.

#### Not everyone has wifi or data (internet access)

If you live in the United States, you may be surprised. Even in the U.S. not everyone has wifi at home or unlimited data plans. But you need wifi or data to make internet calls (especially video calls require more data). Other countries have similar problems with internet access, and access to internet can vary based on socioeconomic status or region.

#### Not everyone has time

Unless you pay for a language tutor on Preply or iTalki, your speaking practice will be a language exchange, meaning you're only 50% efficient because you split the time 50/50 practicing and helping. You can still learn a lot by helping someone practice your native language, but if you're a busy person, you may not have the luxury of time.

#### Timezones and flakiness

Practicing speaking on-demand is nice, but sometimes you need to schedule your practice sessions ahead of time. You'll need to consider your partner's timezone and when they take effect. Great! Now you have a language exchange scheduled. What are the chances your partner cancels or doesn't show up? If you've been scheduling speaking practice with these apps or even on Reddit's language_exchange group, you'll already have an idea how unreliable this method is. 

## How Fluentel Works

### The idea

I had the idea for Fluentel when I was driving home with 30 minutes to spare. I wanted to use that time to practice speaking Spanish. I imagined being able to call a phone number (hands-free) and getting connected to a native Spanish speaker almost instantaneously.

### The technology

Language exchange apps already exist, but using them while driving isn't safe. You still have to search, message, and connect. Many companies use Twilio's telecommunications software to have automated **phone calling** and **text messaging**. That text message notifying you about an upcoming appointment? That's Twilio behind the scenes.

Fluentel uses Twilio to:
1. verify the device used to call (protect from spoofing),
2. send text messages to available language partners, and
3. connect users from the United States and Mexico over the phone

Callers dial a local phone number and Fluentel makes the international connection. Users will never have to pay for international calling.

#### Where do the language partners (mentors) come from?

Fluentel has two sides:
1. the callers who want to practice speaking, and
2. the mentors who help the callers practice speaking

Mentors set their availability for each day they can help. They provide their timezone and daily availability, e.g. Central Time - Mondays 6-9pm.

#### How does Fluentel connect callers to mentors?

When you call Fluentel, we will text a handful of available mentors. You (the caller) will [listen to some nice waiting music](https://youtu.be/dQw4w9WgXcQ) until one of the mentors responds to our text message. If nobody responds within 3 minutes, the call with end. But if someone does respond, we will connect you to them.

#### The conversation

Once we connect you to a real live native speaker of your target language, the rest is up to you! As a caller, you are the dedicated practicing language learner. You can expect to practice speaking 100% of the time, if you so choose. You can speak for as long or as little as you prefer. The mentor's role is to help you exclusively with your target language.

#### How much does it cost?

Your first 60 minutes to try Fluentel are free. After that it costs 12 cents $US per minute ($7.20/hr) if you're calling from the United States. Calling from Mexico costs 6 cents $US per minute ($3.60/hr) (MEX 69/hr on January 8, 2023).

#### How to buy more minutes

Callers can buy more minutes directly over the phone! Fluentel uses [Twilio Pay](https://www.twilio.com/pay) to provide a safe & secure, PCI-compliant environment. Fluentel does not record or save your payment information.

#### Every call is recorded

Every phone call on Fluentel is recorded to ensure that every user (callers and mentors) is on their best behavior. If someone makes a complaint about inappropriate behavior, we can refer to the phone call.

The other nice thing about recording the call is that if you provide us your email, we will send you a link to the audio file of your conversation! You can use this file to review your conversation or submit to your teacher for grading.

## Frequently Asked Questions

### Will the other user see my phone number?

No. Every country has a specific Fluentel phone number to make and receive calls and text messages. Callers and mentors will only see their respective country's Fluentel phone number.

### What does Fluentel share with the other user?

As a caller, we will share your mentor's first name with you upon connection. Between the waiting music and getting connected, you may hear for example "We are now connecting you to Alejandro".

As a mentor, we will share the caller's first name in a text message. You may receive a text message during your availability, for example "Alejandro wants to practice speaking English with you. To be their mentor, reply Yes and we will call to connect you."

### Do I have to use my real first name?

No. But we recommend using something normal so that your partner can easily refer to you by that name.

### My question isn't listed here. Where can I ask it?

Create a [new issue here](https://github.com/rnd-rbn/fluentel/issues/new). Give it a title and any context in the description. Or email me directly aaron@fluen.tel

## The Mobile App

The Fluentel mobile app is a single-button app just like [Shazam](https://www.shazam.com/apps) or [Noonlight](https://www.noonlight.com/noonlight-app). The main thing the Fluentel app does is call your country's Fluentel phone number.

### Future Features

Here are some features I've been thinking about adding:
* a button to add Fluentel to contacts (so you can do stuff like say "Hey Siri, call Fluentel")
* a place to see how many mentors are currently available (if there's zero at 3:00 AM, then there's no sense in calling)
* a way to set your daily availability as a mentor (currently you can only set your availability by using the call prompt)
* got an idea? [submit an issue here](https://github.com/rnd-rbn/fluentel/issues/new) or email me directly aaron@fluen.tel

---

# The Bottom Line

However you manage to practice speaking, just do it. Find a local meetup to practice speaking or volunteer to help expats, immigrants, and refugees learn your language. Try the apps and tools I mentioned previously to find a language partner. Fluentel is just one tool among many.

Just please don't fall into the trap of learning a language for years, but never actually speaking or comprehending the language with any meaningful proficiency. You want to get to a point where you can watch movies in your target language _without subtitles_. You want to get to a point where you can get off the plane in a country that speaks your target langauge _and not use your translation app_.

Learning a language is fun and interesting, but being able to use a language is exhilarating and powerful.
