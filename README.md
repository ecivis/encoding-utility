# Encoding Utility

This is a ColdBox Module to assist in resolving character encoding issues. For example, when a legacy database supports only 7-bit ASCII, and the modern web application receives user content in UTF-8.

## Requirements
- Lucee 5+
- ColdBox 4+

## Installation

Install using [CommandBox](https://www.ortussolutions.com/products/commandbox):
`box install encoding-utility`

## Usage

Within the component you'd like to make use of the Identity Utlity, have WireBox inject an instance for you from the module's namespace:
```
property name="encutil" inject="encodingUtility@EncodingUtility";
```
These are the methods implemented:
- `containsHighBitBytes(string input)` Tests the input for any bytes with the most significant bit on.
- `substitute(string input)` Returns the content with reasonable substitutions made. For example, "é" becomes "e".

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations (MIT).
