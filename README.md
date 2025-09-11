# paletter

An obviously-named Swift command-line tool for converting [tinted-theming](https://github.com/tinted-theming) yaml scheme files into MacOS `.clr` palette files. These are Apple binary property lists with a very NextStep-specific structure, so they need ObjC or Swift code to generate. This is, unbelievably, *another* tool in a long series of tools that solve extremely specific problems that nobody else has.

How to use:

- Clone [tinted-theme's schemes repo](https://github.com/tinted-theming/schemes) somewhere.
- Run `paletter path/to/schemes/base16` or `base24`; it handles both. You can optionally give it an output directory. Without an output directory, it writes all its palette files to the input directory.
- Move all the resulting `.clr` files to `~/Library/Colors` (if you didn't output them there in the first place) and restart whichever application you want to see them show up in.

You probably need run a tool like this only once to get more color palettes than you ever dreamed of having.

Enjoy!

## Limitations

It doesn't do anything at all smart about overwriting files or being well-behaved about output. It'll log and exit when it encounters any error at all.

## LICENSE

This code is licensed via [the Parity Public License.](https://paritylicense.com) This license requires people who build on top of this source code to share their work with the community, too. This means if you hack on it for work, you have to share what you built for your employer somehow. See the license text for details.
