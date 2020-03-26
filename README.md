# Kakitori

Kakitori helps with learning Japanese kanji by presenting quizes to encourage regular writing practice.  Kakitori (書取 or more typically 書き取り) refers writing down spoken material, or in this case, transcribing kana (かな) into kanji (漢字).

Kakitori relies on user self-grading, but integrates stroke order data from the [KanjiVG](https://kanjivg.tagaini.net/) project to make checking as easy as possible.  It tracks results, can generate quizes to cover a certain amount of material in a given period of time, provides review prompts, and allows for the creation of custom kanji groups so that users can practice sets of kanji they are learning through other methods.

Default included categories include the Japan Kanji Ability Exam (日本漢字能力試験), more commonly known as Kanken (漢検) for the Jōyō Kanji for daily use (常用漢字), as well as WaniKani levels.

## Building

### External Dependecies

#### Tests

Kakitori uses [OCMock](https://ocmock.org/) for testing.  OCMock is not required to build the main application, but it is required to build and run the tests.  The project is configured to use the iOS static library avilable for download from the official site.  The top-level folder structure should be setup as follows:

    -+-(project root)
     |-- Kakitori.xcodeproj
     |-- Kakitori/ (app root)
     |-- KakitoriTests/ (unit test root)
     \+- deps/
      |+- include/
      |\+- OCMock/
      | |-- (OCMock headers)
      | \-- ...
      \+- lib/
       \-- libOCMock.a

