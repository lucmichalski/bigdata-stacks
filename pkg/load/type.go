package load

const defaultTestSuitePath = "test/testsuite"
const defaultVariablePath = "test/variable"

type ConfImport struct {
	// Frequency for Re-Read paths for new tests
	// Yes it's a string, the conversion to duration is made later to allow other units > h
	Frequency string
	Git       ConfGit
	Testfiles ConfTestfiles
	Variables ConfVariables
}

type ConfGit struct {
	Clone bool `toml:"clone"`
	// Final Branch to checkout
	Branch string `toml:"branch"`
	// URL Repo Git
	Repo string `toml:"repo"`
	// Destination Path to clone
	Path string `toml:"path"`
	// Allow x509: certificate signed by unknown authority
	AllowInsecure bool `toml:"allowinsecure"`
}

type ConfTestfiles struct {
	Included []string `toml:"included"`
	Excluded []string `toml:"excluded"`
}
type ConfVariables struct {
	Variables []string `toml:"variables"`
	Included  []string `toml:"included"`
	Excluded  []string `toml:"excluded"`
	Fromenv   bool     `toml:"fromenv"`
}
