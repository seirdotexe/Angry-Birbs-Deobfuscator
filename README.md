# Angry Birbs Deobfuscator

All the tools you need to deobfuscate [Angry Birds Breakfast 1](http://www.mediafire.com/file/632g9ek4hwatsrw/Angry+Birds+Breakfast+1.exe) and to create a fully deobfuscated SWF.

# How is this possible?

The SWF is obfuscated with a tool called [SecureSWF](http://www.kindi.com/). When this tool obfuscates important names in Actionscript code, it spits out a `secure_map.xml` file. In that file, everything is defined what is what. Rovio forgot to remove this file in their release, so we can take advantage of it.

# Copyright

I don't own the Mediafire link, nor do I own the XML file that Rovio left there.
