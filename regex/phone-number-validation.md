# Phone Number  Validation and Formatting

I don't recommend using these regexes for hardcore validation -- Google maintains [libphonenumber](https://github.com/google/libphonenumber) a much better library for validating phone numbers in Java, Javascript and C++, which includes all kinds of cool features -- it may be overkill for javascript on the web, but it's great for backend or app developers. 

## Generic international phone number matcher.

```
\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$
```

## US / Canada phone matcher 

not sure what the differences are here or which one is which...I'm assuming the first one is for the US and the other is for Canada, but I could be wrong. 

```
1?\W*([2-9][0-8][0-9])\W*([2-9][0-9]{2})\W*([0-9]{4})(\se?x?t?(\d*))?
```

```
^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$
```

## UK

```
^(?:(?:\(?(?:0(?:0|11)\)?[\s-]?\(?|\+)44\)?[\s-]?(?:\(?0\)?[\s-]?)?)|(?:\(?0))(?:(?:\d{5}\)?[\s-]?\d{4,5})|(?:\d{4}\)?[\s-]?(?:\d{5}|\d{3}[\s-]?\d{3}))|(?:\d{3}\)?[\s-]?\d{3}[\s-]?\d{3,4})|(?:\d{2}\)?[\s-]?\d{4}[\s-]?\d{4}))(?:[\s-]?(?:x|ext\.?|\#)\d{3,4})?$
```

## Germany

```
/^([\+][0-9]{1,3}[ \.\-])?([\(]{1}[0-9]{1,6}[\)])?([0-9 \.\-\/]{3,20})((x|ext|extension)[ ]?[0-9]{1,4})?$/
```

## China

```
^(13[0-9]|14[57]|15[012356789]|17[0678]|18[0-9])[0-9]{8}$
1[34578][012356789]\d{8}|134[012345678]\d{7}
```

## Russia

```
^((\+7|7|8)+([0-9]){10})$
```

## Japan

```
^(?:\d{10}|\d{3}-\d{3}-\d{4}|\d{2}-\d{4}-\d{4}|\d{3}-\d{4}-\d{4})$
```

## India

OLD:

```
((\+*)(0*|(0 )*|(0-)*|(91 )*)(\d{12}+|\d{10}+))|\d{5}([- ]*)\d{6}
```

NEW:

```
((\+*)((0[ -]+)*|(91 )*)(\d{12}+|\d{10}+))|\d{5}([- ]*)\d{6}
```

## Indonesia

```
\(?(?:\+62|62|0)(?:\d{2,3})?\)?[ .-]?\d{2,4}[ .-]?\d{2,4}[ .-]?\d{2,4}
```

## Brazil

```
(^|\()?\s*(\d{2})\s*(\s|\))*(9?\d{4})(\s|-)?(\d{4})($|\n)
```