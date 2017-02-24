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

                expect(encodingUtility.substitute("foo bar boo baz")).toBe("foo bar boo baz");

                bytes = javaCast("byte[]", [72, 105]);
                input = createObject("java", "java.lang.String").init(bytes, "UTF-8");
                expected = "Hi";
                expect(encodingUtility.substitute(input)).toBe(expected);

                bytes = javaCast("byte[]", [74, 111, 115, -23]);
                input = createObject("java", "java.lang.String").init(bytes, "ISO-8859-1");
                expected = "Jose";
                expect(encodingUtility.substitute(input)).toBe(expected);

            });

        });
    };

}