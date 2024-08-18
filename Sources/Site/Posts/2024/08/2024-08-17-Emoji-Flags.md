# Everything you never thought you wanted to know about emoji flags

Let's say you're building an [analytics app](https://hogmobile.com) and you want a simple way
to represent the location of an analytics event. If, like me, you thought "hey, emoji flags would be
a fun way to show countries" and then immediately started building a dictionary like this:

```swift
let emojiFlags = [
  "AU": "🇦🇺",
  "BE": "🇧🇪",
  "BR": "🇧🇷",
  "BS": "🇧🇸",
  ...
]
```

...well then stay a while, because it turns out there's a *much* simpler way to do this (for some
definition of simpler).

## Unicode flags

Emoji flags, like all emoji, are represented using
[unicode named character sequences](http://www.unicode.org/reports/tr34/). What might be
surprising though is that **each flag's unicode representation directly correlates with the flag's
two-letter ISO country code** (aka [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)).

🤯

To understand how this works, let's look at the set of emoji flags we'd defined previously, but
this time adding in their unicode representations.

Country code | Emoji | Unicode | Country
-- | -- | -- | --
AU | 🇦🇺 | `U+1F1E6` `U+1F1FA` | Australia
BE | 🇧🇪 | `U+1F1E7` `U+1F1EA` | Belgium
BR | 🇧🇷 | `U+1F1E7` `U+1F1F7` | Brazil
BS | 🇧🇸 | `U+1F1E7` `U+1F1F8` | Bahamas

First, notice how each flag has **two** unicode characters.

Then, notice that all of the `B`-prefixed countries have the same first unicode character of
`U+1F1E7`. This is not a coincidence!

## Regional indicator symbols

From [Wikipedia](https://en.wikipedia.org/wiki/Regional_indicator_symbol):

> The regional indicator symbols are a set of 26 alphabetic Unicode characters (A–Z) intended
> to be used to encode ISO 3166-1 alpha-2 two-letter country codes in a way that allows optional
> special treatment.
>
> ...
>
> They are encoded in the range U+1F1E6 🇦 REGIONAL INDICATOR SYMBOL LETTER A to U+1F1FF 🇿
> REGIONAL INDICATOR SYMBOL LETTER Z within the Enclosed Alphanumeric Supplement block in the
> Supplementary Multilingual Plane.[4]

So if we subtract `U+1F1E6` from each of our unicode sequences above we get the following offsets:

Country code | Emoji | Letter offsets | Country
-- | -- | -- | --
AU | 🇦🇺 | `0` `20` | Australia
BE | 🇧🇪 | `1` `4` | Belgium
BR | 🇧🇷 | `1` `17` | Brazil
BS | 🇧🇸 | `1` `18` | Bahamas

It's now a simple translation  to the corresponding country code using the alphabet. Here's a table
in case you want to try this out by hand.

| A | B | C | D | E | F | G | H | I | J |
|---|---|---|---|---|---|---|---|---|---|
| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |

| K  | L  | M  | N  | O  | P  | Q  | R  | S  |
|----|----|----|----|----|----|----|----|----|
| 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 |

| T  | U  | V  | W  | X  | Y  | Z  |
|----|----|----|----|----|----|----|
| 19 | 20 | 21 | 22 | 23 | 24 | 25 |

## An emojiFlag function

Now that we know how to create flags from country codes, we can build a function that does exactly
that.

```swift
func emojiFlag(countryCode: String) -> String? {
  guard countryCode.count == 2 else {
    return nil
  }
  // https://en.wikipedia.org/wiki/Regional_indicator_symbol
  let regionalIndicatorStartIndex: UInt32 = 0x1F1E6
  let alphabetOffset = UnicodeScalar(unicodeScalarLiteral: "A").value
  return String(countryCode
    .uppercased()
    .unicodeScalars
    .compactMap { UnicodeScalar(
      regionalIndicatorStartIndex + ($0.value - alphabetOffset)
    )}
    .map { Character($0) }
  )
}

emojiFlag(countryCode: "CA") // "🇨🇦"
```

Way better than maintaining a dictionary. Now to integrate this into
[Hog Mobile](https://hogmobile.com)!

## P.S. Unicode's policy on flags

It's probably important to note that the Unicode Consortium shared a couple years back that they're
[no longer accepting proposals for new flags](http://blog.unicode.org/2022/03/the-past-and-future-of-flag-emoji.html).

Based on the Q&A, I don't think this necessarily means that countries won't get flag emojis, it just
means the Unicode Consortium isn't reviewing proposals for new non-standardized flags (i.e. those
that don't have a Unicode region code). 

> **Wait, if a country gains independence and is recognised by ISO, does that mean no flag emoji for
> them?**
>
> Flags for countries with Unicode region codes are automatically recommended, with no proposals
> necessary! First their codes and translated names are added to Unicode’s Common Locale Data
> Repository [CLDR], and then the emoji become valid in the next version of Unicode. These emoji
> are also automatically recommended for general interchange and wide deployment.

## P.P.S: Subdivisions

I had *just* finished writing this article when I saw a footnote in the Unicode specifications
regarding country subdivisons, and I couldn't help but dig *just a bit* further 😅

Apparently [Emoji 5.0](https://emojipedia.org/emoji-5.0?ref=blog.emojipedia.org) "introduced support
for [subdivision flags](https://emojipedia.org/emoji-tag-sequence) and listed England, Scotland and
Wales as Recommended for General Interchange (RGI)". This means that most platforms should support
these flags, but they aren't implemented using the same country code offsets we used above.

Instead, they use a fun emoji tag sequence that starts with the black flag (🏴 `U+1F3F4`) and ends
with a special cancel tag character code (`U+E007F`).

If we read the [ISO 3166-2:GB](https://en.wikipedia.org/wiki/ISO_3166-2:GB) article and
cross-reference this with Unicode's published list of [emoji sequences](https://www.unicode.org/Public/emoji/latest/emoji-sequences.txt), we can see the
following sequences let us specify the following flags:

| Unicode | Code | Flag | Subdivision |
|---------|------|------|-------------|
| `U+1F3F4` `U+E0067` `U+E0062` `U+E0065` `U+E006E` `U+E0067` `U+E007F` | 🏴GBENG✦ | 🏴󠁧󠁢󠁥󠁮󠁧󠁿 | England |
| `U+1F3F4` `U+E0067` `U+E0062` `U+E0073` `U+E0063` `U+E0074` `U+E007F` | 🏴GBSCT✦ | 🏴󠁧󠁢󠁳󠁣󠁴󠁿 | Scotland |
| `U+1F3F4` `U+E0067` `U+E0062` `U+E0077` `U+E006C` `U+E0073` `U+E007F` | 🏴GBWLS✦ | 🏴󠁧󠁢󠁷󠁬󠁳󠁿 | Wales |

We can then build off the previous function we built to add a subdivision variation:

```swift
func emojiFlag(subdivision: String) -> String? {
  guard let blackFlag = Unicode.Scalar(0x1F3F4),
        let cancelTag = Unicode.Scalar(0xE007F) else {
    return nil
  }
  // https://en.wikipedia.org/wiki/Tags_(Unicode_block)
  let tagLetterOffset: UInt32 = 0xE0061
  let alphabetOffset = UnicodeScalar(unicodeScalarLiteral: "a").value
  return String(Character(blackFlag)) + String(subdivision
    .lowercased()
    .unicodeScalars
    .compactMap { Unicode.Scalar(
      tagLetterOffset + ($0.value - alphabetOffset)
    )}
    .map { Character($0) }
  ) + String(Character(cancelTag))
}

emojiFlag(subdivision: "GBENG") // "🏴󠁧󠁢󠁥󠁮󠁧󠁿"
emojiFlag(subdivision: "GBSCT") // "🏴󠁧󠁢󠁳󠁣󠁴󠁿"
emojiFlag(subdivision: "GBWLS") // "🏴󠁧󠁢󠁷󠁬󠁳󠁿"
```

Pretty neat!
