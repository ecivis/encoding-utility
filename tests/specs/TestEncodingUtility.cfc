component extends="testbox.system.BaseSpec" {

    function run() {

        describe("Encoding Utility", function () {
            beforeEach(function () {
                encodingUtility = createObject("component", "models.EncodingUtility").init();
            });

            it("has a functional substitute method", function () {
                var bytes = 0;
                var input = "";
                var expected = "";
                var c = {
                    n: chr(10),
                    t: chr(9)
                };

                expect(encodingUtility.substitute("foo bar boo baz")).toBe("foo bar boo baz");

                bytes = javaCast("byte[]", [72, 105]);
                input = createObject("java", "java.lang.String").init(bytes, "UTF-8");
                expected = "Hi";
                expect(encodingUtility.substitute(input)).toBe(expected);

                bytes = javaCast("byte[]", [74, 111, 115, -23]);
                input = createObject("java", "java.lang.String").init(bytes, "ISO-8859-1");
                expected = "Jose";
                expect(encodingUtility.substitute(input)).toBe(expected);

                // 18 U.S.C. § 2074
                bytes = javaCast("byte[]", [49, 56, 32, 85, 46, 83, 46, 67, 46, 32, -89, 32, 50, 48, 55, 52]);
                input = createObject("java", "java.lang.String").init(bytes, "Cp1252");
                expected = "18 U.S.C.  2074";
                expect(encodingUtility.substitute(input)).toBe(expected);

                input = "Let’s get some 🍺";
                expected = "Let's get some ";
                expect(encodingUtility.substitute(input)).toBe(expected);

                input = "Reasons:#c.n##c.t#• One#c.n##c.t#• Two#c.n##c.t#• Three";
                expected = "Reasons:#c.n##c.t#* One#c.n##c.t#* Two#c.n##c.t#* Three";
                expect(encodingUtility.substitute(input)).toBe(expected);
            });

            it("returns the correct string details", function () {
                var stringDetails = {};
                var bytes = 0;
                var input = "";

                stringDetails = encodingUtility.getStringDetails("Ordinary User Content");
                expect(stringDetails.isBasicLatin).toBe(true);
                expect(stringDetails.characterCount).toBe(21);
                expect(arrayLen(stringDetails.utf8Hex)).toBe(21);
                expect(arrayLen(stringDetails.utf8Bytes)).toBe(21);
                expect(arrayLen(stringDetails.codePoints)).toBe(21);

                stringDetails = encodingUtility.getStringDetails("🍻Fancy User Content🍻");
                expect(stringDetails.isBasicLatin).toBe(false);
                expect(stringDetails.characterCount).toBe(22);
                expect(arrayLen(stringDetails.utf8Hex)).toBe(26);
                expect(arrayLen(stringDetails.utf8Bytes)).toBe(26);
                expect(arrayLen(stringDetails.codePoints)).toBe(20);

                // Windows “User” Content
                // 1234567890123456789012
                bytes = javaCast("byte[]", [87, 105, 110, 100, 111, 119, 115, 32, -109, 85, 115, 101, 114, -108, 32, 67, 111, 110, 116, 101, 110, 116]);
                input = createObject("java", "java.lang.String").init(bytes, "Cp1252");
                stringDetails = encodingUtility.getStringDetails(input);
                expect(stringDetails.isBasicLatin).toBe(false);
                expect(stringDetails.characterCount).toBe(22);
                expect(arrayLen(stringDetails.utf8Hex)).toBe(26);
                expect(arrayLen(stringDetails.utf8Bytes)).toBe(26);
                expect(arrayLen(stringDetails.codePoints)).toBe(22);
            });

            it("correctly finds Basic Latin strings", function () {
                expect(encodingUtility.isBasicLatin("foo bar")).toBe(true);
                expect(encodingUtility.isBasicLatin("Microsoft® Skype® for Business™ for Mac®")).toBe(false);
            });

            it("requires input", function () {
                expect(function () { encodingUtility.substitute(); }).toThrow(type="expression", regex=".*parameter input.*required.*");
                expect(function () { encodingUtility.isBasicLatin(); }).toThrow(type="expression", regex=".*parameter input.*required.*");
                expect(function () { encodingUtility.getStringDetails(); }).toThrow(type="expression", regex=".*parameter input.*required.*");
            });
        });
    };

}