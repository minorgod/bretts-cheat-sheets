# Regexes Essentials

[TOC]

You might also be interested in 

- [Regex Visualizer](https://emailregex.com/regex-visual-tester/index.html) - to help test regexes

------

## Mini RegEx Cheat Sheet

 This list includes only the common regex syntax I often forget. For full info, go to the **[full cheat sheet](regex-cheat-sheet.md)**.

### Metacharacters

| ------ |                                                              |
| ------ | ------------------------------------------------------------ |
| \w     | Match a **word** character                                   |
| \W     | Match a **non-word** character                               |
| \d     | Match a **digit**                                            |
| \D     | Match any **non-digit** character                            |
| \s     | Match a **whitespace** character                             |
| \S     | Match a **non-whitespace** character                         |
| \b     | **Word boundary** -- Match whitespace, punctuation or the start/end of a word. |
| \B     | **Non-Word Boundary** -- Match a character that is not punctuation, whitespace or at the beginning or end of a word |
| \0     | Match a **NUL** character                                    |
| \t     | Match a **tab** character                                    |
| \xxx   | Match a character specified by **octal** number xxx          |
| \xdd   | Match a character specified by **hexadecimal** number dd     |
| \uxxxx | Match a Unicode character specified by **hexadecimal** number xxxx |

### Quantifiers

|        |                                 |
| ------ | ------------------------------- |
| n?     | Match zero or one n             |
| n{X}   | Match sequence of X n's         |
| n{X,Y} | Match sequence of X to Y n's    |
| n{X,}  | Match sequence of X or more n's |

## Miscellaneous Regular Expressions

Note**: these regexes do not include the start/end delimiters unless they require modifiers such as "g" or "i" to denote global or case-insensitive behavior. Unless specified, they are in perl regex syntax or POSIX extended syntax. PHP users can assume they are PCRE. 

### camelCase matcher

From [Google Style Guide](https://google.github.io/styleguide/javaguide.html#s5.3-camel-case) variable naming conventions docs - regex to match all **strict lowercase** camel case.

```spreadsheet
[a-z]+((\d)|([A-Z0-9][a-z0-9]+))*([A-Z])?
```

or this one which uses word boundary meta chars

```
/\b[a-z]+((\d)|([A-Z0-9][a-z0-9]+))*([A-Z])?\b/g
```

### PascalCase Matcher 

```
/\b[A-Z][a-z0-9]+?([A-Z0-9]?[a-z0-9]*)+\b/g
```

or this seems to work also

```
/[A-Z]+([a-z0-9]+)*([a-z])?/g
```

### Invalid CSS pseudoselector format matcher

Regex to find colons not preceeded by another colon or ampersand and not followed by a space or any other string that would denote a pseudo-selector class that shouldn't have a space before it.  This was a beast to write. Enjoy!

```
((?<!&)(?<!:)(:)(?! |:|\-|\/|active|checked|disabled|empty|enabled|first-child|first-of-type|focus|hover|in-range|invalid|lang|last-child|last-of-type|link|not|nth-child|nth-last-child|nth-last-of-type|nth-of-type|only-of-type|only-child|optional|out-of-range|read-only|read-write|required|root|target|valid|visited|after|before|first-letter|first-line|selection))
```

### Email address matchers

- See: [Email Validation](email-validation.md)


### IP Address Matchers

- See : [IP Address Validation](ip-address-validation.md)


### Phone Number Matchers

- See: [Phone Number Validation](phone-number-validation.md)


### URL matchers

- See: [URL Validation](url-validation.md)


