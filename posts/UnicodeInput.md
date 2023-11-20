---
title: Unicode input, keyboards, and windows
author: me
date: 2023-11-20
tags: QMK, hardware, unicode, windows
mathjax: off
---

## Unicode input and programmable keyboards

One of selling points of programmable keyboards are `macros` - sequences of keytaps sent to the host machine triggered by a smaller number of taps on the keyboard.

I took a Moonlander keyboard, running on a (subset of) QMK firmware, but most points apply to all QMK-based builds.

I also prefer to use Oryx, a WYSIWYG configurator for ZSA's keyboards.

The goals of the exercise is to input French characters like `çéèêëîïôæœüûàù` without much trouble,
preferrably with a single keystroke. The host machine is a Win10.

Without further ado, here are the methods that I found.

### Alt codes

There is an always-on functionality that would allow entering unicode with `Alt` and numpad: for example, switch to a `US` layout, hold `Alt` and hit `0,2,3,1` on numpad, you will get a `ç` character.
This method, however, comes with a giant imitation - not all software handle these sequences correctly. MS  Office suite has some issues, with no clear way to fix them. On top of that, these issues are **very** annoying.

My personal beef is with Outlook. Start writing a new email in French. Input any such macro (e.g. `Alt+0231`), see `ç` appear - so far, so good. Now hit another key (e.g. `a`) - and voilà, another copy of `ç` appears instead!

For words like `"généré"` ("generated") the outcome is mangled beyond recognition.

Also, this method is language-specific. And as you might have guessed, requires `NumLock on`.


### Alt Hex codes

- this windows feature is hidden behind a registry flag
- if I am not mistaken, these codes follow `win1252`, not unicode.
- the macros are too long; hardcoding them in Oryx is even more tedious (and some codes do not fit Oryx limitations!)

I did not try this approach.

### Alt+X

A rather limited set of software supports this method: enter the hex value of the character, hit `alt+x`, the code is replaced by the character. To my knowledge, only MS Office suite supports it; I quickly discarded this approach as non-consequential.


### Wincompose approach

QMK documentation recommends this method. `Wincompose` is a third-party program that triggers on a `compose` key (default is `ralt`), and then listens on consequtive keypresses; if it sees a known sequence, it outputs a corresponding character. For example, in default setting, the sequence ``ralt, `, E`` would produce an `È`.

The positive side is obvious:

- there is some logic in these sequences
- macros are shorter
- no more buggy input in Outlook!

The drawbacks are quite obvious, too:

- this approach requires something running on the host machine
- Oryx adds artificial delays of `100`ms; I contacted ZSA support, they are not willing to add an option to reduce this delay.

### Remapper on the host

This approach is similar to the previous one - run a remapper like `kanata`/`kmonad`/etc on the host machine, define layers and remappings, and since they are running on the host, you have a sure way to input unicode. I use this approach on machines that are not connected to a programmable keyboard.

### US International layout with dead keys

This approach works only if you are willing to limit youself to unicode characters present in this layout.

Pros:

- nothing to run on the host system, just change the OS keyboard layout
- suddenly the unicode input from the keyboard works on linux machines, too (if they are running the same keyboard layout, of  course)

Cons:

- not everything is there; (e.g. `æ`), you will need other approaches for such characters. Admittedly, this is a rather rare thing to type in my daily life.
- `` "`^'~ `` all become dead keys, so you'll need macros to input them as standalone characters, and some features of QMK will become unnecessarily complicated to use (like "autoshift").


## Conclusion

Unicode input is very much a problem, often overlooked because users are willing to skip on rare characters like `æ` or because their native OS keyboard layout cover their needs.

Another point is that my use case is rather fringe - I want to input both pure English and French while using a single OS layout. I am not talking about entering cyrillic text, that would be an even more complex endeavor, I'll stick with my `ЙЦУКЕН` OS layout for now.

Personnally, the easiest solution for me is the `wincompose` one - it requires almost no setup on the host and macros are easy to hardcode in Oryx. QMK has them built in, if I am not mistaken.

### References

[Unicode input, wikipedia](https://en.wikipedia.org/wiki/Unicode_input)

[Alt codes, wikipedia](https://en.wikipedia.org/wiki/Alt_code)

[MS on entering unicode](https://support.microsoft.com/en-us/office/insert-ascii-or-unicode-latin-based-symbols-and-characters-d13f58d3-7bcb-44a7-a4d5-972ee12e50e0)

[Various flavors of alt code entering](https://www.fileformat.info/tip/microsoft/enter_unicode.htm)

[Oryx](https://configure.zsa.io)

[QMK documentation](https://docs.qmk.fm/#/feature_unicode)
