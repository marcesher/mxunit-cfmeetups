-------------------------
WHAT IS THIS?
-------------------------

We believe practice is important. "Play" is important. This challenge involves taking a hard-to-test component, which already has a "Brute Force" set of tests, and refactoring both the test and the code using the patterns we've talked about in this session. 

Here's a chance to apply these concepts to make the PDFThumbnailGenerator component easier to test while still retaining its existing runtime functionality.

The idea here will be to continue to test exactly the same things as the existing tests, but doing it in such a way that the tests are faster and do less work. 

This is not easy! But if you can fight through this, even if you only get part way, you'll have come a long way in designing code for testability.

Big Tip: If you look at the existing test, you'll see that it basically runs the generator for a given set of input files, lets the generator generate PDF files, then looks at the file system to ensure those files were written. What you should be thinking is this: "How do I refactor PDFThumbnailGenerator in such a way that it can tell me what it did (or is going to do) so that I can test the functionality without actually generating PDF files. What you should be thinking here is "extract method". You should also be asking yourself, "What is it about the existing component that is so hard to test?" Hint.... cfthread and cfpdf.

Struggle through this a bit. Play around. When you're ready, post your solution(s) and/or questions to the MXUnit Google group.