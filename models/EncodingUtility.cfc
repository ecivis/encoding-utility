component {

    /**
    * This component is thread-safe; feel free to retain/share one instantiation
    */
    public EncodingUtility function init() {
        return this;
    }

    /**
    * Perform reasonable substitutions to convert the input to Basic Latin
    * @input An ordinary CFML string value to be processed
    */
    public string function substitute(required string input) {
        var result = arguments.input;
        var nonBasicLatinPattern = createObject("java", "java.util.regex.Pattern").compile("[^\x00-\x7f]");
        var subs = getSubstitutionMap();
        var sub = [];

        // If the input is already Basic Latin, no need to continue
        if (not nonBasicLatinPattern.matcher(result).find()) {
            return result;
        }

        // Replace Unicode code points in the substitution map
        for (sub in subs) {
            result = result.replaceAll("\u" & sub[2], sub[3]);
        }

        // Finally, remove any leftovers
        result = nonBasicLatinPattern.matcher(result).replaceAll("");

        return result;
    }

    /**
    * Perform substitutions without breaking JSON serialization
    * @input A string of JSON content to be processed
    */
    public string function substituteForJSON(required string input) {
        var result = arguments.input;
        var nonBasicLatinPattern = createObject("java", "java.util.regex.Pattern").compile("[^\x00-\x7f]");
        var subs = getSubstitutionMap();
        var sub = [];

        // If the input is already Basic Latin, no need to continue
        if (not nonBasicLatinPattern.matcher(result).find()) {
            return result;
        }

        // Replace Unicode code points in the substitution map, being mindful not to break JSON serialization
        for (sub in subs) {
            if (sub[3] eq chr(34)) {
                result = result.replaceAll("\u" & sub[2], "\\" & sub[3]);
            } else {
                result = result.replaceAll("\u" & sub[2], sub[3]);
            }
        }

        // Finally, remove any leftovers
        result = nonBasicLatinPattern.matcher(result).replaceAll("");

        return result;
    }

    /**
    * Returns a structure of string details
    * @input An ordinary CFML string value to be processed
    */
    public struct function getStringDetails(required string input) {
        var result = {};

        result["utf8Bytes"] = arguments.input.getBytes("UTF-8");
        result["utf8Hex"] = binaryEncode(result.utf8Bytes, "hex").split("(?<=\G.{2})");

        result["characterCount"] = arguments.input.length();
        result["codePoints"] = arguments.input.codePoints().toArray();
        result["isBasicLatin"] = _isBasicLatin(result["codePoints"]);
        return result;
    }

    /**
    * Scans a CFML string for any code points above 127
    * @input An ordinary CFML string value to be scanned
    */
    public boolean function isBasicLatin(required string input) {
        return _isBasicLatin(arguments.input.codePoints().toArray());
    }


    /**
    * Make-believe overloaded function
    * @codePoints If you already have an array of code points, send 'em here for scanning
    */
    private boolean function _isBasicLatin(required array codePoints) {
        var codePoint = 0;

        // Seek out any code points greater than Basic Latin
        // See http://unicode.org/charts/PDF/U0000.pdf
        for (codePoint in arguments.codePoints) {
            if (codePoint > 127) {
                return false;
            }
        }
        return true;
    }

    /**
    * Returns a collection of code point substitutions that seem least likely to upset everyone
    */
    private array function getSubstitutionMap() {
        if (structKeyExists(variables, "substitutionMap")) {
            return variables.substitutionMap;
        }

        variables.substitutionMap = [
            ["80", "20ac", "E"],
            ["82", "201a", ","],
            ["83", "0192", "f"],
            ["84", "201e", ","],
            ["85", "2026", "."],
            ["8a", "0160", "S"],
            ["8b", "2039", "("],
            ["8c", "0152", "O"],
            ["8e", "017d", "Z"],
            ["91", "2018", "'"],
            ["92", "2019", "'"],
            ["93", "201c", '"'],
            ["94", "201d", '"'],
            ["95", "2022", "*"],
            ["96", "2013", "-"],
            ["97", "2014", "-"],
            ["98", "02dc", "~"],
            ["9a", "0161", "s"],
            ["9b", "203a", ")"],
            ["9c", "0153", "o"],
            ["9e", "017e", "z"],
            ["9f", "0178", "Y"],
            ["f1", "00f1", "n"],
            ["e1", "00e0", "a"],
            ["f3", "00f3", "o"],
            ["f6", "00f6", "o"],
            ["c0", "00c0", "A"],
            ["c1", "00c1", "A"],
            ["c2", "00c2", "A"],
            ["c3", "00c3", "A"],
            ["c4", "00c4", "A"],
            ["c7", "00c7", "C"],
            ["c8", "00c8", "E"],
            ["c9", "00c9", "E"],
            ["ca", "00ca", "E"],
            ["cb", "00cb", "E"],
            ["cc", "00cc", "I"],
            ["cd", "00cd", "I"],
            ["c3", "00ce", "I"],
            ["cf", "00cf", "I"],
            ["d1", "00d1", "N"],
            ["d2", "00d2", "O"],
            ["d3", "00d3", "O"],
            ["d4", "00d4", "O"],
            ["d5", "00d5", "O"],
            ["d6", "00d6", "O"],
            ["d9", "00d9", "U"],
            ["da", "00da", "U"],
            ["db", "00db", "U"],
            ["dc", "00dc", "U"],
            ["e1", "00e1", "a"],
            ["e2", "00e2", "a"],
            ["e3", "00e3", "a"],
            ["e4", "00e4", "a"],
            ["e7", "00e7", "c"],
            ["e8", "00e8", "e"],
            ["e9", "00e9", "e"],
            ["ea", "00ea", "e"],
            ["eb", "00eb", "e"],
            ["eb", "00ec", "i"],
            ["eb", "00ed", "i"],
            ["eb", "00ee", "i"],
            ["eb", "00ef", "i"],
            ["eb", "00f2", "o"],
            ["eb", "00f3", "o"],
            ["eb", "00f4", "o"],
            ["eb", "00f5", "o"],
            ["eb", "00f9", "u"],
            ["eb", "00fa", "u"],
            ["eb", "00fb", "u"],
            ["eb", "00fc", "u"],
            ["fd", "00fd", "y"],
            ["dd", "00dd", "Y"]
        ];

        return variables.substitutionMap;
    }

}