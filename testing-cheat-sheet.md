# Testing Cheat Sheet

## Terminology

From [Martin Fowler](https://martinfowler.com/bliki/TestDouble.html):

- **Dummy** objects are passed around but never actually used. Usually they are just used to fill parameter lists.
- **Fake** objects actually have working implementations, but usually take some shortcut which makes them not suitable for production (an [InMemoryTestDatabase](https://martinfowler.com/bliki/InMemoryTestDatabase.html) is a good example).
- **Stubs** provide canned answers to calls made during the test, usually not responding at all to anything outside what's programmed in for the test.
- **Spies** are stubs that also record some information based on how they were called. One form of this might be an email service that records how many messages it was sent.
- **Mocks** are pre-programmed with expectations which form a specification of the calls they are expected to receive. They can throw an exception if they receive a call they don't expect and are checked during verification to ensure they got all the calls they were expecting.

## Test Driven Development

1. define a test set for the unit *first*
2. make the tests fail
3. then implement the unit
4. finally verify that the implementation of the unit makes the tests succeed

## Unit Testing



## Mocks, Fakes, Stubs and More

### Difference between Mocks and Stubs:

> This difference is actually two separate differences. On the one hand there is a difference in how test results are verified: a distinction between state verification and behavior verification. On the other hand is a whole different philosophy to the way testing and design play together, which I term here as the classical and mockist styles of [Test Driven Development](https://martinfowler.com/bliki/TestDrivenDevelopment.html).
>
> -- Martin Fowler - [Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html)

### Difference between Mocks and Fakes:

- The difference between testing with mocks vs fakes is that mocks are used to test behavior whereas fakes are used to test state.
  -- From Medium Article: [Mocking is not practical - Use Fakes](https://medium.com/@june.pravin/mocking-is-not-practical-use-fakes-e30cc6eaaf4e)

### What to Mock:

- Do not mock types you don’t own
- Don’t mock value objects
- Don’t mock everything

### Fakes





## Which testing frameworks/libs should I use?

### Java

- JUnit
- Mockito

### Python



### Javascript (Vue/React)

