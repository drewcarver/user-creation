module.exports = {
  testRegex: "(/__tests__/.*|(\\.|/)(test|spec))\\.(jsx?|js?|tsx?|ts?)$",
  transform: {
  },
  transformIgnorePatterns: ["./node_modules"],
  testPathIgnorePatterns: ["<rootDir>/build"],
  moduleFileExtensions: ["js", "jsx", "mjs"]
}
