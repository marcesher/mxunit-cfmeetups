INSTINCTS
--------------
code in the instincts directory is intended to be representative of "stuff that makes testing hard".


REFACTORING
---------------
the corresponding directories in the refactoring directory show how one might approach refactoring out the "stuff that makes testing hard". Basically, dependencies are pulled into separate functions and "mocked" in the unit tests via MXUnit's injectMethod() function.

The two directories suffixed with "mightymocked" show how you would use MXUnit's MightyMock framework to do mocking instead of using injectMethod(). Using a mock framework confers greater advantages because you can run verifications on the mocked functions. 

Several fine mock frameworks exist for ColdFusion: Brian Kotek's ColdMock, Michael Steele's CFEasyMock (a port of the java EasyMock framework), Luis Majano's ColdBox Mock Factory, and MXUnit's own MightyMock (not yet released).

The real benefit in looking at the code in the refactoring directory comes not from running the tests, but from comparing the code with its correlary code in the "instincts" directory. Seeing how the functions change in order to make testing easier is very instructive